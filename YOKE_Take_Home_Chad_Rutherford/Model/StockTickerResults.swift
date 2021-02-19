//
//  StockTickerResults.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Foundation

// Main object responsible for decoding Time Series Values.
struct TickerResults<T>: Decodable where T: Decodable {
    let timeSeries: [(time: Date, info: T)]

    private struct DecoderKey: CodingKey {
        var intValue: Int?
        var stringValue: String
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }
    }

    init(from decoder: Decoder) throws {
        // Check the root container for a key containing the words "Time Series",
        // If the key is not present, an error occurred.
        let rootContainer = try decoder.container(keyedBy: DecoderKey.self)
        let timeKey = rootContainer.allKeys
            .first(where: { (key: DecoderKey) -> Bool in
                key.stringValue.contains("Time Series")
            })
        guard let key = timeKey else {
            fatalError("Expected time series key in API. All keys = \(rootContainer.allKeys)")
        }

        // Set up the container to decode a tuple of timestamped values. The time stamp being tuple value 1
        // And the Time Series class being the value we are concerned with.
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
