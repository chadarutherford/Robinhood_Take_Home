//
//  DataController.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/15/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

class DataController: ObservableObject {

    let container: NSPersistentContainer

    static let shared = DataController()

    // Initializer checks if in memory database is requested to prevent
    // Unwanted changes to the data store.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "StockRecords", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading stores: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // The Model belonging to the NSPersistentContainer
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "StockRecords", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()

    // The viewContext. Should not save network objects in this context.
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }

    // A new background threaded context. Safe to save network objects in this context.
    func backgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
}
