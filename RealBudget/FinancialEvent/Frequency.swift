//
//  Frequency.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

enum Frequency: CaseIterable {
    case weekly
    case biweekly
    case monthly
    case annually
    
    var index: Int {
        switch self {
        case .weekly:
            return 2
        case .biweekly:
            return 3
        case .monthly:
            return 4
        case .annually:
            return 5
        }
    }
    
    var title: String {
        switch self {
        case .weekly:
            return "Weekly"
        case .biweekly:
            return "Bi-weekly"
        case .monthly:
            return "Monthly"
        case .annually:
            return "Annually"
        }
    }
    
    var calendarComponent: Calendar.Component {
        switch self {
        case .weekly:
            return .day
        case .biweekly:
            return .day
        case .monthly:
            return .month
        case .annually:
            return .year
        }
    }
    
    var recurrences: Int {
        switch self {
        case .weekly:
            return 53
        case .biweekly:
            return 27
        case .monthly:
            return 12
        case .annually:
            return 2
        }
    }
    
    var interval: Int {
        switch self {
        case .weekly:
            return 7
        case .biweekly:
            return 14
        case .monthly:
            return 1
        case .annually:
            return 1
        }
    }
}
