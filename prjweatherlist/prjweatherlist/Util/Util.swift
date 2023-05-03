//
//  Util.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/04.
//

import Foundation

func dateFromTimestamp(dt: Double) -> String {
    let date = Date(timeIntervalSince1970: dt)
    let calendar = Calendar.current
    if calendar.isDateInToday(date) { return "Today" }
    else if calendar.isDateInTomorrow(date) { return "Tommorow" }
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.dateFormat = "EEE d MMMM"
    return df.string(from: date)
}

func convertTemp(kelvin: CGFloat) -> Int {
    let celsiusUnit = UnitTemperature.celsius
    return Int(celsiusUnit.converter.value(fromBaseUnitValue: kelvin))
}
