//
//  FinancialState.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

struct FinancialState {
    var expectedBalance: Int
    var actualBalance: Int
    var incomes: [FinancialEvent]
    var expenses: [FinancialEvent]
}
