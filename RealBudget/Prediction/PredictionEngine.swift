//
//  PredictionEngine.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/8/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

final class PredictionEngine {
    static let shared = PredictionEngine()
    
    func predict(state: FinancialState) -> [Date: Forecast] {
        let startingDate = Date()
        let dates = (0 ..< 52).map {
            Calendar.current.date(byAdding: .day, value: $0 * 7, to: startingDate)!
        }
        
        var hashedForecasts: [Date: Forecast] = [:]
        for date in dates {
            if date > Date() {
                hashedForecasts[date] = Forecast(date: date)
            }
        }
        
        let activeEvents = state.events.filter(\.isActive)
        
        let eventsWithDates = activeEvents.map { populateChanges(hashedForecasts: hashedForecasts, event: $0, dates: dates) }
        
        var dynamicBalance = state.actualBalance
        applyChanges(
            dynamicBalance: &dynamicBalance,
            forecasts: &hashedForecasts,
            hashedEvents: eventsWithDates,
            sortedDates: dates.sorted()
        )
        
        return hashedForecasts
    }
    
    private func populateChanges(
        hashedForecasts: [Date: Forecast],
        event: FinancialEvent,
        dates: [Date]
        
    ) -> [Date: Forecast] {
        
        var mutable = hashedForecasts
        let sortedForecastDates = dates.sorted()

        let applicationDates = (0 ..< event.frequency.recurrences).map {
            Calendar.current.date(byAdding: event.frequency.calendarComponent, value: $0 * event.frequency.interval, to: event.startDate)!
        }
        
        for forecastDate in sortedForecastDates {
            var currentForecast = hashedForecasts[forecastDate]
            
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: forecastDate)!
            
            let shouldApplyEventToForecastDate: Bool = {
                let dateFallingInBetween = applicationDates.first { (applicationDate) -> Bool in
                    return applicationDate > oneWeekAgo && applicationDate < forecastDate
                }
                return dateFallingInBetween != nil
            }()
            
            if shouldApplyEventToForecastDate {
                switch event.type {
                case .expense:
                    currentForecast?.change -= event.value
                case .income:
                    currentForecast?.change += event.value
                }
            }

            mutable[forecastDate] = currentForecast
        }
        
        return mutable
    }
    
    private func applyChanges(
        dynamicBalance: inout Int,
        forecasts: inout [Date: Forecast],
        hashedEvents: [[Date: Forecast]],
        sortedDates: [Date]
    ) {
        for sortedDate in sortedDates {
            for event in hashedEvents {
                if let forecast = event[sortedDate] {
                    dynamicBalance += forecast.change
                }
            }
            
            forecasts[sortedDate]?.balance = dynamicBalance
        }
    }
}
