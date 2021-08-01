//
//  ForecastView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct ForecastView: View {
    var time: String
    var temperature: String
    var weatherImage: UIImage?
    var changeOfRain: String
    var precipitationImage: UIImage?
    var precipitation: String
    var humidity: String
    var windDirectionImage: UIImage?
    var windDirection: String
    var windSpeed: String
    @Binding var shouldHideMoreInfo: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text(time)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            if let weatherImage = weatherImage {
                Image(uiImage: weatherImage)
                    .font(.title2)
                // max Frame...
                    .frame(height: 30)
            }
                           
            Text("\(temperature)°")
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Text("\(changeOfRain)\(changeOfRain == "---" ? "" : "%")")
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            if !shouldHideMoreInfo {
                if let precipitationImage = precipitationImage {
                    Image(uiImage: precipitationImage)
                        .font(.title2)
                    // max Frame...
                        .frame(height: 25)
                }
            }
            
            Text("\(precipitation)mm")
                .font(.callout.bold())
                .foregroundStyle(.white)
                        
            if !shouldHideMoreInfo {
                Text("\(humidity)%")
                    .font(.callout.bold())
                    .foregroundStyle(.white)
                
                if let windDirectionImage = windDirectionImage {
                    Image(uiImage: windDirectionImage)
                        .font(.title2)
                    // max Frame...
                        .frame(height: 25)
                }
                
                Text(windDirection)
                    .font(.callout.bold())
                    .foregroundStyle(.white)
                
            }
            
            Text("\(windSpeed)m/s")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 3)
    }
}
