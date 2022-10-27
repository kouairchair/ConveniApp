//
//  Job.swift
//  ConveniApp
//
//  Created by tanakabp on 2022/10/27.
//

import Foundation

struct Job: Identifiable {
    var id = UUID().uuidString
    
    // ソートをするためのインデックス
    var index: Int = 0
    
    // 案件の種類（どのサイトやサービスの案件か）
    var jobType: JobType
    
    // 案件のタイトル
    var title: String = ""
    
    // 案件詳細のURL
    var href: String = ""
    
    // 単価
    var price: String = ""
    
    // 職種
    var occupation: String = ""
    
    // スキル（開発言語など）
    var skill: String = ""
    
    // 勤務地
    var workLocation: String = ""
    
    // ポイント
    var point: String = ""
}
