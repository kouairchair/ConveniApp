//
//  News.swift
//  AppleNews
//
//  Created by headspinnerd on 2021/08/10.
//

import SwiftUI

struct News: Identifiable {
    var id = UUID().uuidString
    
    // ニュースタイプ
    var newsType: NewsType
    
    // ページタイトル
    var title: String = ""
    
    // ページのURL
    var href: String = ""
    
    // 記事の文章のプレビュー（トップ記事のみ）
    var articlePreview: String?
    
    // 著者の名前
    var authorName: String = ""
    
    // 著者の画像
    var authorImage: UIImage?
    
    // 記事の画像
    var articleImage: UIImage?
    
    // いつ投稿されたか（an hour agoなど）
    var postedTime: String = ""
    
    var postedMinutesAgo: Int32 = 0
}
