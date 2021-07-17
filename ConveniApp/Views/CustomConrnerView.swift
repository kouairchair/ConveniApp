//
//  CustomConrnerView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/17.
//

import SwiftUI

struct CustomConrnerView: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
