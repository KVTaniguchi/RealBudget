//
//  AppDelegate.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI
import CoreData

@main
struct ReadBudget: App {
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FinancialState")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, container.viewContext)
        }
    }
}
