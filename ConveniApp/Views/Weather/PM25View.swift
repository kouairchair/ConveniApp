//
//  PM25View.swift
//  PM25View
//
//  Created by headspinnerd on 2021/08/08.
//

import SwiftUI

struct PM25View: View {
    var pm2_5Info: Pm2_5Info
    
    var body: some View {
        VStack(spacing: 5) {
            if (pm2_5Info.isToday && pm2_5Info.hour == "24") {
                Text("今日←")
                    .font(.callout.bold())
                    .foregroundStyle(.white)
            } else if (!pm2_5Info.isToday && pm2_5Info.hour == "3") {
                Text("→明日")
                    .font(.callout.bold())
                    .foregroundStyle(.white)
            } else {
                Text("    ")
                    .font(.callout.bold())
                    .foregroundStyle(.white)
            }
            
            Text(pm2_5Info.hour)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            if let weatherImage = pm2_5Info.pm2_5Image {
                Image(uiImage: weatherImage)
                    .font(.title2)
                // max Frame...
                    .frame(height: 30)
            }
                           
            Text(pm2_5Info.description)
                .font(.system(size: 15))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 3)
    }
}
