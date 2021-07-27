//
//  Constants.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/09.
//

import Foundation

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
    static let locationIdFukuoka = 1863967
    static let locationIdToronto = 6167865
}


func throwError<T>(_ e: Error) throws -> T { throw e }
