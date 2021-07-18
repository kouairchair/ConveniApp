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
    
    var body: some View {
        VStack {
            // Main View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Weather Data...
                    VStack(alignment: .center, spacing: 5) {
                        Text("Fukuoka")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        Text("28°")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                        Text("Cloudy")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                        Text("H:103° L:105°")
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
                        
                        // For Testing...
                        ForEach(1...5, id: \.self) { _ in
                            CustomStackView(topEdge: topEdge) {
                                // Label here...
                                Label {
                                    Text("Hourly Forecast")
                                } icon: {
                                    Image(systemName: "clock")
                                }
                            } contentView: {
                                // Content..
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        Group {
                                            ForecastView(time: "12 PM", fahrenheit: 25, image: "sun.min")
                                            ForecastView(time: "13 PM", fahrenheit: 22, image: "sun.haze")
                                            ForecastView(time: "14 PM", fahrenheit: 23, image: "cloud.sun")
                                            ForecastView(time: "15 PM", fahrenheit: 24, image: "sun.haze")
                                            ForecastView(time: "16 PM", fahrenheit: 22, image: "sun.haze")
                                            ForecastView(time: "17 PM", fahrenheit: 21, image: "sun.haze")
                                            
                                        }
                                        ForecastView(time: "18 PM", fahrenheit: 20, image: "sun.haze")
                                        ForecastView(time: "19 PM", fahrenheit: 20, image: "sun.haze")
                                        ForecastView(time: "20 PM", fahrenheit: 19, image: "sun.haze")
                                        ForecastView(time: "21 PM", fahrenheit: 17, image: "sun.haze")
                                        ForecastView(time: "22 PM", fahrenheit: 15, image: "sun.haze")
                                        ForecastView(time: "23 PM", fahrenheit: 14, image: "sun.haze")
                                    }
                                }
                            }
                        }
                    }
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
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        
        let progress = titleOffset / 20
        
        let opacity = 1 - progress
        
        return opacity
    }
    
    func getTitleOffset() -> CGFloat {
        // setting one max height for whole title...
        // consider max as 120...
        if offset < 0 {
            let progress = -offset / 120
            
            // since top padding is 25...
            let newOffset = (progress <= 1.0 ? progress : 1) * 20

            return -newOffset
        }
        
        return 0
    }
}
