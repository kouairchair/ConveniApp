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
    @State var shouldHidePast: Bool = true
    
    var body: some View {
        VStack(spacing: 8) {
            CustomStackView(topEdge: topEdge) {
                HStack {
                    Label {
                        Text("PM2.5分布予測")
                    } icon: {
                        Image(systemName: "circle.hexagongrid.fill")
                    }
                    Spacer()
                    Button(action: {
                        shouldHidePast.toggle()
                    }){
                        Text(shouldHidePast ? "過去分表示" : "過去分非表示")
                            .foregroundColor(.white)
                            .underline()
                            .padding(.horizontal, 15)
                    }
                }
            } contentView: {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(weather.pm2_5Infos) { pm2_5Info in
                            let shouldHide = shouldHidePast ? pm2_5Info.isPast : false
                            if !shouldHide {
                                PM25View(pm2_5Info: pm2_5Info)
                            }
                            if pm2_5Info.isToday && pm2_5Info.hour == "24" {
                                Divider().background(.white)
                            }
                        }
                    }
                }
            }
            
            // TODO: アップルニュースが天気のデータに混じっている。どの画面に出すかも要検討。
            CustomStackView(topEdge: topEdge) {
                Label {
                    Text("Engadget Apple News")
                } icon: {
                    Image(systemName: "newspaper")
                }
            } contentView: {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(weather.appleNewsList) { appleNews in
                        VStack(spacing: 5) {
                            if let url = URL(string: "https://www.engadget.com/" + appleNews.href) {
                                Link(appleNews.title, destination: url)
                                    .foregroundStyle(.yellow, .white)
                            } else {
                                Text(appleNews.title)
                                    .foregroundStyle(.yellow, .white)
                            }
                            
                            HStack(spacing: 10) {
                                if let authorImage = appleNews.authorImage {
                                    Image(uiImage: authorImage)
                                        .symbolVariant(.fill)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.yellow, .white)
                                }
                                
                                Text(appleNews.authorName)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                                
                                Text(appleNews.postedTime)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Divider()
                    }
                    .padding(.vertical, 3)
                }
            }
            
//            HStack {
//                CustomStackView(topEdge: topEdge) {
//                    Label {
//                        Text("UV Index")
//                    } icon: {
//                        Image(systemName: "sun.min")
//                    }
//                } contentView: {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("0")
//                            .font(.title)
//                            .fontWeight(.semibold)
//
//                        Text("Low")
//                            .font(.title)
//                            .fontWeight(.semibold)
//                    }
//                    .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                }
//
//                CustomStackView(topEdge: topEdge) {
//                    Label {
//                        Text("Rainfall")
//                    } icon: {
//                        Image(systemName: "drop.fill")
//                    }
//                } contentView: {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("0 mm")
//                            .font(.title)
//                            .fontWeight(.semibold)
//
//                        Text("in last 24 hours")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                    }
//                    .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                }
//            }
//            .frame(maxHeight: .infinity)
            
            CustomStackView(topEdge: topEdge) {
                Label {
                    // TODO: 「福岡市の10日間天気」のように、範囲が広くなっているようなので、タイトルを可変にすべき？
                    Text("10日間天気")
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
