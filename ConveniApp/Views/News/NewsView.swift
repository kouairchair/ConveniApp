//
//  NewsView.swift
//  NewsView
//
//  Created by tanakabp on 2021/08/19.
//

import SwiftUI

/*
 // TODO: アップルニュースが天気のデータに混じっている。どの画面に出すかも要検討。
 // TODO: スワイプで既読機能を作る？
 CustomStackView(topEdge: topEdge) {
     Label {
         Text("Engadget Apple News")
     } icon: {
         Image(systemName: "newspaper")
     }
 } contentView: {
     VStack(alignment: .leading, spacing: 10) {
         ForEach(appleNewsList) { appleNews in
             NewsView(appleNews: appleNews)
             
             Divider()
         }
         .padding(.vertical, 3)
     }
 }
 */
struct NewsView: View {
    @Binding var newsList: [News]
    
    var body: some View {
        ZStack {
            List {
                ForEach(newsList) { news in
                    VStack(spacing: 5) {
                        if let url = URL(string: news.href) {
                            Link(news.title, destination: url)
                                .foregroundStyle(.yellow, .white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text(news.title)
                                .foregroundStyle(.yellow, .white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        HStack(spacing: 10) {
                            if let authorImage = news.authorImage {
                                Image(uiImage: authorImage)
                                    .symbolVariant(.fill)
                                    .symbolRenderingMode(.palette)
                            }
                            
                            Text(news.authorName)
                                .font(.system(size: 15))
                            
                            Text(news.postedTime)
                                .font(.system(size: 15))
                        }
                    }
                }
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
