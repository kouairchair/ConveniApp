//
//  WeatherDataView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/20.
//

import SwiftUI

struct WeatherDataView: View {
    var topEdge: CGFloat
    
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
                    ForEach(forecast) { cast in
                        HStack(spacing: 15) {
                            Text(cast.day)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            // max width...
                                .frame(width: 60, alignment: .leading)

                            Image(systemName: cast.image)
                                .font(.title3)
                                .symbolVariant(.fill)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.yellow, .white)
                                .frame(width: 30)

                            Text("\(Int(cast.celcius))")
                                .font(.title3.bold())
                                .foregroundStyle(.secondary)
                                .foregroundStyle(.white)
                                .frame(width: 30)

                            // Progress Bar...
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.tertiary)
                                    .foregroundStyle(.white)

                                // for width..
                                GeometryReader { proxy in
                                    Capsule()
                                        .fill(.linearGradient(.init(colors: [.orange,.red]), startPoint: .leading, endPoint: .trailing))
                                        .frame(width: (((cast.celcius * 9 / 5) + 32) / 140) * proxy.size.width)
                                }
                            }
                            .frame(height: 4)
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
