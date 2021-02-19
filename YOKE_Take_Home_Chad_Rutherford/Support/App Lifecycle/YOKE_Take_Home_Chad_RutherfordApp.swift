//
//  YOKE_Take_Home_Chad_RutherfordApp.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/11/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import SwiftUI

@main
struct YOKE_Take_Home_Chad_RutherfordApp: App {

    @StateObject var dataController: DataController
    let dataImporter: DataImporter

    let stocksToImport = [
        "GME",
        "AAPL",
        "TSLA",
        "CRSR",
        "BCRX",
        "ELY"
    ]

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        dataImporter = DataImporter(persistentContainer: dataController.container)
        dataImporter.fetchStocks(stockSymbols: stocksToImport)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
        }
    }

    func save(_ note: Notification) {
        do {
            try dataController.save(context: dataController.mainContext)
        } catch {
            dataController.mainContext.reset()
        }
    }
}
