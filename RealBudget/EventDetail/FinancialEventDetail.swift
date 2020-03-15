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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    static let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
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
        Group {
            HStack {
                Button("Close") {
                    self.presentationMode.wrappedValue.dismiss()
                }.padding(.leading, 20)
                Spacer()
                Button("Save") {
                    print("saved pressed")
                    print(self.$scratchModel)
                }.padding(.trailing, 20)
            }.padding(.bottom, 20)
            Text("Financial event details")
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
                        TextField("Amount", value: $scratchModel.value, formatter: FinancialEventDetail.numberFormatter)
                        Picker("Frequency", selection: $scratchModel.frequency) {
                            Text("Daily").tag(Frequency.daily)
                            Text("Weekly").tag(Frequency.weekly)
                            Text("Bi-weekly").tag(Frequency.biweekly)
                            Text("Monthly").tag(Frequency.monthly)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .modifier(KeyboardHeightModifier())
        }.padding(.top, 40)
    }
}

//struct FinancialEventDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FinancialEventDetail()
//    }
//}
