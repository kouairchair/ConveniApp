//
//  WeatherView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack {
            // Geometry Reader for getting height and width
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            // Blur Material
            .overlay(.ultraThinMaterial)
            
            // Main View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Weather Data...
                    VStack(alignment: .center, spacing: 5) {
                        Text("Fukuoka")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        Text(" 98°")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        Text("Cloudy")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        
                        Text("H:103° L:105°")
                            .foregroundStyle(.primary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                    }
                    
                    // Custome Data View
                     
                    VStack(spacing: 8) {
                        // Custom Stack...
                        CustomStackView {
                            // Label here...
                            Label {
                                Text("Hourly Forecast")
                            } icon: {
                                Image(systemName: "clock")
                            }
                        } contentView: {
                            // Content..
                            VStack {
                                
                            }
                        }
                    }
                }
                .padding(.top, 25)
                .padding([.horizontal, .bottom])
            }
        }
    }
}
