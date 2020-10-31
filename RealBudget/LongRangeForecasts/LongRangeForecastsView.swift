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
    @State var isShowingInfo = false
    
    @Binding var activeTab: Int
    
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    @State var localState: FinancialState?
    
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
            ZStack {
                VStack(alignment: .center) {
                    if events.isEmpty {
                        VStack {
                            Text(introText).padding().multilineTextAlignment(.center)
                            Button("Start adding data") {
                                // switch tabs
                                self.activeTab = 1
//                                isEditing.toggle()
                            }
                            .padding()
                        }
                    }
                    ScrollView {
                        VStack(alignment: .centerLine, spacing: 0) {
                            ForEach(data) { data in
                                ForecastView(forecast: data).frame(maxWidth: g.size.width)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var introText: String {
        """
        Just starting?
        Predict your budget by adding
        your current balance and some
        expense events like rent / mortgage
        and income events such as paydays.
        Then watch as the algorithmic magic of this
        app predicts what your balance would be a week
        at a time for the next 52 weeks.
        """
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
