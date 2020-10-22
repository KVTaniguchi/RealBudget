//
//  MoneyEntryView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/21/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct MoneyEntryView: View {
    @Binding var amount: Int
    @Binding var isEditing: Bool
    @State var existingBalance: Int?

    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: existingBalance ?? self.amount) },
            set: {
                self.existingBalance = Int($0)
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
            .padding(.trailing, 60)
        }
    }

    // I had multiple fields on this page so extracted this into a function...
    private func string(from value: Int) -> String {
        return "\(value)"
    }
}
