//
//  Stock+Codable.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/18/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

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

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension Stock {

    var stockSymbol: String {
        symbol ?? ""
    }
    
    var stockName: String {
        name ?? ""
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
