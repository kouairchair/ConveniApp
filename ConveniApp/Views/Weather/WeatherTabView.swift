//
//  WeatherTabView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct WeatherTabView: View {
    
    @State var image: UIImage?
    @State private var alertMessage: AlertMessage?
    
    var body: some View {
        VStack {
            if let _image = image {
                Image(uiImage: _image)
            } else {
                Image(systemName: "cloud.fill")
            }
        }
        .onAppear {
            Task.init(priority: .default) {
                do {
                    if let weatherImage = try await WeatherManager.shared.fetchWeatherIcon() {
                        image = weatherImage
                    }
                } catch {
                    logger.error("fetchWeather failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchWeatherFailed.translate(), [error]))
                    }
                }
            }
        }.alert(item: $alertMessage) { alert in
            Alert(title: Text(LcliConstants.errorMessage.translate()), message: Text(alert.message), dismissButton: .cancel())
        }
    }
}