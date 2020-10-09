//
//  FinancialStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct LongRangeForecastsView: View {
    @State var sectionState: [FinancialEventType: Bool] = [:]
    @State var incomeSectionState: [Int: Bool] = [:]
    @State var expenseSectionState: [Int: Bool] = [:]
    @State var balanceText: String = ""
    @State var isShowingNewEvent = false
    
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
    
    var body: some View {
        // edit button in nav view , toggles to save when active
        GeometryReader { g in
            VStack {
                ScrollView {
                    VStack(alignment: .centerLine, spacing: 0) {
                        ForEach(sampleData) { data in
                            ForecastView(forecast: data).frame(maxWidth: g.size.width)
                        }
                    }
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
