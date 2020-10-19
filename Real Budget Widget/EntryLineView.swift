//
//  EntryLineView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/19/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct EntryLineView: View {
    let forecast: Forecast
    
    var body: some View {
        VStack(alignment: .center) {
            Text(RBDateFormatter.shared.string(from: forecast.date))
                .font(.custom("arial", fixedSize: 14))
                .fontWeight(.light)
            Text("\(forecast.balance)")
                .font(.custom("arial", fixedSize: 14))
                .fontWeight(.light)
        }
    }
}
