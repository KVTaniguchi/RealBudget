//
//  RBMoneyFormatters.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/6/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

final class RBMoneyFormatter {
    static let shared = RBMoneyFormatter()
    
    let formatter: NumberFormatter
    
    init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
    }
}
