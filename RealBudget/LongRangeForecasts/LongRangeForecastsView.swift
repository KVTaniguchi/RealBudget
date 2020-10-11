//
//  FinancialStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct LongRangeForecastsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isEditing = false
    
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    @State var localState: FinancialState?
    
    var sampleData: [Forecast] {
        var sample = [Forecast]()
        
        sample.append(Forecast(date: Date(), change: 0, balance: 0))
        
        var currentDate = Date()
        let oneweek = TimeInterval(604800)
        
        for index in (0 ..< 20) {
            currentDate = currentDate.addingTimeInterval(oneweek)
            let forecast = Forecast(date: currentDate, change: 0, balance: 100 + index)
            sample.append(forecast)
        }
        
        return sample
    }
    
    var data: [Forecast] {
        var data: [Forecast] = []
        
        let actualBalance = Int(state.first?.actualBalance ?? 0)
        let financialEvents = events.map {
            FinancialEvent(
                id: $0.id,
                type: FinancialEventType(rawValue: Int($0.type)) ?? .expense,
                name: $0.name ?? "no name",
                value: Int($0.change),
                frequency: Frequency(rawValue: Int($0.frequency)) ?? .monthly,
                startDate: $0.startDate ?? Date(),
                endDate: $0.endDate
            )
        }
        let state = FinancialState(actualBalance: actualBalance, events: financialEvents)
        let predictions = PredictionEngine.shared.predict(state: state)
        
        let sortedDates = predictions.keys.sorted()
        
        for date in sortedDates {
            if let forecast = predictions[date] {
                data.append(forecast)
            }
        }
        
        return data
    }
    
    var body: some View {
        // edit button in nav view , toggles to save when active
        GeometryReader { g in
            VStack {
                ScrollView {
                    VStack(alignment: .centerLine, spacing: 0) {
                        ForEach(data) { data in
                            ForecastView(forecast: data).frame(maxWidth: g.size.width)
                        }
                    }
                }
                LongRangeBottomView(
                    balance: Int(state.first?.actualBalance ?? 0),
                    isEditing: $isEditing
                ).background(Color(red: 0.77, green: 0.87, blue: 0.96))
                .cornerRadius(5)
                .sheet(isPresented: $isEditing) {
                    CurrentStateView().environment(\.managedObjectContext, managedObjectContext)
                }
            }
        }
    }
}

extension HorizontalAlignment {
    struct CenterLine: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }
    
    static let centerLine = HorizontalAlignment(CenterLine.self)
}
