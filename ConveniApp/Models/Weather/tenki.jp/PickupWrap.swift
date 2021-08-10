//
//  PickupWrap.swift
//  PickupWrap
//
//  Created by headspinnerd on 2021/08/09.
//

import UIKit

struct PickupWrap: Identifiable {
    var id = UUID().uuidString
    var image: UIImage? = nil
    var telop: String = ""
    var telopComment: String = ""
}
