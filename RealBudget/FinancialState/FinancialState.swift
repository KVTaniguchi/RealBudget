//
//  FinancialState.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

struct FinancialStateViewModel {
    var expectedBalance: Int
    var actualBalance: Int
    var incomes: [FinancialEvent]
    var expenses: [FinancialEvent]
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
