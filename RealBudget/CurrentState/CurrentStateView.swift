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
    @State private var isEditing = false
    @State private var balance: Int = 0
    @State private var showingNew = false
    @State private var showingAbout = false
    @State private var showingAlert = false
    @State private var error: Error?
    
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
    
    private var income: [RBEvent] {
        events.filter { $0.type == 0 }
    }
    
    private var expenses: [RBEvent] {
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
                        existingBalance: existingBalance ?? 0
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
                        self.showingNew.toggle()
                    }
                    .sheet(isPresented: $showingNew) {
                        FinancialEventDetailView(event: nil).environment(\.managedObjectContext, managedObjectContext)
                    }
                    
                    Text("Expenses").padding()
                    ForEach(expenses) { expense in
                        EventButton(event: expense).environment(\.managedObjectContext, managedObjectContext)
                    }
                    Text("Income").padding()
                    ForEach(income) { income in
                        EventButton(event: income).environment(\.managedObjectContext, managedObjectContext)
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
        }
        .background(Color(red: 0.99, green: 0.80, blue: 0.00))
        .alert(
            isPresented: $showingAlert
        ) {
            Alert(
                title: Text("Oops!"),
                message: Text("\(self.error?.localizedDescription ?? "We had an error saving.")"),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
    
    private func save() {
        if managedObjectContext.hasChanges {
            do {
                _ = try managedObjectContext.save()
            } catch {
                self.error = error
                showingAlert.toggle()
            }
        }
    }
}
