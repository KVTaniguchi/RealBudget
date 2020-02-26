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
    
    init(event: FinancialEvent) {
        _scratchModel = State(initialValue: event)
    }
    
    var body: some View {
        Form {
            Group {
                Section {
                    TextField("Name", text: $scratchModel.name, onEditingChanged: { didChange in
                        self.shouldDisableSave = didChange
                    })
                    Picker("Type", selection: $scratchModel.type) {
                        Text("Income").tag(0)
                        Text("Expense").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
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
