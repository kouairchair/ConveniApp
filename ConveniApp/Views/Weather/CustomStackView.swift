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
                .background(.ultraThinMaterial, in: CustomConrnerView(corners: bottomOffset < 38 ? .allCorners : [.topLeft, .topRight], radius: 12))
//                .background(.ultraThinMaterial, in: CustomConrnerView(corners: [.topLeft, .topRight], radius: 12))
                .zIndex(1)
            
            VStack {
                Divider()
                
                contentView
                    .padding()
            }
            .background(.ultraThinMaterial, in: CustomConrnerView(corners: [.bottomLeft, .bottomRight], radius: 12))
            // Moving Content Upward...
            .offset(y: topOffset >= 60 + topEdge ? 0 : -(-topOffset + 60 + topEdge))
            .zIndex(0)
            // Clipping to avoid background overlay
            .clipped()
            .opacity(getOpacity())
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        .opacity(getOpacity())
        // Stopping View @(60 + topEdge)...
        .offset(y: topOffset >= 60 + topEdge ? 0 : -topOffset + 60 + topEdge)
        .background(
            
            GeometryReader{ proxy -> Color in
            let minY = proxy.frame(in: .global).minY
            let maxY = proxy.frame(in: .global).maxY
            
            DispatchQueue.main.async {
                self.topOffset = minY
                // reducing (60 + topEdge)...
                self.bottomOffset = maxY - (60 + topEdge)
                // thus we will get out title height 38...
            }
            
            return Color.clear
            }
        )
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
    }
    
    // opacity...
    func getOpacity() -> CGFloat {
        if bottomOffset < 28 {
            
            let progress = bottomOffset / 28
            
            return progress
        }
        return 1
    }
}

// to avoid this creating new Modifier
struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        if bottomOffset < 38 {
            content
        } else {
            content
                .cornerRadius(12)
        }
    }
    
}
