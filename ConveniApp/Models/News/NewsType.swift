//
//  NewsType.swift
//  NewsType
//
//  Created by tanakabp on 2021/08/30.
//

import Foundation

enum NewsType {
    case appleNews, yahooITNews, fukuokaBCNews, yahooRankingNews
    
    func getPriority() -> Int {
        switch self {
        case .fukuokaBCNews:
            return 0
        case .yahooRankingNews:
            return 1
        case .yahooITNews:
            return 2
        case .appleNews:
            return 3
        }
    }
}
