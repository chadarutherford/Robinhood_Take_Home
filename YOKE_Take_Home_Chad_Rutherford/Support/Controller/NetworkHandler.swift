//
//  NetworkManager.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CRNetworkingManager
import Foundation

class NetworkHandler {

    let networkManager = NetworkManager()
    let dataController: DataController

    init(dataController: DataController) {
        self.dataController = dataController
    }

    func fetchStocks(stockSymbols: [String], completion: @escaping ([StockData]) -> Void) {
        var stockData = [StockData]()
        for stock in stockSymbols {
            guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            let queryItem = URLQueryItem(name: "function", value: "SYMBOL_SEARCH")
            let keywordItem = URLQueryItem(name: "keywords", value: stock)
            let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
            components?.queryItems = [queryItem, keywordItem, apiKey]
            guard let url = components?.url else { return }
            
            networkManager.decodeObjects(using: url) { (result: Result<SearchResults, NetworkError>) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let results):
                    guard let result = results.results.first else { return }
                    let stock = Stock(symbol: result.symbol, name: result.name)
                    stockData.append(stock)
                    completion(stockData)
                    do {
                        try self.dataController.save()
                    } catch {
                        fatalError("Unable to save")
                    }
                    UserDefaults.standard.set(true, forKey: "didDownloadInitialData")
                }
            }
        }
    }
}
