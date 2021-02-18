//
//  Stock+Representation.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

protocol StockData {
    var stockSymbol: String { get }
    var stockName: String { get }
    var intradayValues: [Intraday] { get }
    var rowTickerValues: [Intraday] { get }
    var firstValue: Intraday { get }
    var isUp: Bool { get }
}
extension Stock: StockData {
    static var example: Stock {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext
        let stock = Stock(symbol: "GME", name: "GameStop", context: viewContext)
        return stock
    }

    var stockSymbol: String {
        return symbol ?? ""
    }

    var stockName: String {
        return name ?? ""
    }

    var intradayValues: [Intraday] {
        intraday?.allObjects as? [Intraday] ?? []
    }

    var rowTickerValues: [Intraday] {
        if !intradayValues.isEmpty {
            let sliceArray = (intraday?.allObjects as! [Intraday])[0 ..< 7]
            return Array(sliceArray)
        } else {
            return []
        }
    }

    var firstValue: Intraday {
        (intraday?.allObjects as? [Intraday])?.first ?? Intraday(open: 0.0, close: 0.0)
    }

    var isUp: Bool {
        guard intradayValues.count >= 2 else { return false }
        return intradayValues[0].close - intradayValues[1].close >= 0
    }
    
    @discardableResult convenience init(symbol: String, name: String, context: NSManagedObjectContext = DataController.shared.mainContext) {
        self.init(context: context)
        self.symbol = symbol
        self.name = name
    }

    @discardableResult convenience init?(searchResult: SearchResult, context: NSManagedObjectContext = DataController.shared.mainContext) {
        let symbol = searchResult.symbol
        let name = searchResult.name
        self.init(symbol: symbol, name: name, context: context)
    }
}
