//
//  WeatherManager.swift
//  WeatherManager
//
//  Created by headspinnerd on 2021/07/27.
//

import Foundation
import SwiftUI
import Kanna

#if SCRAPING
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
    
    func fetchLocality() async throws -> String {
        guard let currentLocationLocality = try await locationFetcher.lookUpCurrentLocation()?.locality else {
            throw APIError.locationError
        }
        
        return currentLocationLocality
    }
    
    func fetchWeather() async throws -> Weather {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        guard let currentLocationPostalCode = try await locationFetcher.lookUpCurrentLocation()?.postalCode else {
            throw APIError.locationError
        }
        var urlString = "\(Constants.tenkiJpBaseUrl)/search/?keyword=\(currentLocationPostalCode)"
        var htmlData = try await URLSession.shared.getData(urlString: urlString)
        var doc = try HTML(html: htmlData, encoding: String.Encoding.utf8)
        let searchEntryDataNode = doc.xpath("//p[@class='search-entry-data']")
        guard let href = searchEntryDataNode.first?.at_xpath("a")?["href"] else {
            throw APIError.locationUrlError
        }
        
        let weatherUrl = "\(Constants.tenkiJpBaseUrl)\(href)" // e.g. https://tenki.jp/forecast/4/18/5410/15103/
        htmlData = try await URLSession.shared.getData(urlString: weatherUrl)
        doc = try HTML(html: htmlData, encoding: String.Encoding.utf8)
        let todayWeatherSectionNode = doc.xpath("//section[@class='today-weather']")
        guard let weatherWrapDivNode = todayWeatherSectionNode.first?.at_xpath("//div[@class='weather-wrap clearfix']") else {
            throw APIError.scrapingError
        }
        // 気温(最高)
        guard let highTempValue = weatherWrapDivNode.xpath("//dd[@class='high-temp temp']").first?.at_xpath("//span[@class='value']")?.content else {
            throw APIError.scrapingError
        }
        guard let highTempDiffValue = weatherWrapDivNode.xpath("//dd[@class='high-temp tempdiff']").first?.content else {
            throw APIError.scrapingError
        }
        
        // 気温(最低)
        guard let lowTempValue = weatherWrapDivNode.xpath("//dd[@class='low-temp temp']").first?.at_xpath("//span[@class='value']")?.content else {
            throw APIError.scrapingError
        }
        guard let lowTempDiffValue = weatherWrapDivNode.xpath("//dd[@class='low-temp tempdiff']").first?.content else {
            throw APIError.scrapingError
        }
        
        // 天気
        guard let weatherDescription = weatherWrapDivNode.xpath("//p[@class='weather-telop']").first?.content else {
            throw APIError.scrapingError
        }
        
        return Weather(description: weatherDescription, highTemp: highTempValue, highTempDiff: highTempDiffValue, lowTemp: lowTempValue, lowTempDiff: lowTempDiffValue)
    }
    
    func fetchWeatherIcon() async throws -> UIImage? {
        let urlString = String(format: Constants.openWeatherMapImageUrl, arguments: [""])
        let imageData = try await URLSession.shared.getData(urlString: urlString)
        
        return try UIImage(data: imageData) ?? throwError(WeatherError.imageConvertError)
    }
}

enum WeatherError: Error {
    case noImageName
    case imageConvertError
}
#endif
