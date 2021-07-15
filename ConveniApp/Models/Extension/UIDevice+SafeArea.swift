//
//  UIDevice+SafeArea.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/15.
//

import SwiftUI

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        // TODO: need to fix deprecated property "windows"
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
