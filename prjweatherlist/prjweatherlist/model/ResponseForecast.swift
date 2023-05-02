//
//  ForecastInfo.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/03.
//

import Foundation

struct ResponseForecast: Codable, Equatable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ListInfo]
    let city: City
    
    struct City: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    struct ListInfo: Codable, Equatable {
        let dt: Int
        let main: WIMain
        let weather: [WIWeather]
    }
}
