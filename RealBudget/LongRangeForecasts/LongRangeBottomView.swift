//
//  LongRangeBottomView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

//struct LongRangeBottomView: View {
//    @Binding var isEditing: Bool
//    @Binding var modal: PresentedLongRangeModal?
//    private var balanceString: String
//    
//    init(balance: Int, isEditing: Binding<Bool>, currentModal: Binding<PresentedLongRangeModal?>) {
//        if balance == 0 {
//            balanceString = "-----"
//        } else {
//            balanceString = "$\(balance)"
//        }
//        _isEditing = isEditing
//        _modal = currentModal
//    }
//    
//    var body: some View {
//        HStack {
//            Text("\(balanceString)").padding(.trailing, 60).foregroundColor(.black)
//            Button("Edit") {
//                modal = .currentState
//                isEditing.toggle()
//            }.padding(.leading, 60)
//        }.frame(width: 300, height: 60, alignment: .center)
//    }
//}
