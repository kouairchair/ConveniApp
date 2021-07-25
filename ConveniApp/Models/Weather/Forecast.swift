//
//  Forecast.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/25.
//

import SwiftUI

// Sample Model and few days data...

struct DayForecast: Identifiable {
    var id = UUID().uuidString
    var day: String
    var celcius: CGFloat
    var image: String
}	

var forecast = [
    DayForecast(day: "Today", celcius: 27, image: "sun.min"),
    DayForecast(day: "Wed", celcius: 24, image: "cloud.sun"),
    DayForecast(day: "Tue", celcius: 22, image: "cloud.sun.bolt"),
    DayForecast(day: "Thu", celcius: 17, image: "sun.max")
    
]
