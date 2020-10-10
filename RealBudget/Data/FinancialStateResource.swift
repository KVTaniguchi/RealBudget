//
//  FinancialStateResource.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/9/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import Combine
import CoreData
import SwiftUI

final class FinancialStateResource: ObservableObject {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: RBEvent.entity(), sortDescriptors: []
    ) private var rbEvents: FetchedResults<RBEvent> {
        didSet {
            state.events = rbEvents.map {
                FinancialEvent(
                    id: $0.id,
                    type: FinancialEventType(rawValue: Int($0.type)) ?? .expense,
                    name: $0.name ?? "",
                    value: Int($0.change),
                    frequency: Frequency(rawValue: Int($0.frequency)) ?? .monthly,
                    startDate: $0.startDate ?? Date(),
                    endDate: $0.endDate
                )
            }
        }
    }
    
    @FetchRequest(
        entity: RBState.entity(), sortDescriptors: []
    ) private var rbState: FetchedResults<RBState> {
        didSet {
            if rbState.count > 1 {
                assertionFailure("should have only 1 state")
            }
            state.actualBalance = Int(rbState.first?.actualBalance ?? 0)
        }
    }
    
    @Published var state: FinancialState = FinancialState(actualBalance: 0, events: [])
    
    static let shared = FinancialStateResource()
    
    func save() {
        
    }
}
