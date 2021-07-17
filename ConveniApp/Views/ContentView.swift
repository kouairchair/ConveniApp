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
    
    var body: some View {
        VStack {
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11 Pro Max")
            .preferredColorScheme(.dark)
    }
}
