//
//  FinancialStateResource.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/23/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import Combine

final class FinancialStateResource: ObservableObject {
    let objectWillChange = PassthroughSubject<FinancialStateRecord, Never>()
    
    var record: FinancialStateRecord? {
        didSet {
            DispatchQueue.main.async {
                if let record = self.record {
                    self.objectWillChange.send(record)
                }
            }
        }
    }
    
    init() {
        load()
    }
    
    func load() {
        CloudKitManager.shared.loadFinancialState { (state) in
            self.record = state
        }
    }
}

final class FinancialEventsResource: ObservableObject {
    let objectWillChange = PassthroughSubject<[String: FinancialEvent], Never>()
    // get events
    
    var eventsHashed: [String: FinancialEvent] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send(self.eventsHashed)
            }
        }
    }
    
    init() {
        load()
    }
    
    func load() {
        var newEventsHashed = [String: FinancialEvent]()
        CloudKitManager.shared.loadEvents { (events) in
            events.forEach {
                newEventsHashed[$0.id] = $0
            }
            self.eventsHashed = newEventsHashed
        }
    }
}
