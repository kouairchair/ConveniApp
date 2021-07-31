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
        let urlString = "\(Constants.tenkiJpBaseUrl)/search/?keyword=\(currentLocationPostalCode)"
        let htmlSearchPostalCodeData = try await URLSession.shared.getData(urlString: urlString)
        let doc = try HTML(html: htmlSearchPostalCodeData, encoding: String.Encoding.utf8)
        let searchEntryDataNode = doc.xpath("//p[@class='search-entry-data']")
        guard let href = searchEntryDataNode.first?.at_xpath("a")?["href"] else {
            throw APIError.locationUrlError
        }
        
        // 今日・明日の天気のHTMLを取得
        let weatherTodayTomorrowUrl = "\(Constants.tenkiJpBaseUrl)\(href)" // e.g. https://tenki.jp/forecast/4/18/5410/15103/
        let htmlTodayTomorrowData  = try await URLSession.shared.getData(urlString: weatherTodayTomorrowUrl)
        let docTodayTomorrow = try HTML(html: htmlTodayTomorrowData, encoding: String.Encoding.utf8)
        let todayWeatherSectionNode = docTodayTomorrow.xpath("//section[@class='today-weather']")
        guard let weatherWrapDivNode = todayWeatherSectionNode.first?.at_xpath("//div[@class='weather-wrap clearfix']") else {
            throw APIError.scrapingError
        }
        
        // １時間天気のHTMLを取得
        let weatherHourlyUrl = "\(weatherTodayTomorrowUrl)1hour.html"
        let htmlHourlyData  = try await URLSession.shared.getData(urlString: weatherHourlyUrl)
        let docHourly = try HTML(html: htmlHourlyData, encoding: String.Encoding.utf8)
        guard let hourlyWeatherSectionNode = docHourly.xpath("//*[@id='forecast-point-1h-today']").first else {
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
        
        // 1時間毎の天気
        let hourTextArrayObject = hourlyWeatherSectionNode.xpath("//tr[@class='hour']//td")
        let weatherImageArrayObject = hourlyWeatherSectionNode.xpath("//tr[@class='weather']//td")
        let temperatureArrayObject = hourlyWeatherSectionNode.xpath("//tr[@class='temperature']//td")
        let chanceOfRainArrayObject = hourlyWeatherSectionNode.xpath("//tr[@class='prob-precip']//td")
        if hourTextArrayObject.count != 24 || weatherImageArrayObject.count != 24 || temperatureArrayObject.count != 24 || chanceOfRainArrayObject.count != 24 {
            throw APIError.scrapingError
        }
        let hourlyWeather = try (0...23).map { i -> HourlyWeather in
            // 時間（何時台か）
            guard let hourText = hourTextArrayObject[i].content else {
                throw APIError.scrapingError
            }
            // 過去の時間か
            let isPast = hourTextArrayObject[i].xpath("//span[@class='past']").first != nil
            // 天気を表す画像
            guard let weatherImageUrl = weatherImageArrayObject[i].xpath("img").first?["src"] else {
                throw APIError.scrapingError
            }
            // 気温
            guard let temperatureText = temperatureArrayObject[i].content else {
                throw APIError.scrapingError
            }
            // 降水確率
            guard let changeOfRainText = chanceOfRainArrayObject[i].content else {
                throw APIError.scrapingError
            }

            return HourlyWeather(isPast: isPast, hour: hourText, weatherImage: gifImageWithURL(gifUrl: weatherImageUrl), temperature: temperatureText, changeOfRain: changeOfRainText)
        }
        
        return Weather(description: weatherDescription, highTemp: highTempValue, highTempDiff: highTempDiffValue, lowTemp: lowTempValue, lowTempDiff: lowTempDiffValue, hourlyWeather: hourlyWeather)
    }
    
    func gifImageWithURL(gifUrl: String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        guard let source = CGImageSourceCreateWithData(imageData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 30] as CFDictionary
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
        return UIImage(cgImage: imageReference)
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
