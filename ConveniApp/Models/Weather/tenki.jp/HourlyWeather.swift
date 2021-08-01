//
//  HourlyWeather.swift
//  HourlyWeather
//
//  Created by headspinnerd on 2021/07/31.
//

import UIKit

struct HourlyWeather: Identifiable {
    var id = UUID().uuidString
    
    // 過去の時間か
    let isPast: Bool
    
    // 時間（何時台か）
    let hour: String
    
    // 天気を表す画像
    let weatherImage: UIImage?
    
    // 気温
    let temperature: String
    
    // 降水確率
    let changeOfRain: String
    
    // 降水量(グラフの画像と実際の降水量(mm/h))
    let precipitationImage: UIImage?
    let precipitation: String
    
    // 湿度
    let humidity: String
    
    // 風向(画像と実際の風向)
    let windDirectionImage: UIImage?
    let windDirection: String
    
    // 風速（m/s）
    let windSpeed: String
}
