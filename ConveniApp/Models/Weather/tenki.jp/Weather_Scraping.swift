//
//  Weather_Scraping.swift
//  Weather_Scraping
//
//  Created by headspinnerd on 2021/07/28.
//

import Foundation

#if SCRAPING
struct Weather {
    let description: String
    let highTemp: String
    let highTempDiff: String
    let lowTemp: String
    let lowTempDiff: String
    let hourlyWeatherToday: [HourlyWeather]
    let hourlyWeatherTomorrow: [HourlyWeather]
}
#endif
