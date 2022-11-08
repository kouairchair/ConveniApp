//
//  JobType.swift
//  ConveniApp
//
//  Created by tanakabp on 2022/10/27.
//

import Foundation

enum JobType {
    case hiProTech, codeal
    
    func getPriority() -> Int {
        switch self {
        case .hiProTech:
            return 0
        case .codeal:
            return 1
        }
    }
}
