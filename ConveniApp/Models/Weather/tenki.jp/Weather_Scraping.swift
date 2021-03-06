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
    var uvIndexWrap: PickupWrap = PickupWrap()
    var clothDriedWrap: PickupWrap = PickupWrap()
    var dressWrap: PickupWrap = PickupWrap()
    var hourlyWeathersToday: [HourlyWeather] = []
    var hourlyWeathersTomorrow: [HourlyWeather] = []
    var tenDaysWeather: [DailyWeather] = []
    var pm2_5Infos: [Pm2_5Info] = []
}
#endif
