//
//  FinancialStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct FinancialStateView: View {
    @State var sectionState: [FinancialEventType: Bool] = [:]
    @State var incomeSectionState: [Int: Bool] = [:]
    @State var expenseSectionState: [Int: Bool] = [:]
    
    var body: some View {
        // edit button in nav view , toggles to save when active
        NavigationView {
            List {
                Text("True Balance: 100")
                Text("Predicted Balance: 100")
                // Income total cell -> on tap
                // on date picker predictor
                
                // button - call in all debts // reverts back on tap again
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
            .navigationBarTitle("Financial State")
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
