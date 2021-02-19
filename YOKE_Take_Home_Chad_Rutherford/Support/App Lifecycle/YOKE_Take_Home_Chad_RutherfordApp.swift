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

    @StateObject var dataImporter: DataImporter
    @StateObject var dataController: DataController

    // Default stock values that should be present on app launch.
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
        let dataImporter = DataImporter(persistentContainer: dataController.container)
        _dataController = StateObject(wrappedValue: dataController)
        _dataImporter = StateObject(wrappedValue: dataImporter)

        // The initial data fetch. If this is only the first launch, the network is used.
        // After that, data is retrieved from CoreData to prevent network usage for the user.
        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.didDownloadInitialData) {
            dataImporter.fetchStocks(stockSymbols: stocksToImport)
            for stock in stocksToImport {
                dataImporter.fetchTimeSeries(for: stock, withType: .intraday)
                dataImporter.fetchTimeSeries(for: stock, withType: .daily)
                dataImporter.fetchTimeSeries(for: stock, withType: .weekly)
                dataImporter.fetchTimeSeries(for: stock, withType: .monthly)
            }
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.didDownloadInitialData)
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(dataImporter)
        }
    }
}
