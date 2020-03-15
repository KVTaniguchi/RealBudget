//
//  FinancialStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct FinancialStateView: View {
    @EnvironmentObject var financialStateResource: FinancialStateResource
    @EnvironmentObject var eventsResource: FinancialEventsResource
    @State var sectionState: [FinancialEventType: Bool] = [:]
    @State var incomeSectionState: [Int: Bool] = [:]
    @State var expenseSectionState: [Int: Bool] = [:]
    @State var balanceText: String = ""
    @State var isShowingNewEvent = false
    
    var body: some View {
        // edit button in nav view , toggles to save when active
        NavigationView {
            List {
                TextField("True balance", text: $balanceText, onEditingChanged: { (changed) in
                    if let balanceTextInt = Int(self.balanceText) {
                        self.financialStateResource.record?.balance = balanceTextInt
                    }
                }) {
                    
                }
                Section(header: Text("Future balance")) {
                    Text("Predicted Balance on X date: 100")
                    // Income total cell -> on tap
                    // on date picker predictor
                    Text("Date slider")
                    Text("Date picker")
                }
                
                // button - call in all debts // reverts back on tap again
                Group {
                    ForEach([FinancialEventType.income, FinancialEventType.expense], id: \.self) { type in
                        Section(header: Text(type.sectionTitle).onTapGesture {
                            self.sectionState[type] = !self.sectionIsExpanded(section: type)
                        }) {
                            if self.sectionIsExpanded(section: type) {
                                if type == .expense {
                                    ForEach(5...9, id: \.self) { row in
                                        Text("Row \(row)")
                                    }
                                } else {
                                    ForEach(1...4, id: \.self) { row in
                                        Text("Row \(row)")
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Financial State")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isShowingNewEvent = true
                }) {
                    Image(systemName: "plus.square.fill").resizable().frame(width: 25.0, height: 25.0).foregroundColor(Color.blue)
                }.sheet(isPresented: self.$isShowingNewEvent, onDismiss: {
                    self.isShowingNewEvent = false
                }) {
                    FinancialEventDetail(event: nil).environmentObject(self.eventsResource)
                }
            )
        }
    }
    
    func sectionIsExpanded(section: FinancialEventType) -> Bool {
        sectionState[section] ?? false
    }
    
    func incomeIsExpanded(_ section:Int) -> Bool {
        incomeSectionState[section] ?? false
    }
    
    func expenseIsExpanded(_ section:Int) -> Bool {
        expenseSectionState[section] ?? false
    }
}

struct FinancialStateView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialStateView()
    }
}
