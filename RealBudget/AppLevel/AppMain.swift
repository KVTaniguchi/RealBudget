//
//  AppDelegate.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/16/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI
import CoreData
import WidgetKit

@main
struct ReadBudget: App {
    var container: NSPersistentContainer
    @Environment(\.scenePhase) var scenePhase
    @State private var showingAlert = false
    @State private var error: Error?
    
    init() {
        let persistContainer = NSPersistentContainer(name: "FinancialState")
        
        let storeURL = URL.storeURL(for: "group.realbudget", databaseName: "realbudget")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        persistContainer.persistentStoreDescriptions = [storeDescription]
        
        persistContainer.loadPersistentStores { (description, error) in
            #if DEBUG
                print(error.debugDescription)
            #endif
        }
        
        self.container = persistContainer
    }
    
    var body: some Scene {
        WindowGroup {
            RBTabView()
                .environment(\.managedObjectContext, container.viewContext)
                .alert(
                    isPresented: $showingAlert
                ) {
                    Alert(
                        title: Text("Oops!"),
                        message: Text("\(self.error?.localizedDescription ?? "We had an error saving.")"),
                        dismissButton: .default(Text("Ok"))
                    )
                }
        }
        .onChange(
            of: scenePhase
        ) { phase in
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
                
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                self.error = error
                showingAlert.toggle()
            }
        }
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
