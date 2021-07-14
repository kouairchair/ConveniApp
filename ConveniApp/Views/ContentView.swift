//
//  ContentView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI

struct ContentView: View {
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            ConveniHeaderView()
            if let _image = image {
                Image(uiImage: _image)
            }
//            Button(action: {
//            }){
//                Text("get Weather")
//            }
        }.onAppear {
            async {
                do {
                    if let weatherImage = try await WeatherManager.shared.fetchWeatherIcon() {
                        image = weatherImage
                    }
                } catch {
                    print("testtest fetchWeather failed:\(error)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
