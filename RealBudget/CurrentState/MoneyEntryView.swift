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
    @State var operatingAmount: Int = 0
    @Binding var isOperating: Bool
    @Binding var isEditing: Bool
    @State var existingBalance: Int?
    @State private var operation: Operation = .add

    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: existingBalance ?? self.amount) },
            set: {
                self.existingBalance = Int($0)
                self.amount = Int($0) ?? 0
            }
        )
    }
    
    var operationProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: self.operatingAmount) },
            set: {
                self.operatingAmount = Int($0) ?? 0
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Current ($)").padding()
            HStack {
                if isOperating {
                    Text(amountProxy.wrappedValue)
                    .padding()
                } else {
                    TextField("Amount", text: amountProxy, onEditingChanged: { (isEditing) in
                        self.isEditing = isEditing
                    })
                    .keyboardType(.numberPad)
                    .padding()
                }
                if !isEditing {
                    Spacer()
                    Button("+ or -") {
                        if isOperating {
                            let _existingBalance = self.existingBalance ?? 0
                            switch operation {
                            case .add:
                                self.existingBalance = _existingBalance + operatingAmount
                            case .subtract:
                                self.existingBalance = _existingBalance - operatingAmount
                            }
                        }
                        
                        isOperating.toggle()
                        isEditing.toggle()
                    }.padding()
                }
            }
            if isOperating {
                Picker("+ or -", selection: $operation) {
                    Text("Add").tag(Operation.add)
                    Text("Subtract").tag(Operation.subtract)
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("+ or -", text: operationProxy)
                    .keyboardType(.numberPad)
                    .padding()
            }
        }
    }

    private func string(from value: Int) -> String {
        return "\(value)"
    }
}

private enum Operation: Int {
    case add = 0
    case subtract = 1
}
