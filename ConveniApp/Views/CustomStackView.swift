//
//  CustomStackView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct CustomStackView<Title: View, Content: View>: View {
    var titleView: Title
    var contentView: Content
    
    init(@ViewBuilder titleView: @escaping ()->Title,
         @ViewBuilder contentView: @escaping ()->Content) {
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
                    .background(.ultraThinMaterial, in: CustomConrnerView(corners: [.bottomLeft, .bottomRight], radius: 12))
            }
        }
    }
}
