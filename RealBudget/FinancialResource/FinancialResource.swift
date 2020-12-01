//
//  FinancialResource.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 11/28/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

final class FinancialResource {
    
    static func forecast(state: RBState, events: FetchedResults<RBEvent>) -> [Forecast] {
        var data: [Forecast] = []
        
        let actualBalance = Int(state.actualBalance)
        let financialEvents = events.map {
            FinancialEvent(
                id: $0.id,
                type: FinancialEventType(rawValue: Int($0.type)) ?? .expense,
                name: $0.name ?? "no name",
                value: Int($0.change),
                frequency: Frequency(rawValue: Int($0.frequency)) ?? .monthly,
                startDate: $0.startDate ?? Date(),
                endDate: $0.endDate,
                isActive: $0.isActive
            )
        }
        let state = FinancialState(actualBalance: actualBalance, events: financialEvents)
        let predictions = PredictionEngine.shared.predict(state: state)
        
        let sortedDates = predictions.keys.sorted()
        
        for date in sortedDates {
            if let forecast = predictions[date] {
                data.append(forecast)
            }
        }
        
        return data
    }
}
