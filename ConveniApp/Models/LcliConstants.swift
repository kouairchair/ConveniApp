//
//  LocalizationConstants.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/15.
//

import Foundation

enum LcliConstants: String {
    case errorMessage = "Error"
    case fetchWeatherFailed = "Fetch.Weather.Failed"
    
    func translate() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
