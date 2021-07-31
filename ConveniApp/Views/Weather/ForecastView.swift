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
    var image: UIImage?
    var changeOfRain: String
    
    var body: some View {
        VStack(spacing: 7) {
            Text(time)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            if let image = image {
                Image(uiImage: image)
                    .font(.title2)
                // MultiColor...
//                    .symbolVariant(.fill)
//                    .symbolRenderingMode(.palette)
//                    .foregroundStyle(.yellow, .white)
                // max Frame...
                    .frame(height: 30)
            }
                           
            Text("\(temperature)°")
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Text("\(changeOfRain)\(changeOfRain == "---" ? "" : "%")")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
    }
}
