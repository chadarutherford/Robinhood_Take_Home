//
//  StockTickerResults.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Foundation

struct TickerResults<T>: Decodable where T: Decodable {
    let timeSeries: [(time: Date, info: T)]

    private struct DecoderKey: CodingKey {
        var intValue: Int?
        var stringValue: String
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: DecoderKey.self)
        let timeKey = rootContainer.allKeys
            .first(where: { (key: DecoderKey) -> Bool in
                key.stringValue.contains("Time Series")
            })
        guard let key = timeKey else {
            fatalError("Expected time series key in API. All keys = \(rootContainer.allKeys)")
        }

        let container = try rootContainer.nestedContainer(keyedBy: DecoderKey.self, forKey: key)
        var entries = [(time: Date, info: T)]()

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")

        let dateFormat = decoder.userInfo[CodingUserInfoKey(rawValue: "dateFormat")!] as! String
        dateFormatter.dateFormat = dateFormat
        for key in container.allKeys {
            let entry = try container.decode(T.self, forKey: key)
            let keyString = key.stringValue
            entries.append((dateFormatter.date(from: keyString)!, entry))
        }
        self.timeSeries = entries.sorted(by: { $0.time < $1.time })
    }
}
