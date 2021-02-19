//
//  Stock+Codable.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/18/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

/// The error we throw is we forget to inject the context into the Decoder.
enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}


/// The outer container for the stocks fetched for CoreData
struct StockResults: Decodable {
    let results: [Stock]
    
    enum StockResultsKeys: String, CodingKey {
        case results = "bestMatches"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StockResultsKeys.self)
        results = try container.decode([Stock].self, forKey: .results)
    }
}


/// The class responsible for fetching and saving Stock data to CoreData
class Stock: NSManagedObject, Decodable {

    enum StockKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: StockKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.symbol = try container.decode(String.self, forKey: .symbol)
    }
}

/// The managed object context gets passed into the NSManagedObject Decodable class with this key
extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension Stock {

    // MARK: - Computed Properties for ease of use with CoreData and optionals
    var stockSymbol: String {
        symbol ?? ""
    }
    
    var stockName: String {
        name ?? ""
    }

    var firstValue: Intraday? {
        intradayValues.first
    }

    var intradayValues: [Intraday] {
        intraday?.allObjects as? [Intraday] ?? []
    }

    var rowTickerValues: [Intraday] {
        if !intradayValues.isEmpty {
            let sliceArray = intradayValues[0 ..< 24]
            return Array(sliceArray)
        } else {
            return []
        }
    }

    var weeklyValues: [Daily] {
        let dailyValues = daily?.allObjects as? [Daily] ?? []
        if !dailyValues.isEmpty {
            let sliceArray = dailyValues[0 ..< 7]
            return Array(sliceArray)
        } else {
            return []
        }
    }

    var monthlyValues: [Weekly] {
        let weeklyValues = weekly?.allObjects as? [Weekly] ?? []
        if !weeklyValues.isEmpty {
            let sliceArray = weeklyValues[0 ..< 4]
            return Array(sliceArray)
        } else {
            return []
        }
    }

    var oneYearValues: [Monthly] {
        let monthlyValues = monthly?.allObjects as? [Monthly] ?? []
        if !monthlyValues.isEmpty {
            let sliceArray = monthlyValues[0 ..< 12]
            return Array(sliceArray)
        } else {
            return []
        }
    }

    var fiveYearValues: [Monthly] {
        let monthlyValues = monthly?.allObjects as? [Monthly] ?? []
        if !monthlyValues.isEmpty {
            let sliceArray = monthlyValues[0 ..< 60]
            return Array(sliceArray)
        } else {
            return []
        }
    }

    var isUp: Bool {
        guard intradayValues.count >= 2 else { return false }
        return intradayValues[0].close - intradayValues[1].close >= 0
    }

    static var example: Stock {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        let stock = Stock(context: viewContext)
        stock.symbol = "GME"
        stock.name = "GameStop"
        try? viewContext.save()
        return stock
    }
}
