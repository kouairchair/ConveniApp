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
    
    func fetchNews() async throws -> [AppleNews] {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        enum NewsTask {
            case engadgetAppleTask, engadgetAppleJapanTask
        }
        var appleNewsList: [AppleNews] = []
        try await withThrowingTaskGroup(of: (HTMLDocument, NewsTask).self, body: { taskGroup in
            taskGroup.addTask(priority: .low) {
                let engadgetAppleUrl = "https://www.engadget.com/tag/apple"
                let engadgetAppleData  = try await URLSession.shared.getData(urlString: engadgetAppleUrl)
                return (try HTML(html: engadgetAppleData, encoding: String.Encoding.utf8), .engadgetAppleTask)
            }
            taskGroup.addTask(priority: .low) {
                let engadgetAppleJapanUrl = "https://japanese.engadget.com/tag/apple"
                let engadgetAppleJapanData  = try await URLSession.shared.getData(urlString: engadgetAppleJapanUrl)
                return (try HTML(html: engadgetAppleJapanData, encoding: String.Encoding.utf8), .engadgetAppleJapanTask)
            }
            
            for try await finishedHtmlDoc in taskGroup {
                switch (finishedHtmlDoc.1) {
                case .engadgetAppleTask:
                    let docEngadgetApple = finishedHtmlDoc.0
                    if let engadgetAppleNode = docEngadgetApple.xpath("//ul[@data-component='LatestStream']").first {
                        let newsArrayObject = engadgetAppleNode.xpath("//li")
                        var appleNewses: [AppleNews] = []
                        newsArrayObject.forEach { obj -> Void in
                            if let titleAndHref = obj.xpath("//a").first,
                               let title = titleAndHref["title"],
                               let href = titleAndHref["href"] {
                                var appleNews = AppleNews()
                                appleNews.title = title
                                appleNews.href = href
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
                        appleNewsList.append(contentsOf: appleNewses)
                    }
                case .engadgetAppleJapanTask: // main -> ul -> [li] -> a[0]>alt,a[0]>href, / [li] -> a[1]>alt,a[1]>href / [li] -> span[0].content
                    let docEngadgetAppleJapan = finishedHtmlDoc.0
                    if let engadgetAppleJapanNode = docEngadgetAppleJapan.xpath("//main//ul").first {
                        let newsArrayObject = engadgetAppleJapanNode.xpath("//li")
                        var appleNewsesJapan: [AppleNews] = []
                        newsArrayObject.forEach { obj -> Void in
                            if let titleAndHref = obj.xpath("//a").first,
                               let title = titleAndHref["alt"],
                               let href = titleAndHref["href"] {
                                var appleNews = AppleNews()
                                appleNews.title = title
                                appleNews.href = href
                                if obj.xpath("//a").count > 2,
                                   let authorImageUrl = obj.xpath("//a")[2].xpath("img").first?["src"],
                                   let authorName = obj.xpath("//a")[2].xpath("img").first?["alt"] {
                                    appleNews.authorName = authorName
                                    let authorImage = UserDefaults.standard.gifImageWithURL(gifUrl: authorImageUrl)
                                    appleNews.authorImage = authorImage
                                }
                                if let postedTime = obj.xpath("//span").first?.content {
                                    appleNews.postedTime = postedTime
                                    appleNews.postedMinutesAgo = getPostedMinutesAgo(postedTime: postedTime)
                                }
                                appleNewsesJapan.append(appleNews)
                            }
                        }
                        appleNewsList.append(contentsOf: appleNewsesJapan)
                    }
                }
            }
        })
        
        sortAppleNews(appleNewsList: &appleNewsList)
        
        return appleNewsList
    }
    
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
            
        return 0
    }
    
    func sortAppleNews(appleNewsList: inout [AppleNews]) {
        appleNewsList.sort {
            return $0.postedMinutesAgo < $1.postedMinutesAgo
        }
    }
    
    func isRegexMatched(pattern: String, str: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []),
           regex.matches(in: str, range: NSRange(location: 0, length: str.count)).count > 0 {
            return true
        }
        
        return false
    }
    
}
