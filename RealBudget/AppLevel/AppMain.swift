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
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        container = NSPersistentContainer(name: "FinancialState")
        container.loadPersistentStores { (description, error) in
            print(description)
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                saveContext()
            }
        }
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show the error here
            }
        }
    }
}
