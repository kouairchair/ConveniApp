//
//  Constants.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/09.
//

import Foundation

enum Constants {
    static let openWeatherMapUrlByLocationId = "http://api.openweathermap.org/data/2.5/weather?id=%d&appid=71079687dfd907ca6bc66c0355d0392d"
    static let openWeatherMapUrlByCooridnates = "http://api.openweathermap.org/data/2.5/weather?lat=%.6f&lon=%.6f&appid=71079687dfd907ca6bc66c0355d0392d"
    static let locationIdFukuoka = 1863967
    static let locationIdToronto = 6167865
}
