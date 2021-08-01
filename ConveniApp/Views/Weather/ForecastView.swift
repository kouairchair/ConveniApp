//
//  ForecastView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct ForecastView: View {
    var hourlyWeather: HourlyWeather
    @Binding var shouldHideMoreInfo: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text(hourlyWeather.hour)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            if let weatherImage = hourlyWeather.weatherImage {
                Image(uiImage: weatherImage)
                    .font(.title2)
                // max Frame...
                    .frame(height: 30)
            }
                           
            Text("\(hourlyWeather.temperature)°")
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Text(hourlyWeather.changeOfRain)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            if !shouldHideMoreInfo {
                if let precipitationImage = hourlyWeather.precipitationImage {
                    Image(uiImage: precipitationImage)
                        .font(.title2)
                    // max Frame...
                        .frame(height: 25)
                }
            }
            
            Text("\(hourlyWeather.precipitation)mm")
                .font(.callout.bold())
                .foregroundStyle(.white)
                        
            if !shouldHideMoreInfo {
                Text("\(hourlyWeather.humidity)%")
                    .font(.callout.bold())
                    .foregroundStyle(.white)
                
                if let windDirectionImage = hourlyWeather.windDirectionImage {
                    Image(uiImage: windDirectionImage)
                        .font(.title2)
                    // max Frame...
                        .frame(height: 25)
                }
                
                Text(hourlyWeather.windDirection)
                    .font(.callout.bold())
                    .foregroundStyle(.white)
                
            }
            
            Text("\(hourlyWeather.windSpeed)m/s")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 3)
    }
}
