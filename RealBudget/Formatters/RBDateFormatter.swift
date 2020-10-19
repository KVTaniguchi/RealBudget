//
//  RBDateFormatter.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/6/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

final class RBDateFormatter {
    static let shared = RBDateFormatter()
    
    let formatter: DateFormatter
    
    init() {
        formatter = DateFormatter()
        formatter.dateStyle = .short
    }
    
    func string(from date: Date) -> String {
        formatter.string(from: date)
    }
}
