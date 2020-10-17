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
        let persistContainer = NSPersistentContainer(name: "FinancialState")
        
        persistContainer.loadPersistentStores { (description, error) in
            if let error = error {
                print(error)
            }
            if let oldUrl = description.url {
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: persistContainer.managedObjectModel)
                var storeOptions = [AnyHashable : Any]()
                storeOptions[NSMigratePersistentStoresAutomaticallyOption] = true
                storeOptions[NSInferMappingModelAutomaticallyOption] = true
                
                guard let newStoreUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.realbudget") else { return }
                
                var targetUrl : URL? = nil
                var needMigrate = false

                if FileManager.default.fileExists(atPath: oldUrl.path) {
                    needMigrate = true
                    targetUrl = oldUrl
                }

                if FileManager.default.fileExists(atPath: newStoreUrl.path){
                    needMigrate = false
                    targetUrl = newStoreUrl
                }
                
                if targetUrl == nil {
                    targetUrl = newStoreUrl
                }
                
                if needMigrate {
                    do {
                        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: targetUrl!, options: storeOptions)
                        if let store = coordinator.persistentStore(for: targetUrl!)
                         {
                            do {
                                try coordinator.migratePersistentStore(store, to: newStoreUrl, options: storeOptions, withType: NSSQLiteStoreType)

                            } catch let error {
                                print("migrate failed with error : \(error)")
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
        
        self.container = persistContainer
    }
    
    var body: some Scene {
        WindowGroup {
            LongRangeForecastsView().environment(\.managedObjectContext, container.viewContext)
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

