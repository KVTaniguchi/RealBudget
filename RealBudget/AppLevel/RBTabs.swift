//
//  RBTabs.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/31/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct RBTabView: View {
    @State private var activeTab: Int = 0
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    var body: some View {
        TabView(selection: $activeTab) {
            LongRangeForecastsView(activeTab: $activeTab)
                .environment(\.managedObjectContext, managedObjectContext)
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Forecast")
            }.tag(0)
            CurrentStateView()
                .environment(\.managedObjectContext, managedObjectContext)
            .tabItem {
                Image(systemName: "perspective")
                Text("Now: $\(Int(state.first?.actualBalance ?? 0))")
            }.tag(1)
        }
    }
}

extension RBTabView {
    var activeTabTitle: String {
        switch activeTab {
        case 0:
            return "shop"
        case 1:
            return "account"
        default:
            return ""
        }
    }
}
