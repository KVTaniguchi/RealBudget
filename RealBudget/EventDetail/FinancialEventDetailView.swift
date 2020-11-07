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
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var isSaving = false
    @State private var shouldDisableSave: Bool = false
    @State private var scratchModel: FinancialEvent
    @State private var valueText: String = ""
    @State private var startDate: Date
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    static let formatter: NumberFormatter = {
       NumberFormatter()
    }()
    
    private var event: RBEvent?
    
    init(event: RBEvent?) {
        if let event = event {
            self.event = event
            let type = FinancialEventType(rawValue: Int(event.type)) ?? .expense
            let frequency = Frequency(rawValue: Int(event.frequency)) ?? .monthly
            let existingEvent = FinancialEvent(
                id: event.id,
                type: type,
                name: event.name ?? "No name",
                value: Int(event.change),
                frequency: frequency,
                startDate: event.startDate ?? Date(),
                endDate: event.endDate,
                isActive: event.isActive
            )
            _scratchModel = State(initialValue: existingEvent)
            _startDate = State(initialValue: event.startDate ?? Date())
        } else {
            let event = FinancialEvent(
                id: ObjectIdentifier(NSNumber(1)),
                type: .expense,
                name: "",
                value: 0,
                frequency: .weekly,
                startDate: Date(),
                endDate: nil
            )
            _scratchModel = State(initialValue: event)
            _startDate = State(initialValue: Date())
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding(.leading, 20)
                Spacer()
                Button("Save") {
                    if let event = event {
                        event.setValue(Int16(scratchModel.value), forKey: "change")
                        event.setValue(startDate, forKey: "startDate")
                        event.setValue(Int16(scratchModel.frequency.rawValue), forKey: "frequency")
                        event.setValue(Int16(scratchModel.type.rawValue), forKey: "type")
                        event.setValue(scratchModel.name, forKey: "name")
                        event.setValue(scratchModel.isActive, forKey: "isActive")
                    } else {
                        let newEvent = RBEvent(context: managedObjectContext)
                        newEvent.name = scratchModel.name
                        newEvent.change = Int16(scratchModel.value)
                        newEvent.startDate = startDate
                        newEvent.frequency = Int16(scratchModel.frequency.rawValue)
                        newEvent.type = Int16(scratchModel.type.rawValue)
                        newEvent.isActive = scratchModel.isActive
                    }
                    
                    save()
                }.padding(.trailing, 20)
            }.padding(.bottom, 20)
            Text("Financial event")
            Form {
                Section {
                    TextField("Name", text: $scratchModel.name, onEditingChanged: { didChange in
                        self.shouldDisableSave = didChange
                    })
                    Picker("Type", selection: $scratchModel.type) {
                        Text("Income").tag(FinancialEventType.income)
                        Text("Expense").tag(FinancialEventType.expense)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("Amount ($)", text: amountProxy).keyboardType(.decimalPad)
                    Picker("Frequency", selection: $scratchModel.frequency) {
                        Text("Weekly").tag(Frequency.weekly)
                        Text("Bi-weekly").tag(Frequency.biweekly)
                        Text("Monthly").tag(Frequency.monthly)
                        Text("Annually").tag(Frequency.annually)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    DatePicker(
                        selection: $startDate,
                        in: Date()...,
                        displayedComponents: .date
                    ) {
                        Text("Select a start date")
                    }
                    Text("Start date is \(startDate, formatter: RBDateFormatter.shared.formatter)")
                }
                Section {
                    Toggle(
                        isOn: $scratchModel.isActive
                    ) {
                        Text("Active")
                    }.padding()
                }
                if let event = event {
                    Section {
                        Button("Delete") {
                            managedObjectContext.delete(event)
                            save()
                        }.accentColor(.red)
                    }
                }
            }
            .modifier(KeyboardHeightModifier())
        }.padding(.top, 40)
    }
    
    private func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                self.presentationMode.wrappedValue.dismiss()
            } catch {}
        }
    }
    
    private func string(from value: Int?) -> String {
        guard
            let value = value else { return "---" }
        return "\(value)"
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
}
