//
//  NetworkManager.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Combine
import CoreData
import Foundation

enum TimeSeriesType {
    case intraday
    case daily
    case weekly
    case monthly

    var function: String {
        switch self {
        case .intraday:
            return "TIME_SERIES_INTRADAY"
        case .daily:
            return "TIME_SERIES_DAILY"
        case .weekly:
            return "TIME_SERIES_WEEKLY"
        case .monthly:
            return "TIME_SERIES_MONTHLY"
        }
    }

    var dateFormat: String {
        switch self {
        case .intraday:
            return "yyyy-MM-dd HH:mm:ss"
        case .daily, .weekly, .monthly:
            return "yyyy-MM-dd"
        }
    }
}

class DataImporter {
    let importContext: NSManagedObjectContext
    var cancellables = Set<AnyCancellable>()

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = importContext
        return decoder
    }()

    init(persistentContainer: NSPersistentContainer) {
        importContext = persistentContainer.newBackgroundContext()
        importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func fetchStocks(stockSymbols: [String]) {
        for stock in stockSymbols {
            guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            let queryItem = URLQueryItem(name: "function", value: "SYMBOL_SEARCH")
            let keywordItem = URLQueryItem(name: "keywords", value: stock)
            let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
            components?.queryItems = [queryItem, keywordItem, apiKey]
            guard let url = components?.url else { return }

            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Something went wrong: \(error)")
                    }
                } receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    self.importContext.perform {
                        do {
                            let results = try self.decoder.decode(StockResults.self, from: data)
                            let _ = results.results.first
                            do {
                                try self.importContext.save()
                            } catch {
                                print("Someting went wrong: \(error)")
                            }
                        } catch {
                            print("Failed to decode JSON: \(error)")
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }

    //    func fetchTimeSeries(for stock: Stock, with type: TimeSeriesType) {
    //        guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
    //        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    //        let queryItem = URLQueryItem(name: "function", value: type.function)
    //        let keywordItem = URLQueryItem(name: "symbol", value: stock.symbol)
    //        let intervalItem = URLQueryItem(name: "interval", value: "5min")
    //        let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
    //        components?.queryItems = [queryItem, keywordItem, intervalItem, apiKey]
    //        guard let url = components?.url else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, _ in
    //            guard let data = data else { return }
    //            let decoder = JSONDecoder()
    //            decoder.userInfo[CodingUserInfoKey(rawValue: "dateFormat")!] = type.dateFormat
    //            do {
    //                let results = try decoder.decode(TickerResults.self, from: data)
    //                DispatchQueue.main.async {
    //                    for entry in results.timeSeries {
    //                        switch type {
    //                        case .intraday:
    //                            self.saveToCoreData(stock: stock, entry: entry, type: .intraday)
    //                        case .daily:
    //                            self.saveToCoreData(stock: stock, entry: entry, type: .daily)
    //                        case .weekly:
    //                            self.saveToCoreData(stock: stock, entry: entry, type: .weekly)
    //                        case .monthly:
    //                            self.saveToCoreData(stock: stock, entry: entry, type: .monthly)
    //                        }
    //                    }
    //                }
    //
    //            } catch {
    //                print(error)
    //            }
    //        }
    //        .resume()
    //    }

    //    func saveToCoreData(stock: StockData, entry: (time: Date, info: TimeEntry), type: TimeSeriesType) {
    //        switch type {
    //        case .intraday:
    //            let intradayResult = Intraday(open: entry.info.open, close: entry.info.close)
    //            if let cdStock = stock as? Stock {
    //                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
    //                fetchRequest.predicate = NSPredicate(format: "symbol == %@", cdStock.stockSymbol)
    //                let stockToUpdate = try? DataController.shared.mainContext.fetch(fetchRequest)
    //                intradayResult.stock = stockToUpdate?.first
    //                do {
    //                    try DataController.shared.save()
    //                } catch {
    //                    fatalError("Unable to save results")
    //                }
    //            }
    //        case .daily:
    //            let dailyResult = Daily(open: entry.info.open, close: entry.info.close)
    //            if let cdStock = stock as? Stock {
    //                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
    //                fetchRequest.predicate = NSPredicate(format: "symbol == %@", cdStock.stockSymbol)
    //                let stockToUpdate = try? DataController.shared.mainContext.fetch(fetchRequest)
    //                dailyResult.stock = stockToUpdate?.first
    //                do {
    //                    try DataController.shared.save()
    //                } catch {
    //                    fatalError("Unable to save results")
    //                }
    //            }
    //        case .weekly:
    //            let weeklyResult = Weekly(open: entry.info.open, close: entry.info.close)
    //            if let cdStock = stock as? Stock {
    //                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
    //                fetchRequest.predicate = NSPredicate(format: "symbol == %@", cdStock.stockSymbol)
    //                let stockToUpdate = try? DataController.shared.mainContext.fetch(fetchRequest)
    //                weeklyResult.stock = stockToUpdate?.first
    //                do {
    //                    try DataController.shared.save()
    //                } catch {
    //                    fatalError("Unable to save results")
    //                }
    //            }
    //        case .monthly:
    //            let monthlyResult = Monthly(open: entry.info.open, close: entry.info.close)
    //            if let cdStock = stock as? Stock {
    //                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
    //                fetchRequest.predicate = NSPredicate(format: "symbol == %@", cdStock.stockSymbol)
    //                let stockToUpdate = try? DataController.shared.mainContext.fetch(fetchRequest)
    //                monthlyResult.stock = stockToUpdate?.first
    //                do {
    //                    try DataController.shared.save()
    //                } catch {
    //                    fatalError("Unable to save results")
    //                }
    //            }
    //        }
    //    }
}
