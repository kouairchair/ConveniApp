//
//  ArchiveButtonView.swift
//  ArchiveButtonView
//
//  Created by tanakabp on 2021/08/19.
//

import SwiftUI

struct ArchiveButtonView: View {
    let cellHeight: CGFloat
    
    var body: some View {
        VStack {
            Image(systemName: "delete.right")
            Text("Archive")
        }
        .padding(5)
        .foregroundColor(.primary)
        .font(.subheadline)
        .frame(width: Constants.archiveButtonWidth, height: cellHeight)
        .background(Color.red)
    }
}

struct ArchiveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveButtonView(cellHeight: 30)
    }
}
