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
    static let engadgetsJapanUrl = "https://japanese.engadget.com/"
    // tenki.jp用の現在地のURL
    static var currentLocationUrlStr = ""
    static var weatherTodayTomorrowUrl: String {
        get {
            "\(Constants.tenkiJpBaseUrl)\(self.currentLocationUrlStr)" // e.g. https://tenki.jp/forecast/4/18/5410/15103/
        }
    }
    static let yahooSankeiNewsUrl = "https://news.yahoo.co.jp/media/san"
    
    static let saveImageSuffix = "-image"
    static let locationIdFukuoka = 1863967
    static let locationIdToronto = 6167865
    static let archiveButtonWidth: CGFloat = 60
    
    static let locationRequestApprovedNotification = Notification.Name("locationRequestApprovedNotification")
}


func throwError<T>(_ e: Error) throws -> T { throw e }
