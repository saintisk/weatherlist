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
    let description: String
    let icon: String
}
