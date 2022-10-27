//
//  WeatherManager.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/30.
//

import Foundation
import SwiftUI

#if SCRAPING
#else
public class WeatherFetcher {
    let specifiedPlace: Int
    static let shared = WeatherFetcher()
    
    let locationFetcher = LocationFetcher()
    
    init() {
        if let _currentPlace = UserDefaults.standard.object(forKey: "specifiedPlace") as? Int {
            specifiedPlace = _currentPlace
        } else {
            UserDefaults.standard.set(Constants.locationIdFukuoka, forKey: "specifiedPlace")
            // TODO: デフォルトの位置はなくす。
            specifiedPlace = Constants.locationIdFukuoka
        }
    }
    
    func startFetch() {
        self.locationFetcher.start()
    }
    
    func fetchWeather() async throws -> Weather {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        var urlString = ""
        if let location = self.locationFetcher.lastKnownLocation {
            urlString = String(format: Constants.openWeatherMapUrlByCooridnatesUrl, arguments: [location.latitude, location.longitude])
        } else {
            urlString = String(format: Constants.openWeatherMapUrlByLocationIdUrl, arguments: [specifiedPlace])
        }
        
        let weatherResponse: Weather = try await URLSession.shared.getDecodedData(urlString: urlString)
            
        return weatherResponse
    }
    
    func fetchWeatherIcon() async throws -> UIImage? {
        let weatherResponse: Weather = try await fetchWeather()
            
        guard let weatherIconStr = weatherResponse.weather.first?.icon else {
            throw WeatherError.noImageName
        }
        
        let urlString = String(format: Constants.openWeatherMapImageUrl, arguments: [weatherIconStr])
        let imageData = try await URLSession.shared.getData(urlString: urlString)
        
        return try UIImage(data: imageData) ?? throwError(WeatherError.imageConvertError)
    }
}

enum WeatherError: Error {
    case noImageName
    case imageConvertError
}
#endif
