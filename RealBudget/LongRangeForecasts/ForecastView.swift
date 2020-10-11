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
            Text("100")
            Spacer()
        }
    }
}

struct CenterLineEyeView: View {
    let isCurrentWeek: Bool
    
    var body: some View {
        VStack {
            Rectangle().frame(width: 1.0, height: 40, alignment: .center)
            Image(systemName: isCurrentWeek ? "largecircle.fill.circle" : "smallcircle.fill.circle")
            Rectangle().frame(width: 1.0, height: 40, alignment: .center)
        }
    }
}
