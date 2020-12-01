//
//  MoneyEntryView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/28/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct MoneyEntryView: View {
    @Binding var amount: Int
    @Binding var isEditing: Bool
    @State private var existingBalance: Int
    
    init(amount: Binding<Int>, isEditing: Binding<Bool>, existingBalance: Int) {
        _amount = amount
        _isEditing = isEditing
        _existingBalance = State(initialValue: existingBalance)
    }

    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: existingBalance) },
            set: {
                self.existingBalance = Int($0) ?? 0
                self.amount = Int($0) ?? 0
            }
        )
    }

    var body: some View {
        HStack {
            Text("Current balance ($)")
            TextField("Amount", text: amountProxy, onEditingChanged: { (isEditing) in
                self.isEditing = isEditing
            })
            .multilineTextAlignment(.trailing).keyboardType(.numberPad)
            .padding()
        }
    }

    private func string(from value: Int) -> String {
        return "\(value)"
    }
}
