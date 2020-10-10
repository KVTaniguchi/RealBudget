//
//  LongRangeBottomView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct LongRangeBottomView: View {
    @Binding var isEditing: Bool
    
    private var balanceString: String
    
    init(balance: Int, isEditing: Binding<Bool>) {
        if balance == 0 {
            balanceString = "-----"
        } else {
            balanceString = "$\(balance)"
        }
        _isEditing = isEditing
    }
    
    var body: some View {
        HStack {
            Text("\(balanceString)").padding(.trailing, 60)
            Button("Edit") {
                isEditing.toggle()
            }.padding(.leading, 60)
        }.frame(width: 300, height: 60, alignment: .center)
    }
}
