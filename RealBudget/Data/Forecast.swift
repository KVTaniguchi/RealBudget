//
//  Forecast.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/8/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

struct Forecast: Identifiable {
    let date: Date
    var change = 0
    var balance = 0
    let id = UUID().uuidString
    
    var isCurrentWeek: Bool {
        let currentCalendar = Calendar.current
        return currentCalendar.isDayInCurrentWeek(date: date) ?? false
    }
}

private extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}
