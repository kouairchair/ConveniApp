//
//  ContentView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ConveniHeaderView()
            Button(action: {
                async {
                    do {
                        if let weather = try await WeatherManager.shared.fetchWeather() {
                            print("testtest weather:\(String(describing: weather.main.temp))")
                        }
                    } catch {
                        print("testtest fetchWeather failed:\(error)")
                    }
                }
            }){
                Text("get Weather")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
