//
//  FinancialStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct LongRangeForecastsView: View {
    @State private var isShowingInfo = false
    
    @Binding var activeTab: Int
    
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    @State private var localState: FinancialState?
    
    private var data: [Forecast] {
        guard let state = state.first else { return [] }
        return FinancialResource.forecast(state: state, events: events)
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                VStack(alignment: .center) {
                    if events.isEmpty {
                        VStack {
                            Text(introText).padding().multilineTextAlignment(.center)
                            Button("Start adding data") {
                                self.activeTab = 1
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
    
    private var introText: String {
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
