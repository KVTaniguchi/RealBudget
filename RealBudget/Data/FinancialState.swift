//
//  FinancialState.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

struct FinancialState {
    let actualBalance: Int
    var events: [FinancialEvent]
}

struct FinancialStateRecord {
    let identifier: String
    var balance: Int
}

extension FinancialStateRecord {
    static let ckKey = "realBudgetFinancialState"
    static let identifier = "identifier"
    static let balance = "balance"
}
