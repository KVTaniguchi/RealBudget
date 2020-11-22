//
//  EventButton.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 11/22/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

struct EventButton: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let event: RBEvent
    @State var isPresenting: Bool = false
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    var displayableEvent: RBEvent {
        events.first(where: { event.id == $0.id }) ?? event
    }
    
    var body: some View {
        Button("\(displayableEvent.name ?? "No name") $\(displayableEvent.change)") {
            self.isPresenting.toggle()
        }
        .sheet(isPresented: $isPresenting) {
            FinancialEventDetailView(event: event).environment(\.managedObjectContext, managedObjectContext)
        }
    }
}
