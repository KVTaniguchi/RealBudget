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
        
        sample.append(Forecast(amount: "100", date: Date()))
        
        var currentDate = Date()
        let oneweek = TimeInterval(604800)
        
        for index in (0 ..< 20) {
            currentDate = currentDate.addingTimeInterval(oneweek)
            let forecast = Forecast(amount: "\(100 + index)", date: currentDate)
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

extension HorizontalAlignment {
    struct CenterLine: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }
    
    static let centerLine = HorizontalAlignment(CenterLine.self)
}
