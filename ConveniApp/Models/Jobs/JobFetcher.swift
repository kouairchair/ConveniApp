//
//  JobFetcher.swift
//  ConveniApp
//
//  Created by tanakabp on 2022/10/27.
//

import SwiftUI
import Kanna

public actor JobFetcher {
    static let shared = JobFetcher()
    
    func fetchJobs() async throws -> [Job] {
        logger.debug("fetchJobs started")
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        var jobList: [Job] = []
        try await withTimeout(10) {
            // HiPro Tech
            let fetchMaxPage = 1 // 1, 2ページ目だけ
            for page in 0...fetchMaxPage {
                let hiProTechJobListUrl = Constants.hiProTechUrl + Constants.hiProTechJobListUrlSuffix + String(page)
                let hiProTechData = try await URLSession.shared.getData(urlString: hiProTechJobListUrl)
                let hiProTechHtmlDoc = try HTML(html: hiProTechData, encoding: String.Encoding.utf8)
                let hiProTechArrayObject = hiProTechHtmlDoc.xpath("//div[@class='job-list']")
                var hiProTechjobs: [Job] = []
                hiProTechArrayObject.forEach { obj -> Void in
                    if let titleAndHref = obj.xpath("//a").first,
                       let title = titleAndHref.content,
                       let href = titleAndHref["href"] {
                        print("title:\(title) href:\(href)")
                        var job = Job(jobType: .hiProTech)
                        job.title = title
                        job.href = Constants.hiProTechUrl + href
                        // TODO: need to assign more...
                        hiProTechjobs.append(job)
                    }
                }
                jobList.append(contentsOf: hiProTechjobs)
            }
        }
        
        return jobList
    }
}
