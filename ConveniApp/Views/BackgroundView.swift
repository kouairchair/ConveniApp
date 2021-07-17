//
//  BackgroundView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct BackgroundView: View {
    @Binding var currentTab: TabItem
    var body: some View {
        if (currentTab == .Weather) {
            // Geometry Reader for getting height and width
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            // Blur Material
            .overlay(.ultraThinMaterial)
        }
    }
}
