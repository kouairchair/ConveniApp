//
//  ContentView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI
import OSLog

struct AlertMessage: Identifiable {
    var id: String { message }
    let message: String
}

struct ContentView: View {
    @State var image: UIImage?
    @State private var alertMessage: AlertMessage?
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
