//
//  WeatherManager.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/30.
//

import Foundation
import SwiftUI

public class WeatherManager {
    let specifiedPlace: Int
    static let shared = WeatherManager()
    
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
    
    func fetchWeather() async throws -> Weather? {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        var url: URL?
        if let location = self.locationFetcher.lastKnownLocation {
            url = URL(string: String(format: Constants.openWeatherMapUrlByCooridnates, arguments: [location.latitude, location.longitude]))
        } else {
            url = URL(string: String(format: Constants.openWeatherMapUrlByLocationId, arguments: [specifiedPlace]))
        }
        
        guard let requestUrl = url else {
            throw APIError.urlError
        }
        print("testtest \(requestUrl)")
        let request = URLRequest(url: requestUrl)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.noStatusCodeError
        }
        
        switch statusCode {
            
        case 100..<200:
            throw APIError.informationalError
            
        case 200..<300:
            guard let decodedResponse = try? JSONDecoder().decode(Weather.self, from: data) else {
                throw APIError.decodeError
            }
            
            return decodedResponse
            
        case 300..<400:
            throw APIError.redirectionError
            
        case 400..<500:
            throw APIError.clientError
            
        case 500..<600:
            throw APIError.serverError
            
        default:
            throw APIError.undefinedError
            
        }
    }
}
