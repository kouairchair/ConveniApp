//
//  NewsManager.swift
//  NewsManager
//
//  Created by tanakabp on 2021/08/12.
//

import SwiftUI
import Kanna

public actor NewsManager {
    static let shared = NewsManager()
    
    func fetchNews() async throws -> [News] {
        print("fetchNews started")
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        var newsList: [News] = []
        
        try await withTimeout(10) {
            // U.S Apple News
            let engadgetAppleUrl = "\(Constants.engadgetsUSUrl)tag/apple"
            let engadgetAppleData  = try await URLSession.shared.getData(urlString: engadgetAppleUrl)
            let appleHtmlDoc = try HTML(html: engadgetAppleData, encoding: String.Encoding.utf8)
            if let engadgetAppleNode = appleHtmlDoc.xpath("//ul[@data-component='LatestStream']").first {
                let newsArrayObject = engadgetAppleNode.xpath("//li")
                var appleNewses: [News] = []
                newsArrayObject.forEach { obj -> Void in
                    if let titleAndHref = obj.xpath("//a").first,
                       let title = titleAndHref["title"],
                       let href = titleAndHref["href"] {
                        var appleNews = News(newsType: .appleNews)
                        appleNews.title = title
                        appleNews.href = Constants.engadgetsUSUrl + href
                        if obj.xpath("//a").count > 2,
                           let authorImageUrl = obj.xpath("//a")[2].xpath("img").first?["src"],
                           let postInfo = obj.xpath("//a")[2].content?.split(separator: ","),
                            postInfo.count >= 2 {
                            let authorName = String(postInfo[0])
                            appleNews.authorName = authorName
                            let postedTime = String(postInfo[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                            appleNews.postedTime = postedTime
                            appleNews.postedMinutesAgo = getPostedMinutesAgo(postedTime: postedTime)
                            let authorImage = UserDefaults.standard.gifImageWithURL(gifUrl: authorImageUrl)
                            appleNews.authorImage = authorImage
                        }
                        appleNewses.append(appleNews)
                    }
                }
                self.sortNewsWithPostedTime(newsList: &appleNewses)
                newsList.append(contentsOf: appleNewses)
            }
            
            // Yahoo News
            let yahooNewsParams = [
                YahooNewsParam(Url: Constants.yahooITNewsUrl, AuthorName: "Yahoo IT News", newsType: .yahooITNews, fetchesOnlyToday: false),
                YahooNewsParam(Url: Constants.yahooFukuokaBC, AuthorName: "FBS福岡放送", newsType: .fukuokaBCNews, fetchesOnlyToday: true),
                YahooNewsParam(Url: Constants.yahooCommentRanking, AuthorName: nil, newsType: .yahooRankingNews, fetchesOnlyToday: false)
            ]
            for yahooNewsParam in yahooNewsParams {
                var url = yahooNewsParam.Url
                if (yahooNewsParam.fetchesOnlyToday) {
                    // TODO: ここはDateクラスのextensionを別ファイルに定義する？
                    let calendar = Calendar.current
                    let year = calendar.component(.year, from: Date())
                    let month = calendar.component(.month, from: Date())
                    let day = calendar.component(.day, from: Date())
                    url = "\(url)?year=\(year)&month=\(month)&day=\(day)"
                }
                let yahooNewsData = try await URLSession.shared.getData(urlString: url)
                let yahooNewsDoc = try HTML(html: yahooNewsData, encoding: String.Encoding.utf8)
                let aTagObjects = yahooNewsDoc.xpath("//a[@class='newsFeed_item_link']")
                var yahooNewsList: [News] = []
                for aTagObj in aTagObjects {
                    if let title = aTagObj.xpath("//div[@class='newsFeed_item_title']").first?.content,
                       let href = aTagObj["href"],
                       let dateTime = aTagObj.xpath("//time").first?.content {
                        var yahooNews = News(newsType: yahooNewsParam.newsType)
                        yahooNews.title = title
                        yahooNews.href = href
                        if let authorName = yahooNewsParam.AuthorName {
                            yahooNews.authorName = authorName
                        } else {
                            if let authorName = aTagObj.xpath("//span[@class='newsFeed_item_media']").first?.content {
                                yahooNews.authorName = authorName
                            } else {
                                yahooNews.authorName = "不明"
                            }
                        }
                        yahooNews.postedTime = dateTime
                        yahooNews.postedMinutesAgo = getPostedMinutesAgo(postedTime: dateTime)
                        yahooNewsList.append(yahooNews)
                    }
                }
                self.sortNewsWithPostedTime(newsList: &yahooNewsList)
                newsList.append(contentsOf: yahooNewsList)
            }
            
            // Remark: Wants to get these two methods out of this withTimeout block but when I tried to do that,
            //         the following error occurred.
            //         "Actor-isolated instance method 'getPostedMinutesAgo(postedTime:)' can not be referenced from a non-isolated context"
            func getPostedMinutesAgo(postedTime: String) -> Int32 {
                let formatter: DateFormatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.dateFormat = "MM.dd.yyyy"
                if let usDate = formatter.date(from: postedTime) {
                    return Int32(Date().timeIntervalSinceReferenceDate - usDate.timeIntervalSinceReferenceDate)
                }
                
                var pattern = ".*ago"
                if isRegexMatched(pattern: pattern, str: postedTime) {
                    func splitFirstNumber(str: String) -> Int32 {
                        let splitItem = str.split(separator: " ")
                        if splitItem.count >= 2 {
                            let firstWord = String(splitItem[0])
                            if firstWord == "a" {
                                return 1
                            } else {
                                return Int32(firstWord) ?? 0
                            }
                        }
                        
                        return 0
                    }
                    
                    pattern = ".*minutes? ago"
                    if isRegexMatched(pattern: pattern, str: postedTime) {
                        return splitFirstNumber(str: postedTime)
                    }
                    pattern = ".*hours? ago"
                    if isRegexMatched(pattern: pattern, str: postedTime) {
                        return splitFirstNumber(str: postedTime) * 60
                    }
                    pattern = ".*days? ago"
                    if isRegexMatched(pattern: pattern, str: postedTime) {
                        return splitFirstNumber(str: postedTime) * 60 * 24
                    }
                }
                
                pattern = "([1-9]|1[1-2])月([1-9]|[1-2][0-9]|30|31)日"
                if isRegexMatched(pattern: pattern, str: postedTime) {
                    let thisYear = Calendar.current.component(.year, from: Date())
                    let postedTimeThisYear = "\(thisYear)年\(postedTime)"
                    formatter.dateFormat = "yyyy年MM月dd日"
                    if let jpDateThisYear = formatter.date(from: postedTimeThisYear) {
                        let result = Int32(Date().timeIntervalSinceReferenceDate - jpDateThisYear.timeIntervalSinceReferenceDate)
                        if result < 0 {
                            let postedTimeLastYear = "\(thisYear - 1)年\(postedTime)"
                            if let jpDateLastYear = formatter.date(from: postedTimeLastYear) {
                                return Int32(Date().timeIntervalSinceReferenceDate - jpDateLastYear.timeIntervalSinceReferenceDate)
                            }
                        } else {
                            return result
                        }
                    }
                }
                
                pattern = ".*前"
                if isRegexMatched(pattern: pattern, str: postedTime) {
                    func splitFirstNumber(str: String) -> Int32 {
                        let zero: Unicode.Scalar = "0"
                        let nine: Unicode.Scalar = "9"
                        var numberStr = ""
                        for letter in str.unicodeScalars {
                            switch letter.value {
                            case zero.value...nine.value:
                                numberStr += String(letter)
                            default:
                                break
                            }
                        }
                        
                        return Int32(numberStr) ?? 0
                    }
                    
                    pattern = ".*分前"
                    if isRegexMatched(pattern: pattern, str: postedTime) {
                        return splitFirstNumber(str: postedTime)
                    }
                    pattern = ".*時間前"
                    if isRegexMatched(pattern: pattern, str: postedTime) {
                        return splitFirstNumber(str: postedTime) * 60
                    }
                    pattern = ".*日前"
                    if isRegexMatched(pattern: pattern, str: postedTime) {
                        return splitFirstNumber(str: postedTime) * 60 * 24
                    }
                }
                
                pattern = "([1-9]|1[1-2])/([1-9]|[1-2][0-9]|30|31)\\([月|火|水|木|金|土|日]\\) ([1-9]|1[0-9]|2[0-3]):[0-5][0-9]"
                if isRegexMatched(pattern: pattern, str: postedTime) {
                    let thisYear = Calendar.current.component(.year, from: Date())
                    let postedTimeThisYear = "\(thisYear)/\(postedTime)"
                    formatter.dateFormat = "yyyy/M/d(EEE) H:mm"
                    formatter.locale = Locale(identifier: "ja_JP")
                    if let jpDateThisYear = formatter.date(from: postedTimeThisYear) {
                        let result = Int32(Date().timeIntervalSinceReferenceDate - jpDateThisYear.timeIntervalSinceReferenceDate)
                        if result < 0 {
                            let postedTimeLastYear = "\(thisYear - 1)年\(postedTime)"
                            if let jpDateLastYear = formatter.date(from: postedTimeLastYear) {
                                return Int32(Date().timeIntervalSinceReferenceDate - jpDateLastYear.timeIntervalSinceReferenceDate)
                            }
                        } else {
                            return result
                        }
                    }
                }
                    
                return 0
            }
            
            func isRegexMatched(pattern: String, str: String) -> Bool {
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   regex.matches(in: str, range: NSRange(location: 0, length: str.count)).count > 0 {
                    return true
                }
                
                return false
            }
        }
        
        sortNews(newsList: &newsList)
        
        print("received appleNewsList")
        return newsList
    }
    
    func sortNewsWithPostedTime(newsList: inout [News]) {
        newsList.sort {
            return $0.postedMinutesAgo < $1.postedMinutesAgo
        }
        var i = 0
        newsList = newsList.map {
            var newNewsList = $0
            newNewsList.index = i
            i += 1
            return newNewsList
        }
    }
    
    func sortNews(newsList: inout [News]) {
        newsList.sort {
            return $0.newsType.getPriority() < $1.newsType.getPriority()
        }
        newsList.sort {
            return $0.index < $1.index
        }
    }
}
