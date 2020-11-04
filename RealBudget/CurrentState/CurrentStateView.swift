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
    @State private var showingAbout = false
    
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
        events.filter { $0.type == 1}
    }
    
    var body: some View {
        VStack(alignment: .leading) {
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
                    Button("Add new") {
                        self.showingEvent.toggle()
                    }
                    .sheet(isPresented: $showingEvent) {
                        FinancialEventDetailView(event: nil).environment(\.managedObjectContext, managedObjectContext)
                    }
                    
                    Text("Expenses").padding(.top, 16)
                    ForEach(expenses) { expense in
                        Button("\(expense.name ?? "No name") $\(expense.change)") {
                            self.showingEvent.toggle()
                        }
                        .sheet(isPresented: $showingEvent) {
                            FinancialEventDetailView(event: expense).environment(\.managedObjectContext, managedObjectContext)
                        }
                    }
                    Text("Income").padding(.top, 16)
                    ForEach(income) { income in
                        Button("\(income.name ?? "No name") $\(income.change)") {
                            self.showingEvent.toggle()
                        }
                        .sheet(isPresented: $showingEvent) {
                            FinancialEventDetailView(event: income).environment(\.managedObjectContext, managedObjectContext)
                        }
                    }
                }
                Section {
                    Button("About") {
                        self.showingAbout.toggle()
                    }
                }
                .sheet(isPresented: $showingAbout) {
                    AboutView()
                }
            }
        }.background(Color(red: 0.99, green: 0.80, blue: 0.00))
    }
    
    func save() {
        if managedObjectContext.hasChanges {
            do {
                _ = try managedObjectContext.save()
            } catch {}
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
