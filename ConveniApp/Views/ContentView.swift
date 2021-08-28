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
        // Since Window is deprecated in iOS15...
        // Getting Safe area using Geometry Reader
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            HomeView(topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 8")
            .preferredColorScheme(.dark)
    }
}
