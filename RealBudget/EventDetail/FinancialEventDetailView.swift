//
//  FinancialEventDetail.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/23/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}

struct FinancialEventDetailView: View {
    @State private var isSaving = false
    @State private var shouldDisableSave: Bool = false
    @State private var scratchModel: FinancialEvent
    @State private var valueText: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    static let formatter: NumberFormatter = {
       NumberFormatter()
    }()
    
    private func string(from value: Int?) -> String {
        guard
            let value = value,
            let s = NumberFormatter.currency.string(from: NSNumber(value: value)) else { return "" }
        return s
    }
    
    var amountProxy: Binding<String> {
        Binding<String>(
            get: { self.string(from: self.scratchModel.value) },
            set: {
                if let value = FinancialEventDetailView.formatter.number(from: $0) {
                    self.scratchModel.value = value.intValue
                }
            }
        )
    }
    
    init(event: FinancialEvent?) {
        if let event = event {
            _scratchModel = State(initialValue: event)
        } else {
            let event = FinancialEvent(id: UUID().uuidString, type: .expense, name: "", value: 0, frequency: .weekly, startDate: Date(), endDate: nil, amountString: "")
            _scratchModel = State(initialValue: event)
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
            Text("Financial event")
            Form {
                Group {
                    Section {
                        TextField("Name", text: $scratchModel.name, onEditingChanged: { didChange in
                            self.shouldDisableSave = didChange
                        })
                        
                        Picker("Type", selection: $scratchModel.type) {
                            Text("Income").tag(FinancialEventType.income)
                            Text("Expense").tag(FinancialEventType.expense)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Amount", text: amountProxy).keyboardType(.decimalPad)
                        
                        Picker("Frequency", selection: $scratchModel.frequency) {
                            Text("Weekly").tag(Frequency.weekly)
                            Text("Bi-weekly").tag(Frequency.biweekly)
                            Text("Monthly").tag(Frequency.monthly)
                            Text("Annually").tag(Frequency.annually)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .modifier(KeyboardHeightModifier())
        }.padding(.top, 40)
    }
}
