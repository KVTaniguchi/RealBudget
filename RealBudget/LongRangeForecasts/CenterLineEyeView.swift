//
//  CenterLineEyeView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 11/22/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

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
