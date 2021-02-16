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

    @Published var stockData = [StockData]()

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
        if !UserDefaults.standard.bool(forKey: "didDownloadInitialData") {
            networkHandler.fetchStocks(stockSymbols: predeterminedStocks) { stockData in
                self.stockData = stockData
            }
        } else {
            performFetch()
        }
    }

    func performFetch() {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        let fetchedStocks = try! dataController.mainContext.fetch(fetchRequest)
        self.stockData = fetchedStocks
    }
}
