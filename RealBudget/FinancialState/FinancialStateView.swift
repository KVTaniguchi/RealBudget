//
//  FinancialStateView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct FinancialStateView: View {
    @EnvironmentObject var financialStateResource: FinancialStateResource
    @EnvironmentObject var eventsResource: FinancialEventsResource
    @State var sectionState: [FinancialEventType: Bool] = [:]
    @State var incomeSectionState: [Int: Bool] = [:]
    @State var expenseSectionState: [Int: Bool] = [:]
    @State var balanceText: String = ""
    @State var isShowingNewEvent = false
    
    var sampleData: [Forecast] {
        var sample = [Forecast]()
        
        let currentDate = Date()
        let oneweek = TimeInterval(604800)
        
        for index in (0 ..< 20) {
            let new = currentDate.addingTimeInterval(oneweek)
            let forecast = Forecast(amount: "\(100 + index)", date: new)
            sample.append(forecast)
        }
        
        return sample
    }
    
    // List
    // each cell has a line
    // left side is date
    // right side amount
    
    var body: some View {
        // edit button in nav view , toggles to save when active
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sampleData) { data in
                        ForecastView(forecast: data)
                    }
                }
            }
        }
    }
    
    func sectionIsExpanded(section: FinancialEventType) -> Bool {
        sectionState[section] ?? false
    }
    
    func incomeIsExpanded(_ section:Int) -> Bool {
        incomeSectionState[section] ?? false
    }
    
    func expenseIsExpanded(_ section:Int) -> Bool {
        expenseSectionState[section] ?? false
    }
}

struct FinancialStateView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialStateView()
    }
}
