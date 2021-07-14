//
//  URLSession+Get.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/14.
//

import Foundation

extension URLSession {
    
    func getData(urlString: String) async throws -> Data {
        if !NetworkMonitor.shared.isReachable {
            throw APIError.offlineError
        }
        
        guard let requestUrl = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        let request = URLRequest(url: requestUrl)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.noStatusCodeError
        }
        
        switch statusCode {
        case 100..<200:
            throw APIError.informationalError
        case 200..<300:
            return data
        case 300..<400:
            throw APIError.redirectionError
        case 400..<500:
            throw APIError.clientError
        case 500..<600:
            throw APIError.serverError
        default:
            throw APIError.undefinedError
        }
    }
    
    func getDecodedData<T>(urlString: String) async throws -> T where T: Decodable {
        let data = try await URLSession.shared.getData(urlString: urlString)
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.decodeError
        }
        
        return decodedResponse
    }
}
