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

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "StockRecords", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()

    var mainContext: NSManagedObjectContext {
        container.viewContext
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        do {
            Stock(symbol: "GME", name: "GameStop")
            try viewContext.save()
        } catch {
            fatalError("Unable to create preview")
        }
        return dataController
    }()

    func backgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }

    func save(context: NSManagedObjectContext = DataController.shared.mainContext) throws {
        var error: Error?

        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch let saveError {
                    error = saveError
                }
            }
        }

        if let error = error { throw error }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        // Create fetch request
        // Create batch delete request
        // execute batch
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
}
