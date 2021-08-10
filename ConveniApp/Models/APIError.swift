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
    case locationError
    case locationUrlError
    case scrapingError(Int)
    case noStatusCodeError
    case informationalError
    case redirectionError
    case clientError
    case serverError
    case undefinedError
    case decodeError
}
