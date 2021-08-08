//
//  Pm2_5Info.swift
//  Pm2_5Info
//
//  Created by headspinnerd on 2021/08/08.
//

import SwiftUI

struct Pm2_5Info: Identifiable {
    var id = UUID().uuidString

    // 今日かどうか（falseなら明日）
    let isToday: Bool
    
    // 過去の時間か
    let isPast: Bool
    
    // 時間（何時台か）
    let hour: String
    
    // PM2.5の濃度を表す画像
    let pm2_5Image: UIImage?
    
    // PM2.5の濃度を表す記述
    let description: String
}
