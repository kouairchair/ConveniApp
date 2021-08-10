//
//  AppleNews.swift
//  AppleNews
//
//  Created by headspinnerd on 2021/08/10.
//

import SwiftUI

struct AppleNews: Identifiable {
    var id = UUID().uuidString
    
    // ページタイトル
    var title: String = ""
    
    // ページのURL
    var href: String = ""
    
    // 著者の名前
    var authorName: String = ""
    
    // 著者の画像
    var authorImage: UIImage? = nil
    
    // いつ投稿されたか（an hour agoなど）
    var postedTime: String = ""
}
