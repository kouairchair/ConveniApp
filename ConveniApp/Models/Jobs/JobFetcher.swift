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
            var jobIndex = 0
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
                        job.index = jobIndex
                        job.href = Constants.hiProTechUrl + href
                        // TODO: need to assign more...
                        hiProTechjobs.append(job)
                        jobIndex += 1
                    }
                }
                jobList.append(contentsOf: hiProTechjobs)
            }
            
            // コデアル
            jobIndex = 0
            for page in 0...fetchMaxPage {
                let pageNum = page + 1 // 1から始まる
                let codealJobListUrl = Constants.codealUrl + Constants.codealJobListUrlSuffix + String(pageNum)
                let codealData = try await URLSession.shared.getData(urlString: codealJobListUrl)
                let codealHtmlDoc = try HTML(html: codealData, encoding: String.Encoding.utf8)
                var codealjobs: [Job] = []
                for divIndex in 3...12 { // 3から始まる
                    let xpath = "//*[@id='app']/div[2]/div/div/div[2]/div[" + String(divIndex) + "]/section/div[2]/h1/a"
                    if let codealJobObject = codealHtmlDoc.at_xpath(xpath) {
                        if let title = codealJobObject.content,
                           let href = codealJobObject["href"] {
                            print("title:\(title) href:\(href)")
                            var job = Job(jobType: .codeal)
                            job.title = title
                            job.index = jobIndex
                            job.href = Constants.codealUrl + href
                            // TODO: need to assign more...
                            codealjobs.append(job)
                            jobIndex += 1
                        }
                    }
                }
                jobList.append(contentsOf: codealjobs)
            }
        }
        
        jobList.sort {
            return $0.index < $1.index
        }
        
        return jobList
    }
}
