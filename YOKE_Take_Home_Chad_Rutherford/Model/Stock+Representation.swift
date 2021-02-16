//
//  Stock+Representation.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

extension Stock {

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
