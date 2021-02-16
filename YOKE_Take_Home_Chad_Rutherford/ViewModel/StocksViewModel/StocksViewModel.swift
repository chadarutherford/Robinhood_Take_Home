//
//  StocksViewModel.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/15/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

class StocksViewModel: ObservableObject {

    let downloadQueue = OperationQueue()
    var dataController: DataController
    var networkHandler: NetworkHandler

    @Published var stocks = [SearchResult]()
    @Published var coreDataStocks = [Stock]()

    var predeterminedStocks: [String] = [
        "TSLA",
        "BCRX",
        "CRSR",
        "AAPL",
        "ELY",
        "GME"
    ]

    init(dataController: DataController) {
        self.dataController = dataController
        self.networkHandler = NetworkHandler(dataController: dataController)
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        let fetchedStocks = try! dataController.mainContext.fetch(fetchRequest)
        self.coreDataStocks = fetchedStocks
        if !UserDefaults.standard.bool(forKey: "didDownloadInitialData") {
            networkHandler.fetchStocks(stocks: predeterminedStocks)
        }
    }
}
