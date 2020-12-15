//
//  Analysis.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 11/28/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct Analysis: View {
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    var risk: Risk {
        Risk(state: state.first, events: events)
    }
    
    var body: some View {
        Text("")
    }
}

// panel - risk level

enum RiskLevel {
    case high
    case moderate
    case low
    case unknown
}

struct Risk {
    var delta: Int = 0
    var level: RiskLevel?
    
    init(state: RBState?, events: FetchedResults<RBEvent>) {
        var forecasts: [Forecast] = []
        if let state = state {
            forecasts = FinancialResource.forecast(state: state, events: events)
            forecasts.sort(by: { $0.date < $1.date })
            
            if let firstBalance = forecasts.first?.balance,
               let lastBalance = forecasts.last?.balance {
                
                delta = lastBalance - firstBalance
            }
            
            if delta <= 0 {
                level = .high
            }
        }
    }
    
    // - high risk
    // an event that is high cost enough
    // to drive your balance below zero if another % event happens
    
    // or your balance will go negative eventually - a negative delta - last
    
    // or your total expense is too close to your total income and you have a low balance - balance is within 10% of total
    
    
    // - moderate risk
    // total expense is too close to total income, but balance is so
    
    // - else low risk
}

enum ExpenseType {
    case housing
    case groceries
    case transportation
    case healthCare
    case studentLoanDebt
    case childCare
    case savings
    
    func threshold(totalAnnualIncome: Int) -> Double {
        // recommended % of income
        let perc: Double
        
        switch self {
        case .childCare:
            perc = 0.10
        case .groceries:
            perc = 0.10
        case .healthCare:
            perc = 0.10
        case .housing:
            perc = 0.25
        case .transportation:
            perc = 0.10
        case .studentLoanDebt:
            perc = 0.10
        case .savings:
            perc = 0.25
        }
        
        return Double(totalAnnualIncome) * perc
    }
}

struct IncomeProfile {
    var paychecks: [IncomeType]
}

enum IncomeStage {
    case salary
    case hourly
}

enum IncomeType {
    case paycheck
    case gift
    case bonus
}
