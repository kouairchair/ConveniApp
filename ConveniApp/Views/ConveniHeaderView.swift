//
//  ConveniHeaderView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI

struct ConveniHeaderView: View {
    var body: some View {
        HStack {
            Text("Conveni App")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))
            
            Spacer(minLength: 0)
        }
    }
}

struct ConveniHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ConveniHeaderView()
    }
}
