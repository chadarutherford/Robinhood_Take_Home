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

class DataImporter: ObservableObject {
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
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Something went wrong: \(error)")
                    }
                } receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    self.importContext.performAndWait {
                        do {
                            let results = try self.decoder.decode(StockResults.self, from: data)
                            let stock = results.results.first
                            for result in results.results {
                                if result.symbol != stock?.symbol {
                                    self.importContext.delete(result)
                                }
                            }
                        } catch {
                            print("Failed to decode JSON: \(error)")
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }

    func fetchTimeSeries(for stock: String, withType type: TimeSeriesType) {
        guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "function", value: type.function)
        let keywordItem = URLQueryItem(name: "symbol", value: stock)
        let intervalItem = URLQueryItem(name: "interval", value: "5min")
        let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
        components?.queryItems = [queryItem, keywordItem, intervalItem, apiKey]
        guard let url = components?.url else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Something went wrong: \(error)")
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.decoder.userInfo[CodingUserInfoKey(rawValue: "dateFormat")!] = type.dateFormat
                self.importContext.performAndWait {
                    do {
                        switch type {
                        case .intraday:
                            let results = try self.decoder.decode(TickerResults<Intraday>.self, from: data).timeSeries
                            for entry in results {
                                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "symbol == %@", stock)
                                let stockToUpdate = try? self.importContext.fetch(fetchRequest)
                                entry.info.stock = stockToUpdate?.first
                            }
                        case .daily:
                            let results = try self.decoder.decode(TickerResults<Daily>.self, from: data).timeSeries
                            for entry in results {
                                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "symbol == %@", stock)
                                let stockToUpdate = try? self.importContext.fetch(fetchRequest)
                                entry.info.stock = stockToUpdate?.first
                            }
                        case .weekly:
                            let results = try self.decoder.decode(TickerResults<Weekly>.self, from: data).timeSeries
                            for entry in results {
                                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "symbol == %@", stock)
                                let stockToUpdate = try? self.importContext.fetch(fetchRequest)
                                entry.info.stock = stockToUpdate?.first
                            }
                        case .monthly:
                            let results = try self.decoder.decode(TickerResults<Monthly>.self, from: data).timeSeries
                            for entry in results {
                                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "symbol == %@", stock)
                                let stockToUpdate = try? self.importContext.fetch(fetchRequest)
                                entry.info.stock = stockToUpdate?.first
                            }
                        }
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

//        URLSession.shared.dataTask(with: url) { data, response, _ in
//            guard let data = data else { return }
//            let decoder = JSONDecoder()
//            decoder.userInfo[CodingUserInfoKey(rawValue: "dateFormat")!] = type.dateFormat
//            do {
//                var results: TickerResults
//                switch type {
//                case .intraday:
//                    let results = try decoder.decode(TickerResults<Intraday>.self, from: data)
//                default:
//                    break
//                }
//            } catch {
//                print(error)
//            }
//        }
//        .resume()
    }

}
