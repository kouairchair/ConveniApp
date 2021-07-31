//
//  HourlyWeather.swift
//  HourlyWeather
//
//  Created by headspinnerd on 2021/07/31.
//

import Foundation
import UIKit

struct HourlyWeather: Identifiable {
    var id = UUID().uuidString
    let isPast: Bool
    let hour: String
    let weatherImage: UIImage?
    let temperature: String
    let changeOfRain: String
}
