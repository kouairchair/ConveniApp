//
//  WeatherView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct WeatherView: View {
    var topEdge: CGFloat
    @State var offset: CGFloat = 0
    @State var locality: String = ""
    @State var weather: Weather = Weather(description: "", highTemp: "", highTempDiff: "", lowTemp: "", lowTempDiff: "", hourlyWeather: [])
    @State var isPastMode: Bool = false
    
    var body: some View {
        VStack {
            // Main View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Weather Data...
                    VStack(alignment: .center, spacing: 5) {
                        Text(locality)
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        Text("\(weather.lowTemp)° - \(weather.highTemp)°")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                        Text(weather.description)
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                        Text("L:\(weather.lowTempDiff)° H:\(weather.highTempDiff)°")
                            .foregroundStyle(.primary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                    }
                    .offset(y: -offset)
                    // For Bottom Drag Effect...
                    .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                    .offset(y: getTitleOffset())
                    
                    // Custome Data View
                     
                    VStack(spacing: 8) {
                        // Custom Stack...
                        CustomStackView(topEdge: topEdge) {
                            // Label here...
                            Label {
                                HStack {
                                    Text("1時間天気")
                                    Spacer()
                                    Button(action: {
                                        isPastMode.toggle()
                                    }){
                                        Text(isPastMode ? "過去の天気を非表示" : "過去の天気を表示")
                                            .foregroundColor(.white)
                                            .underline()
                                            .padding(.horizontal, 15)
                                    }
                                }
                            } icon: {
                                Image(systemName: "clock")
                            }
                        } contentView: {
                            // Content..
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(weather.hourlyWeather) { weatherPerHour in
                                        let shouldHide = isPastMode ? weatherPerHour.isPast : false
                                        if !shouldHide {
                                            ForecastView(time: weatherPerHour.hour,
                                                         temperature: weatherPerHour.temperature,
                                                         image: weatherPerHour.weatherImage,
                                                         changeOfRain: weatherPerHour.changeOfRain)
                                        }
                                    }
                                }
                            }
                        }
                        
                        WeatherDataView(topEdge: topEdge)
                    }
                    .padding(.top, -20)
                }
                .padding(.top, 25)
                .padding(.top, topEdge)
                .padding([.horizontal, .bottom])
                // getting Offset...
                .overlay(
                    // Using Geometry Reader...
                    GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return Color.clear
                    }
                )
            }
        }
        .onAppear() {
            Task.init(priority: .default) {
                do {
                    locality = try await WeatherManager.shared.fetchLocality()
                    weather = try await WeatherManager.shared.fetchWeather()
                } catch {
                    // TODO: need to implement
                }
            }
        }
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        
        let progress = titleOffset / 20
        
        let opacity = 1 - progress
        
        return opacity
    }
    
    func getTitleOffset() -> CGFloat {
        // setting one max height for whole title...
        // consider max as (60 + topEdge)...
        if offset < 0 {
            let progress = -offset / (60 + topEdge)
            
            // since top padding is 25...
            let newOffset = (progress <= 1.0 ? progress : 1) * 20

            return -newOffset
        }
        
        return 0
    }
}
