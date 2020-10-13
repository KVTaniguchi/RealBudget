//
//  CurrentStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct CurrentStateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isEditing = false
    @State var balance: Int = 0
    @State var showingEvent = false
    
    private var existingBalance: Int? {
        guard let existingBalance = state.first?.actualBalance else { return nil }
        return Int(existingBalance)
    }
    
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
        return events.filter { $0.type == 1}
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }
            .padding()
            Form {
                Text("Edit your balance, income, and expenses")
                .font(.title)
                Section {
                    MoneyEntryView(
                        amount: $balance,
                        isEditing: $isEditing,
                        existingBalance: existingBalance
                    )
                    if isEditing {
                        Button("Done") {
                            hideKeyboard()
                            guard balance > 0 else { return }
                            if let state = state.first {
                                state.actualBalance = Int32(balance)
                            } else {
                                let newState = RBState(context: managedObjectContext)
                                newState.actualBalance = Int32(balance)
                            }
                            
                            save()
                            isEditing = false
                        }.accentColor(Color.blue)
                    }
                }
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
                }
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
                    Text("Income")
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
        }.background(Color(red: 0.75, green: 0.85, blue: 0.86))
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
    @State var existingBalance: Int?

    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: existingBalance ?? self.amount) },
            set: {
                self.existingBalance = Int($0)
                self.amount = Int($0) ?? 0
//                if let value = RBMoneyFormatter.shared.formatter.number(from: $0) {
//                    self.existingBalance = value.intValue
//                    self.amount = value.intValue
//                } else {
//                    print("fail")
//                }
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
