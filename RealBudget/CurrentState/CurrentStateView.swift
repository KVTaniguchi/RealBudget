//
//  CurrentStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct CurrentStateView: View {
    @State var isEditing = false
    @State var balance = 0
    @State var showingEvent = false
    
    var body: some View {
        List {
            Text("Edit your balance, income, and expenses")
            .padding(.top, 60)
            .font(.title)
            Section {
                MoneyEntryView(amount: $balance, isEditing: $isEditing)
                if isEditing {
                    Button("Done") {
                        isEditing.toggle()
                        hideKeyboard()
                    }.accentColor(Color.blue)
                }
            }.padding(.top, 40)
            Section {
                Button(action: {
                    self.showingEvent.toggle()
                }) {
                    Text("Add new")
                }.sheet(isPresented: $showingEvent) {
                    FinancialEventDetailView(event: nil)
                }
            }.padding(.top, 60)
            Section {
                Text("Expenses")
                Text("Income")
            }
            
        }
        .onDisappear {
            print("save \(balance)")
        }
        // list
        // current balance field
        // expenses field -> nav link to expenses list
        // income field -> nav link to incomes list
    }
}

struct CurrentStateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentStateView()
    }
}

struct MoneyEntryView: View {
    @Binding var amount: Int
    @Binding var isEditing: Bool

    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: self.amount) },
            set: {
                if let value = RBMoneyFormatter.shared.formatter.number(from: $0) {
                    self.amount = value.intValue
                }
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
        "$\(value)"
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
