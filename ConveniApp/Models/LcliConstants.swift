//
//  LocalizationConstants.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/15.
//

import Foundation

enum LcliConstants: String {
    case errorMessage = "Error"
    case fetchLocationFailed = "Fetch.Location.Failed"
    case fetchWeatherFailed = "Fetch.Weather.Failed"
    case fetchNewsFailed = "Fetch.News.Failed"
    
    func translate() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
