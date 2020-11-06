//
//  Income.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/23/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

struct FinancialEvent: Identifiable {
    var id: ObjectIdentifier
    var type: FinancialEventType
    var name: String
    var value: Int
    var frequency: Frequency
    var startDate: Date
    var endDate: Date?
    var isActive = true
    
    var displayValue: String {
        set { }
        get {
            "$\(value)"
        }
    }
}

enum FinancialEventType: Int {
    case income = 0
    case expense = 1
    
    var sectionTitle: String {
        switch self {
        case .expense:
            return "Expenses"
        case .income:
            return "Incomes"
        }
    }
}
