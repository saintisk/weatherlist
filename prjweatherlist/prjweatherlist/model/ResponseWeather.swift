//
//  WeatherInfo.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/02.
//

import Foundation

struct ResponseWeather: Codable, Equatable {
    let weather: [WIWeather]
    let main: WIMain
    let dt: Int
    let name: String
    let cod: Int
}
