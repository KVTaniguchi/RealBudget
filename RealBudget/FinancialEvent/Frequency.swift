//
//  Frequency.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

enum Frequency: CaseIterable {
    init?(index: Int) {
        switch index {
        case 0:
            self = .onceOnly
        case 1:
            self = .daily
        case 2:
            self = .weekly
        case 3:
            self = .biweekly
        case 4:
            self = .monthly
        case 5:
            self = .annually
        default:
            return nil
        }
    }
    
    case onceOnly
    case daily
    case weekly
    case biweekly
    case monthly
    case annually
    
    var index: Int {
        switch self {
        case .onceOnly:
            return 0
        case .daily:
            return 1
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
        case .onceOnly:
            return "Once only"
        case .daily:
            return "Daily"
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
}
