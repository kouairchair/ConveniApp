//
//  ConveniAppApp.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI

@main
struct ConveniAppApp: App {
    init() {
        setupModels()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private extension ConveniAppApp {
    func setupModels() {
        WeatherManager.shared.startFetch()
        NetworkMonitor.shared.startMonitoring()
    }
}
