//
//  DailyWeather.swift
//  DailyWeather
//
//  Created by headspinnerd on 2021/08/01.
//

import SwiftUI

struct DailyWeather: Identifiable {
    var id = UUID().uuidString

    // 日付
    let date: String
    
    // 天気を表す画像
    let weatherIcon: UIImage?
    
    // 天気(「晴れ」など)
    let weatherDescription: String
    
    // 最高気温
    let highTemperature: String
    
    // 最低気温
    let lowTemperature: String
    
    // 降水確率
    let changeOfRain: String
}
