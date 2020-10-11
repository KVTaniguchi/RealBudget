//
//  CurrentStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct CurrentStateView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isEditing = false
    @State var balance: Int = 0
    @State var showingEvent = false
    
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    var income: [RBEvent] {
        events.filter { $0.type == 0 }
    }
    
    var expenses: [RBEvent] {
        for event in events {
            print("\(event.name) \(event.type) \(event.change)")
        }
        return events.filter { $0.type == 1}
    }
    
    var body: some View {
        List {
            Text("Edit your balance, income, and expenses")
            .padding(.top, 60)
            .font(.title)
            Section {
                MoneyEntryView(amount: $balance, isEditing: $isEditing, existingBalance: Int(state.first?.actualBalance ?? 0))
                if isEditing {
                    Button("Done") {
                        guard balance > 0 else { return }
                        if let state = state.first {
                            state.actualBalance = Int32(balance)
                        } else {
                            let newState = RBState(context: managedObjectContext)
                            newState.actualBalance = Int32(balance)
                        }
                        save()
                        isEditing.toggle()
                        hideKeyboard()
                    }.accentColor(Color.blue)
                }
            }.padding(.top, 40)
            Section {
                Button(action: {
                    self.showingEvent.toggle()
                }
                ) {
                    Text("Add new").foregroundColor(Color.blue)
                }
                .sheet(isPresented: $showingEvent) {
                    FinancialEventDetailView(event: nil).environment(\.managedObjectContext, managedObjectContext)
                }
            }.padding(.top, 60)
            Section {
                Text("Expenses")
                ForEach(expenses) { expense in
                    Button(action: {
                        self.showingEvent.toggle()
                    }
                    ) {
                        Text("\(expense.name ?? "No name") $\(expense.change)")
                    }
                    .sheet(isPresented: $showingEvent) {
                        FinancialEventDetailView(event: expense).environment(\.managedObjectContext, managedObjectContext)
                    }
                }
                ForEach(income) { income in
                    Button(action: {
                        self.showingEvent.toggle()
                    }
                    ) {
                        Text("\(income.name ?? "No name") $\(income.change)")
                    }
                    .sheet(isPresented: $showingEvent) {
                        FinancialEventDetailView(event: income).environment(\.managedObjectContext, managedObjectContext)
                    }
                }
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
    
    func save() {
        if managedObjectContext.hasChanges {
            do {
                _ = try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct MoneyEntryView: View {
    @Binding var amount: Int
    @Binding var isEditing: Bool
    var existingBalance: Int?

    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: existingBalance ?? self.amount) },
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