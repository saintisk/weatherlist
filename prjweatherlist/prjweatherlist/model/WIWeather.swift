//
//  WIWeather.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/03.
//

import Foundation

struct WIWeather: Codable, Equatable {
    let id: Int
    let main: String
    let desc: String
    let icon: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case main
        case desc = "description"
        case icon
    }
}
