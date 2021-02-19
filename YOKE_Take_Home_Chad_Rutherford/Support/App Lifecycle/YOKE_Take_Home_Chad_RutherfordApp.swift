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
        dataImporter.fetchStocks(stockSymbols: stocksToImport)
        for stock in stocksToImport {
            dataImporter.fetchTimeSeries(for: stock, withType: .intraday)
            dataImporter.fetchTimeSeries(for: stock, withType: .daily)
            dataImporter.fetchTimeSeries(for: stock, withType: .weekly)
            dataImporter.fetchTimeSeries(for: stock, withType: .monthly)
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(dataImporter)
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
