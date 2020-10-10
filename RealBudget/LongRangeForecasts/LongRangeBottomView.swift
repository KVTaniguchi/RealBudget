//
//  LongRangeBottomView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct LongRangeBottomView: View {
    var state: FinancialState
    @Binding var isEditing: Bool
    
    private var balanceString: String
    
    init(state: FinancialState, isEditing: Binding<Bool>) {
        self.state = state
        if state.actualBalance == 0 {
            balanceString = "-----"
        } else {
            balanceString = "$\(state.actualBalance)"
        }
        _isEditing = isEditing
    }
    
    var body: some View {
        HStack {
            Text("$\(state.actualBalance)").padding(.trailing, 60)
            Button("Edit") {
                isEditing.toggle()
            }.padding(.leading, 60)
        }.frame(width: 300, height: 60, alignment: .center)
    }
}
