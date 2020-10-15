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
    @State var isShowingInfo = false
    @State var currentModal: PresentedLongRangeModal? = nil
    
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
                                isEditing.toggle()
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
                    LongRangeBottomView(
                        balance: Int(state.first?.actualBalance ?? 0),
                        isEditing: $isEditing,
                        currentModal: $currentModal
                    ).background(Color(red: 0.99, green: 0.80, blue: 0.00))
                    .cornerRadius(5)
                    .sheet(item: $currentModal) {  item in
                        switch item {
                        case .about:
                            AboutView()
                        case .currentState:
                            CurrentStateView().environment(\.managedObjectContext, managedObjectContext)
                        }
                    }
                }
                if !events.isEmpty {
                    Button(action: {
                        self.currentModal = .about
                        self.isEditing.toggle()
                    }) {
                        Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                    }
                    .position(x: 40, y: 40)
                    
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

enum PresentedLongRangeModal: Int, Hashable, Identifiable {
    case currentState = 0
    case about = 1
    
    var id: Int {
        self.hashValue
    }
}
