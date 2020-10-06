//
//  Forecast.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/5/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct Forecast: Identifiable {
    let amount: String
    let date: Date
    let id = UUID().uuidString
    
    var isCurrentWeek: Bool {
        let currentCalendar = Calendar.current
        return currentCalendar.isDayInCurrentWeek(date: date) ?? false
    }
}

struct ForecastView: View {
    let forecast: Forecast
    
    var body: some View {
        HStack {
            Spacer()
            Text("date")
            CenterLineEyeView(isCurrentWeek: forecast.isCurrentWeek)
            Text("amount")
            Spacer()
        }
    }
}

struct CenterLineEyeView: View {
    let isCurrentWeek: Bool
    
    var body: some View {
        VStack {
            Rectangle().frame(width: 1.0, height: 40, alignment: .center)
            Image(systemName: isCurrentWeek ? "largecircle.fill.circle" : "smallcircle.fill.circle")
            Rectangle().frame(width: 1.0, height: 40, alignment: .center)
        }
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
