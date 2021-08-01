//
//  WeatherDataView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/20.
//

import SwiftUI

struct WeatherDataView: View {
    var topEdge: CGFloat
    @Binding var weather: Weather
    
    var body: some View {
        VStack(spacing: 8) {
            CustomStackView(topEdge: topEdge) {
                Label {
                    Text("Air Quality")
                } icon: {
                    Image(systemName: "circle.hexagongrid.fill")
                }
            } contentView: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("143 - Moderately Polluted")
                        .font(.title3.bold())
                    Text("May cause breathing discomfort for people with lung disease sch as asthma and discomfort for people with heart disease, children and older adults.")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
            }
            
            HStack {
                CustomStackView(topEdge: topEdge) {
                    Label {
                        Text("UV Index")
                    } icon: {
                        Image(systemName: "sun.min")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("0")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Low")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                
                CustomStackView(topEdge: topEdge) {
                    Label {
                        Text("Rainfall")
                    } icon: {
                        Image(systemName: "drop.fill")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("0 mm")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("in last 24 hours")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
            }
            .frame(maxHeight: .infinity)
            
            CustomStackView(topEdge: topEdge) {
                Label {
                    Text("10-day Forecast")
                } icon: {
                    Image(systemName: "calendar")
                }
            } contentView: {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(weather.tenDaysWeather) { dailyWeather in
                        // TODO:横向き時のレイアウトを要見直し
                        HStack(spacing: 0) {
                            Text(dailyWeather.date)
                                .font(.system(size: 16))
                                .bold()
                                .foregroundStyle(.white)
                            // max width...
                            Spacer()

                            if let weatherIcon = dailyWeather.weatherIcon {
                                Image(uiImage: weatherIcon)
                                    .symbolVariant(.fill)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.yellow, .white)
                                Spacer()
                            }
                            
                            Text(dailyWeather.weatherDescription)
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                            Spacer()
                            
                            Text("\(dailyWeather.lowTemperature)°-\(dailyWeather.highTemperature)°")
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                            Spacer()
                            
                            Text(dailyWeather.changeOfRain)
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        
                        Divider()
                    }
                    .padding(.vertical, 3)
                }
            }
        }
    }
}

struct WeatherDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
