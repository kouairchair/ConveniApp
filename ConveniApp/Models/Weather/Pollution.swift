// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pollution = try? newJSONDecoder().decode(Pollution.self, from: jsonData)

import Foundation

// MARK: - Pollution
struct Pollution: Codable {
    let coord: [Int]
    let list: [List]
    
    // MARK: - List
    struct List: Codable {
        let dt: Int
        let main: Main
        let components: [String: Double]
    }

    // MARK: - Main
    struct Main: Codable {
        let aqi: Int
    }
}


