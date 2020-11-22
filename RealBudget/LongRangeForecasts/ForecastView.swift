//
//  Forecast.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/5/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct ForecastView: View {
    let forecast: Forecast
    
    var body: some View {
        HStack() {
            Spacer()
            Text("\(RBDateFormatter.shared.formatter.string(from: forecast.date))")
            CenterLineEyeView(isCurrentWeek: forecast.isCurrentWeek)
            .alignmentGuide(.centerLine) { d in d[VerticalAlignment.center] }
            Text("\(forecast.balance)")
            Spacer()
        }
    }
}
