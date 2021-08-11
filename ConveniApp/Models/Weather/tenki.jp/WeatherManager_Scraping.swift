//
//  WeatherManager.swift
//  WeatherManager
//
//  Created by headspinnerd on 2021/07/27.
//

import SwiftUI
import Kanna

#if SCRAPING
public actor WeatherManager {
    let specifiedPlace: Int
    static let shared = WeatherManager()
    // tenki.jp用の現在地のURL
    private var currentLocationUrlStr = ""
    private var weatherTodayTomorrowUrl: String {
        get {
            "\(Constants.tenkiJpBaseUrl)\(self.currentLocationUrlStr)" // e.g. https://tenki.jp/forecast/4/18/5410/15103/
        }
    }
    
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
        if let currentLocationLocality = try await locationFetcher.lookUpCurrentLocation()?.locality {
            UserDefaults.standard.set(Constants.locationIdFukuoka, forKey: "lastLocality")
            return currentLocationLocality
        }
        if let lastLocality = UserDefaults.standard.object(forKey: "lastLocality") as? String {
            return lastLocality
        }
        
        throw APIError.locationError
    }
    
    func fetchWeather() async throws -> Weather {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        let currentLocationPostalCode = try await getPostalCode()
        
        if let href = UserDefaults.standard.string(forKey: currentLocationPostalCode) {
            currentLocationUrlStr = href
        } else {
            let urlString = "\(Constants.tenkiJpBaseUrl)/search/?keyword=\(currentLocationPostalCode)"
            let htmlSearchPostalCodeData = try await URLSession.shared.getData(urlString: urlString)
            let doc = try HTML(html: htmlSearchPostalCodeData, encoding: String.Encoding.utf8)
            let searchEntryDataNode = doc.xpath("//p[@class='search-entry-data']")
            guard let href = searchEntryDataNode.first?.at_xpath("a")?["href"] else {
                throw APIError.locationUrlError
            }
            currentLocationUrlStr = href
            UserDefaults.standard.set(href, forKey: currentLocationPostalCode)
        }

        // TODO: implementing
        var weatherResult = Weather()
        
        enum WeatherTask {
            case todayTomorrowTask, hourlyTask, pm2_5Task, engadgetAppleTask
        }
        try await withThrowingTaskGroup(of: (HTMLDocument, WeatherTask).self, body: { taskGroup in
            taskGroup.addTask(priority: .medium) {
                // 今日・明日の天気のHTMLを取得(10日間天気も含む)
                let htmlTodayTomorrowData  = try await URLSession.shared.getData(urlString: self.weatherTodayTomorrowUrl)
                return (try HTML(html: htmlTodayTomorrowData, encoding: String.Encoding.utf8), .todayTomorrowTask)
            }
            
            taskGroup.addTask(priority: .medium) {
                // １時間天気のHTMLを取得
                let weatherHourlyUrl = "\(await self.weatherTodayTomorrowUrl)1hour.html"
                let htmlHourlyData  = try await URLSession.shared.getData(urlString: weatherHourlyUrl)
                return (try HTML(html: htmlHourlyData, encoding: String.Encoding.utf8), .hourlyTask)
            }
            
            taskGroup.addTask(priority: .medium) {
                // PM2.5分布予測
                let currentLocationUrlStrSplit = (await self.currentLocationUrlStr).split(separator: "/")
                if currentLocationUrlStrSplit.count >= 4 {
                    let currentLocalityUrl = "/\(currentLocationUrlStrSplit[1])/\(currentLocationUrlStrSplit[2])/\(currentLocationUrlStrSplit[3]).html"
                    let pm2_5url = "\(Constants.tenkiJpBaseUrl)/pm25\(currentLocalityUrl)"
                    let htmlPm2_5Data  = try await URLSession.shared.getData(urlString: pm2_5url)
                    return (try HTML(html: htmlPm2_5Data, encoding: String.Encoding.utf8), .pm2_5Task)
                } else {
                    // TODO: need to successfully initialize HTMLDocument
                    return (try HTML(html: "", encoding: String.Encoding.utf8), .pm2_5Task)
                }
            }
            
            // TODO: 天気のデータに混じっている。どの画面に出すかも要検討。
            taskGroup.addTask(priority: .medium) {
                let engadgetAppleUrl = "https://www.engadget.com/tag/apple" //"https://japanese.engadget.com/tag/apple"// main -> ul -> [li] -> a[0]>alt,a[0]>href, / [li] -> a[2]>alt,a[2]>href / [li] -> span[0].content
                let engadgetAppleData  = try await URLSession.shared.getData(urlString: engadgetAppleUrl)
                return (try HTML(html: engadgetAppleData, encoding: String.Encoding.utf8), .engadgetAppleTask)
            }
            
            for try await finishedHtmlDoc in taskGroup {
                switch (finishedHtmlDoc.1) {
                case .todayTomorrowTask:
                    let docTodayTomorrow = finishedHtmlDoc.0
                    // 今日・明日の天気(10日間天気も含む)
                    let todayWeatherSectionNode = docTodayTomorrow.xpath("//section[@class='today-weather']")
                    guard let weatherWrapDivNode = todayWeatherSectionNode.first?.at_xpath("//div[@class='weather-wrap clearfix']") else {
                        throw APIError.scrapingError(1)
                    }
                
                    // 気温(最高)
                    weatherResult.highTemp = weatherWrapDivNode.xpath("//dd[@class='high-temp temp']").first?.at_xpath("//span[@class='value']")?.content ?? ""
                    weatherResult.highTempDiff = weatherWrapDivNode.xpath("//dd[@class='high-temp tempdiff']").first?.content ?? ""
                    
                    // 気温(最低)
                    weatherResult.lowTemp = weatherWrapDivNode.xpath("//dd[@class='low-temp temp']").first?.at_xpath("//span[@class='value']")?.content ?? ""
                    weatherResult.lowTempDiff = weatherWrapDivNode.xpath("//dd[@class='low-temp tempdiff']").first?.content ?? ""
                    
                    // 天気(「晴れ」など)
                    weatherResult.description = weatherWrapDivNode.xpath("//p[@class='weather-telop']").first?.content ?? ""
                    
                    // TODO: implementing
                    // 紫外線、洗濯、服装
                    if let pickupWrapSectionNode = docTodayTomorrow.xpath("//div[@class='common-indexes-pickup-wrap']").first {
                       
                    }
                       
                    // 10日間天気のノードを取得（HTMLは今日・明日の天気と同様）
                    if let hourlyWeatherForTodaySectionNode = docTodayTomorrow.xpath("//section[@class='forecast-point-week-wrap']").first?.at_xpath("//*[@class='forecast-point-week forecast-days-long']") {
                        weatherResult.tenDaysWeather = try getTenDaysWeather(sectionNode: hourlyWeatherForTodaySectionNode)
                    }
                case .hourlyTask:
                    // １時間天気
                    let docHourly = finishedHtmlDoc.0
                    // 今日分と明日分のセクションノード取得
                    if let hourlyWeatherForTodaySectionNode = docHourly.xpath("//*[@id='forecast-point-1h-today']").first,
                       let hourlyWeatherForTomorrowSectionNode = docHourly.xpath("//*[@id='forecast-point-1h-tomorrow']").first {
                        // 1時間毎の天気
                        weatherResult.hourlyWeathersToday = try getHourlyWeather(sectionNode: hourlyWeatherForTodaySectionNode)
                        weatherResult.hourlyWeathersTomorrow = try getHourlyWeather(sectionNode: hourlyWeatherForTomorrowSectionNode)
                    }
                    
                case .pm2_5Task:
                    // PM2.5分布予測
                    let docPm2_5 = finishedHtmlDoc.0
                    // セクションノード取得
                    if let pm2_5SectionNode = docPm2_5.xpath("//*[@class='common-info-table pm25-city-table']").first {
                        weatherResult.pm2_5Infos = try getPm2_5Info(sectionNode: pm2_5SectionNode)
                    }
                // TODO: 天気のデータに混じっている。どの画面に出すかも要検討。
                case .engadgetAppleTask:
                    let docEngadgetApple = finishedHtmlDoc.0
                    if let engadgetAppleNode = docEngadgetApple.xpath("//ul[@data-component='LatestStream']").first {
                        let newsArrayObject = engadgetAppleNode.xpath("//li")
                        var appleNewsList: [AppleNews] = []
                        newsArrayObject.forEach { obj -> Void in
                            if let titleAndHref = obj.xpath("//a").first,
                               let title = titleAndHref["title"],
                               let href = titleAndHref["href"] {
                                var appleNews = AppleNews()
                                appleNews.title = title
                                appleNews.href = href
                                if obj.xpath("//a").count > 2,
                                   let authorImageUrl = obj.xpath("//a")[2].xpath("img").first?["src"],
                                   let postInfo = obj.xpath("//a")[2].content?.split(separator: ","),
                                    postInfo.count >= 2 {
                                    
                                    let authorName = String(postInfo[0])
                                    appleNews.authorName = authorName
                                    let postedTime = String(postInfo[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                                    appleNews.postedTime = postedTime
                                    let authorImage = UserDefaults.standard.gifImageWithURL(gifUrl: authorImageUrl)
                                    appleNews.authorImage = authorImage
                                }
                                appleNewsList.append(appleNews)
                            }
                        }
                        weatherResult.appleNewsList = appleNewsList
                    }
                }
            }
        })
        
        return weatherResult
    }
    
    private func getPostalCode() async throws -> String {
        // tenki.jp用の現在地のURLを取得する
        if let postalCode = try await locationFetcher.lookUpCurrentLocation()?.postalCode {
            UserDefaults.standard.set(Constants.locationIdFukuoka, forKey: "lastPostalCode")
            return postalCode
        }
        if let lastPostalCode = UserDefaults.standard.object(forKey: "lastPostalCode") as? String {
            return lastPostalCode
        }
        
        throw APIError.locationError
    }
    
    func getPickupWrap(sectionNode: XMLElement) throws -> [PickupWrap] {
        let pickupWrapImageArrayObject = sectionNode.xpath("//div[@class='img-box']")
        let pickupWrapTelopArrayObject = sectionNode.xpath("//div[@class='telop']")
        let pickupWrapTelopCommentArrayObject = sectionNode.xpath("//div[@class='telop comment']")
        
        try [pickupWrapImageArrayObject, pickupWrapTelopArrayObject, pickupWrapTelopCommentArrayObject].forEach {
            if $0.count != 4 {
                throw APIError.scrapingError(2)
            }
        }
            
        return try (0...3).map { i -> PickupWrap in
            guard let imageUrl = pickupWrapImageArrayObject[i].xpath("img").first?["src"] else {
                throw APIError.scrapingError(3)
            }
            let imageWrap = UserDefaults.standard.gifImageWithURL(gifUrl: imageUrl)
            guard let telop = pickupWrapTelopArrayObject[i].content else {
                throw APIError.scrapingError(4)
            }
            guard let telopComment = pickupWrapTelopCommentArrayObject[i].content else {
                throw APIError.scrapingError(5)
            }
            
            return PickupWrap(image: imageWrap, telop: telop, telopComment: telopComment)
        }
    }
    
    func getPm2_5Info(sectionNode: XMLElement) throws -> [Pm2_5Info] {
        let hourTextArrayObject = sectionNode.xpath("//tr[@class='hour']//td")
        let pm25ArrayObject = sectionNode.xpath("//tr[@class='pm25-image']//td")
        try [hourTextArrayObject, pm25ArrayObject].forEach {
            if $0.count != 16 {
                throw APIError.scrapingError(6)
            }
        }
        
        return try (0...15).map { i -> Pm2_5Info in
            // 今日かどうか（falseなら明日）
            let isToday = i < 8
            
            // 時間（何時台か）
            guard let hourText = hourTextArrayObject[i].content else {
                throw APIError.scrapingError(7)
            }
            // 最初の"0"を削除しておく
            let _hourText = hourText.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
            
            // 過去の時間か
            let isPast = hourTextArrayObject[i].xpath("//span[@class='past']").first != nil
            
            // PM2.5の濃度を表す画像
            guard let pm2_5ImageUrl = pm25ArrayObject[i].xpath("img").first?["src"] else {
                throw APIError.scrapingError(8)
            }
            let pm2_5Image = UserDefaults.standard.gifImageWithURL(gifUrl: pm2_5ImageUrl)
            
            // PM2.5の濃度を表す記述
            guard let description = pm25ArrayObject[i].content else {
                throw APIError.scrapingError(9)
            }
            
            return Pm2_5Info(isToday: isToday, isPast: isPast, hour: _hourText, pm2_5Image: pm2_5Image, description: description)
        }
    }
    
    func getTenDaysWeather(sectionNode: XMLElement) throws -> [DailyWeather] {
        let dateTextArrayObject = sectionNode.xpath("//tr")[0].xpath("//td[@class='cityday']")
        let weatherInfoArrayObject = sectionNode.xpath("//tr")[1].xpath("//td[@class='weather-icon']")
        let highTemperatureArrayObject = sectionNode.xpath("//tr")[2].xpath("//td//p[@class='high-temp']")
        let lowTemperatureArrayObject = sectionNode.xpath("//tr")[2].xpath("//td//p[@class='low-temp']")
        let changeOfRainArrayObject = sectionNode.xpath("//tr")[3].xpath("//td//p[@class='precip']")
        try [dateTextArrayObject, weatherInfoArrayObject, highTemperatureArrayObject, lowTemperatureArrayObject].forEach {
            if $0.count != 9 {
                throw APIError.scrapingError(10)
            }
        }
        
        return try (0...8).map { i -> DailyWeather in
            // 日付
            guard let dateText = dateTextArrayObject[i].content else {
                throw APIError.scrapingError(11)
            }
            let _dateText = dateText.replacingOccurrences(of: "\n", with: "") // 無駄な改行を削除
                .replacingOccurrences(of: " ", with: "") // 無駄なスペースを削除
                // TODO: MM月DD日(曜日)の形式をMM/DD(曜日)に変換する良い方法を要考慮
                .replacingOccurrences(of: "(月)", with: "(Mon)")
                .replacingOccurrences(of: "(日)", with: "(Sun)")
                .replacingOccurrences(of: "月", with: "/")
                .replacingOccurrences(of: "日", with: "")
                .replacingOccurrences(of: "(Mon)", with: "(月)")
                .replacingOccurrences(of: "(Sun)", with: "(日)")
            
            // 天気を表す画像
            var weatherImage: UIImage? = nil
            if let weatherImageUrl = weatherInfoArrayObject[i].xpath("img").first?["src"] {
                weatherImage = UserDefaults.standard.gifImageWithURL(gifUrl: weatherImageUrl)
            }
            
            // 天気(「晴れ」など)
            guard let weatherDescription = weatherInfoArrayObject[i].content else {
                throw APIError.scrapingError(13)
            }
            
            // 最高気温
            guard let highTemperature = highTemperatureArrayObject[i].content else {
                throw APIError.scrapingError(14)
            }
            
            // 最低気温
            guard let lowTemperature = lowTemperatureArrayObject[i].content else {
                throw APIError.scrapingError(15)
            }
            
            // 降水確率
            // Remark:10日間天気の最後の日は空のデータになることがあり、changeOfRainArrayObjectだけは数が1つ少ない？
            var changeOfRain = "---"
            if changeOfRainArrayObject.count > i,
               let _changeOfRain = changeOfRainArrayObject[i].content {
                changeOfRain = _changeOfRain
            }
                    
            return DailyWeather(date: _dateText, weatherIcon: weatherImage, weatherDescription: weatherDescription, highTemperature: highTemperature, lowTemperature: lowTemperature, changeOfRain: changeOfRain)
        }
    }
    
    func getHourlyWeather(sectionNode: XMLElement) throws -> [HourlyWeather] {
        let hourTextArrayObject = sectionNode.xpath("//tr[@class='hour']//td")
        let weatherImageArrayObject = sectionNode.xpath("//tr[@class='weather']//td")
        let temperatureArrayObject = sectionNode.xpath("//tr[@class='temperature']//td")
        let chanceOfRainArrayObject = sectionNode.xpath("//tr[@class='prob-precip']//td")
        let precipitationImageArrayObject = sectionNode.xpath("//tr[@class='precip-graph']//td")
        let precipitationTextArrayObject = sectionNode.xpath("//tr[@class='precipitation']//td")
        let humidityTextArrayObject = sectionNode.xpath("//tr[@class='humidity']//td")
        let windDirectionTextArrayObject = sectionNode.xpath("//tr[@class='wind-blow']//td")
        let windSpeedTextArrayObject = sectionNode.xpath("//tr[@class='wind-speed']//td")
        try [hourTextArrayObject, weatherImageArrayObject, temperatureArrayObject, chanceOfRainArrayObject, precipitationImageArrayObject, precipitationTextArrayObject, humidityTextArrayObject, windDirectionTextArrayObject, windSpeedTextArrayObject ].forEach {
            if $0.count != 24 {
                throw APIError.scrapingError(17)
            }
        }
        
        return try (0...23).map { i -> HourlyWeather in
            // 時間（何時台か）
            guard let hourText = hourTextArrayObject[i].content else {
                throw APIError.scrapingError(18)
            }
            // 最初の"0"を削除しておく
            let _hourText = hourText.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
            
            // 過去の時間か
            let isPast = hourTextArrayObject[i].xpath("//span[@class='past']").first != nil
            
            // 天気を表す画像
            guard let weatherImageUrl = weatherImageArrayObject[i].xpath("img").first?["src"] else {
                throw APIError.scrapingError(19)
            }
            let weatherImage = UserDefaults.standard.gifImageWithURL(gifUrl: weatherImageUrl)
            
            // 気温
            guard let temperatureText = temperatureArrayObject[i].content else {
                throw APIError.scrapingError(20)
            }
            
            // 降水確率
            guard let changeOfRainText = chanceOfRainArrayObject[i].content else {
                throw APIError.scrapingError(21)
            }
            let _chanceOfRainText = changeOfRainText + (changeOfRainText == "---" ? "" : "%")
            
            // 降水量(グラフの画像と実際の降水量(mm/h))
            guard let precipitationImageUrl = precipitationImageArrayObject[i].xpath("img").first?["src"] else {
                throw APIError.scrapingError(22)
            }
            let precipitationImage = UserDefaults.standard.gifImageWithURL(gifUrl: precipitationImageUrl)
            guard let precipitationText = precipitationTextArrayObject[i].content else {
                throw APIError.scrapingError(23)
            }

            // 湿度
            guard let humidityText = humidityTextArrayObject[i].content else {
                throw APIError.scrapingError(24)
            }
            
            // 風向
            guard let windDirectionImageUrl = windDirectionTextArrayObject[i].xpath("img").first?["src"] else {
                throw APIError.scrapingError(25)
            }
            let windDirectionImage = UserDefaults.standard.gifImageWithURL(gifUrl: windDirectionImageUrl)
            guard let windDirectionText = windDirectionTextArrayObject[i].content else {
                throw APIError.scrapingError(26)
            }
            
            // 風速（m/s）
            guard let windSpeedText = windSpeedTextArrayObject[i].content else {
                throw APIError.scrapingError(27)
            }

            return HourlyWeather(isPast: isPast, hour: _hourText, weatherImage: weatherImage, temperature: temperatureText, changeOfRain: _chanceOfRainText, precipitationImage: precipitationImage,
                                 precipitation: precipitationText, humidity: humidityText, windDirectionImage: windDirectionImage, windDirection: windDirectionText, windSpeed: windSpeedText)
        }
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
