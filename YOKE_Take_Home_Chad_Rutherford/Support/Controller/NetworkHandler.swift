//
//  NetworkManager.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import CRNetworkingManager
import Foundation

class NetworkHandler {

    let networkManager = NetworkManager()
    let dataController: DataController

    init(dataController: DataController) {
        self.dataController = dataController
    }

    func fetchTimeSeries(for stock: StockData, with type: TimeSeriesType) {
        guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "function", value: type.function)
        let keywordItem = URLQueryItem(name: "symbol", value: stock.stockSymbol)
        let intervalItem = URLQueryItem(name: "interval", value: "5min")
        let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
        components?.queryItems = [queryItem, keywordItem, intervalItem, apiKey]
        guard let url = components?.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey(rawValue: "dateFormat")!] = type.dateFormat
            do {
                let results = try decoder.decode(TickerResults.self, from: data)
                DispatchQueue.main.async {
                    for entry in results.timeSeries {
                        let intradayResult = Intraday(open: entry.info.open, close: entry.info.close)
                        if let cdStock = stock as? Stock {
                            let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
                            fetchRequest.predicate = NSPredicate(format: "symbol == %@", cdStock.stockSymbol)
                            let stockToUpdate = try? DataController.shared.mainContext.fetch(fetchRequest)
                            intradayResult.stock = stockToUpdate?.first
                            do {
                                try DataController.shared.save()
                            } catch {
                                fatalError("Unable to save results")
                            }
                        }
                    }
                }

            } catch {
                print(error)
            }
        }
        .resume()
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
