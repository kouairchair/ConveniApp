//
//  Weather_Scraping.swift
//  Weather_Scraping
//
//  Created by headspinnerd on 2021/07/28.
//

import Foundation

#if SCRAPING
struct Weather {    
    var description: String = ""
    var highTemp: String = ""
    var highTempDiff: String = ""
    var lowTemp: String = ""
    var lowTempDiff: String = ""
    var hourlyWeathersToday: [HourlyWeather] = []
    var hourlyWeathersTomorrow: [HourlyWeather] = []
    var tenDaysWeather: [DailyWeather] = []
}
#endif
