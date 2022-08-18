//
//  Actor+Timeout.swift
//  Actor+Timeout
//
//  Created by tanakabp on 2021/08/28.
//

import SwiftUI

extension Actor {
    func withTimeout(_ seconds: Double, _ fun: @escaping () async throws -> ()) async throws {
        try await withThrowingTaskGroup(of: GroupResult.self) { group in
            _ = group.addTaskUnlessCancelled {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                return .cancel
            }
            _ = group.addTaskUnlessCancelled {
                try await fun()
                return .ok
            }
            
            _ = try await group.next()
            group.cancelAll()
        }
    }
}

enum GroupResult {
    case cancel, ok
}
