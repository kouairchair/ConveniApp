//
//  ConveniAppApp.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI
import Logging
import LoggingOSLog

@main
struct ConveniAppApp: App {
    init() {
        setupModels()
        
        LoggingSystem.bootstrap {
            #if DEBUG
                OSLogHandler(label: $0, metadataContentType: .public)
            #else
                OSLogHandler(label: $0, metadataContentType: .private)
            #endif
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private extension ConveniAppApp {
    func setupModels() {
        Task.init(priority: .high) {
            await WeatherFetcher.shared.startFetch()
            NetworkMonitor.shared.startMonitoring()
        }
    }
}
