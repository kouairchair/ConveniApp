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
        try await withThrowingTaskGroup(of: (HTMLDocument, NewsTask).self, body: { taskGroup in
            taskGroup.addTask(priority: .medium) {
                let engadgetAppleUrl = "https://www.engadget.com/tag/apple" //"https://japanese.engadget.com/tag/apple"// main -> ul -> [li] -> a[0]>alt,a[0]>href, / [li] -> a[2]>alt,a[2]>href / [li] -> span[0].content
                let engadgetAppleData  = try await URLSession.shared.getData(urlString: engadgetAppleUrl)
                return (try HTML(html: engadgetAppleData, encoding: String.Encoding.utf8), .engadgetAppleTask)
            }
            
            for try await finishedHtmlDoc in taskGroup {
                switch (finishedHtmlDoc.1) {
                case .engadgetAppleTask:
                    let docEngadgetApple = finishedHtmlDoc.0
                    if let engadgetAppleNode = docEngadgetApple.xpath("//ul[@data-component='LatestStream']").first {
                        let newsArrayObject = engadgetAppleNode.xpath("//li")
                        var appleNewsList: [AppleNews] = []
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
                                appleNewsList.append(appleNews)
                            }
                        }
                        weatherResult.appleNewsList = appleNewsList
                    }
                case .engadgetAppleJapanTask:
                    break
                }
            }
        })
        
        return weatherResult
    }
    
}
