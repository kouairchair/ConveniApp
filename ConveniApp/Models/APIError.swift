//
//  APIError.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/30.
//

import Foundation

enum APIError: Error {
    case offlineError
    case urlError
    case noStatusCodeError
    case informationalError
    case redirectionError
    case clientError
    case serverError
    case undefinedError
    case decodeError
}
