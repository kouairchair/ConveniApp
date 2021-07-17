//
//  CustomStackView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct CustomStackView<Title: View, Content: View>: View {
    var topEdge: CGFloat
    var titleView: Title
    var contentView: Content
    
    // Offsets...
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    
    init(topEdge: CGFloat, @ViewBuilder titleView: @escaping ()->Title,
         @ViewBuilder contentView: @escaping ()->Content) {
        self.topEdge = topEdge
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .font(.callout)
                .lineLimit(1)
                // Max Height...
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(.ultraThinMaterial, in: CustomConrnerView(corners: [.topLeft, .topRight], radius: 12))
            
            VStack {
                Divider()
                
                contentView
                    .padding()
            }
            .background(.ultraThinMaterial, in: CustomConrnerView(corners: [.bottomLeft, .bottomRight], radius: 12))
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        // Stopping View @120...
        .offset(y: topOffset >= 60 + topEdge ? 0 : -topOffset + 60 + topEdge)
        .background(
            
            GeometryReader{ proxy -> Color in
            let minY = proxy.frame(in: .global).minY
            
            DispatchQueue.main.async {
                self.topOffset = minY
            }
            
            return Color.clear
            }
        )
    }
}
