//
//  FinancialEventDetail.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/23/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct FinancialEventDetail: View {
    @State private var isSaving = false
    @State private var shouldDisableSave: Bool = false
    @State private var scratchModel: FinancialEvent
    @State private var valueText: String = ""
    
    init(event: FinancialEvent?) {
        if let event = event {
            _scratchModel = State(initialValue: event)
        } else {
            _scratchModel = State(initialValue: FinancialEvent(
                id: "",
                type: .expense,
                name: "",
                value: 0,
                frequency: .daily,
                notes: nil,
                startDate: Date(),
                endDate: nil)
            )
        }
        
    }
    
    var body: some View {
        Form {
            Group {
                Section {
                    TextField("Name", text: $scratchModel.name, onEditingChanged: { didChange in
                        self.shouldDisableSave = didChange
                    })
                    Picker("Type", selection: $scratchModel.type) {
                        Text("Income").tag(FinancialEventType.income)
                        Text("Expense").tag(FinancialEventType.expense)
                    }.pickerStyle(SegmentedPickerStyle())
                    TextField("Amount", text: $valueText, onEditingChanged: { (changed) in
                        
                    }) {
                        
                    }
                }
            }
        }
    }
}

//struct FinancialEventDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FinancialEventDetail()
//    }
//}
