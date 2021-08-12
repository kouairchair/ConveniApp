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
    
    func fetchNews() async throws -> ([AppleNews], [AppleNews]) {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        enum NewsTask {
            case engadgetAppleTask, engadgetAppleJapanTask
        }
        var appleNewsList: ([AppleNews], [AppleNews]) = ([], [])
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
                                    let authorImage = UserDefaults.standard.gifImageWithURL(gifUrl: authorImageUrl)
                                    appleNews.authorImage = authorImage
                                }
                                appleNewses.append(appleNews)
                            }
                        }
                        appleNewsList.0 = appleNewses
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
                                }
                                appleNewsesJapan.append(appleNews)
                            }
                        }
                        appleNewsList.1 = appleNewsesJapan
                    }
                }
            }
        })
        
        return appleNewsList
    }
    
}
