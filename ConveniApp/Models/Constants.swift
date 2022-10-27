//
//  Constants.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/09.
//

import SwiftUI

enum Constants {
    #if DEBUG
    static let isDebug = true
    #else
    static let isDebug = false
    #endif
    
    static let openWeatherMapUrlByLocationIdUrl = "http://api.openweathermap.org/data/2.5/weather?id=%d&appid=71079687dfd907ca6bc66c0355d0392d"
    static let openWeatherMapUrlByCooridnatesUrl = "http://api.openweathermap.org/data/2.5/weather?lat=%.6f&lon=%.6f&appid=71079687dfd907ca6bc66c0355d0392d"
    static let openWeatherMapCurrentAirPollutionUrl =
        "http://api.openweathermap.org/data/2.5/air_pollution?lat=%.6f&lon=%.6f&appid=71079687dfd907ca6bc66c0355d0392d"
    static let openWeatherMapImageUrl = "http://openweathermap.org/img/w/%@.png"
    static let tenkiJpBaseUrl = "https://tenki.jp"
    static let engadgetsUSUrl = "https://www.engadget.com/"
    // static let engadgetsJapanUrl = "https://japanese.engadget.com/" -> 2022年辺りにサイトが閉鎖したっぽい
    // tenki.jp用の現在地のURL
    static var currentLocationUrlStr = ""
    static var weatherTodayTomorrowUrl: String {
        get {
            "\(Constants.tenkiJpBaseUrl)\(self.currentLocationUrlStr)" // e.g. https://tenki.jp/forecast/4/18/5410/15103/
        }
    }
    // static let yahooSankeiNewsUrl = "https://news.yahoo.co.jp/media/san" // -> 量が多すぎるので、一旦使わない
    static let yahooITNewsUrl = "https://news.yahoo.co.jp/topics/it"
    static let yahooFukuokaBC = "https://news.yahoo.co.jp/media/fbsnews" // 量がある程度多いので、https://news.yahoo.co.jp/media/fbsnews?year=2022&month=8&day=18 のように今日だけに絞る
    static let yahooCommentRanking = "https://news.yahoo.co.jp/ranking/comment"
    
    // 開発言語:Java,Swift,Unity,C#、こだわり条件:リモート で検索
    static let hiProTechUrl = "https://tech.hipro-job.jp"
    static let hiProTechJobListUrlSuffix = "/job-search?keys=&pg_skill_id%5B2%5D=2&pg_skill_id%5B22%5D=22&pg_skill_id%5B32%5D=32&pg_skill_id%5B39%5D=39&kodawari_id%5B75%5D=75&sort_by=field_job_published_value&page="
    
    static let saveImageSuffix = "-image"
    static let locationIdFukuoka = 1863967
    static let locationIdToronto = 6167865
    static let archiveButtonWidth: CGFloat = 60
    
    static let locationRequestApprovedNotification = Notification.Name("locationRequestApprovedNotification")
}


func throwError<T>(_ e: Error) throws -> T { throw e }
