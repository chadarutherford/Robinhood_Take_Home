//
//  StockTickerResults.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Foundation

struct TickerResults: Decodable {
    let timeSeries: [(time: Date, info: TimeEntry)]

    private struct DecoderKey: CodingKey {
        var intValue: Int?
        var stringValue: String
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: DecoderKey.self)
        print(rootContainer.allKeys)
        let timeKey = rootContainer.allKeys
            .first(where: { (key: DecoderKey) -> Bool in
                key.stringValue.contains("Time Series")
            })
        guard let key = timeKey else {
            fatalError("Expected time series key in API. All keys = \(rootContainer.allKeys)")
        }

        let container = try rootContainer.nestedContainer(keyedBy: DecoderKey.self, forKey: key)
        var entries = [(time: Date, info: TimeEntry)]()

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")

        let dateFormat = decoder.userInfo[CodingUserInfoKey(rawValue: "dateFormat")!] as! String
        dateFormatter.dateFormat = dateFormat
        for key in container.allKeys {
            let entry = try container.decode(TimeEntry.self, forKey: key)
            let keyString = key.stringValue
            entries.append((dateFormatter.date(from: keyString)!, entry))
        }
        self.timeSeries = entries.sorted(by: { $0.time < $1.time })
    }
}

struct TimeEntry: Codable {
    let open: Double
    let close: Double

    enum TimeEntryKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TimeEntryKeys.self)
        guard let open = Double(try container.decode(String.self, forKey: .open)) else {
            throw DecodingError.dataCorruptedError(forKey: TimeEntryKeys.open, in: container, debugDescription: "Open should be converted to a Double")
        }
        guard let close = Double(try container.decode(String.self, forKey: .close)) else {
            throw DecodingError.dataCorruptedError(forKey: TimeEntryKeys.close, in: container, debugDescription: "Close should be converted to a Double")
        }
        self.open = open
        self.close = close
    }
}

enum TimeSeriesType {
    case intraday

    var dateFormat: String {
        switch self {
        case .intraday:
            return "yyyy-MM-dd HH:mm:ss"
        }
    }

    var function: String {
        switch self {
        case .intraday:
            return "TIME_SERIES_INTRADAY"
        }
    }
}
