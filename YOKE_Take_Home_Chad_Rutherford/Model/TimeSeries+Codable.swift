//
//  Intraday+Codable.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

class Intraday: NSManagedObject, Decodable {

    enum IntradayKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        let container = try decoder.container(keyedBy: IntradayKeys.self)
        guard let open = Double(try container.decode(String.self, forKey: .open)) else {
            throw DecodingError.dataCorruptedError(forKey: IntradayKeys.open, in: container, debugDescription: "Open should be converted to a Double")
        }
        guard let close = Double(try container.decode(String.self, forKey: .close)) else {
            throw DecodingError.dataCorruptedError(forKey: IntradayKeys.close, in: container, debugDescription: "Close should be converted to a Double")
        }
        self.open = open
        self.close = close
    }
}

class Daily: NSManagedObject, Decodable {
    enum DailyKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        let container = try decoder.container(keyedBy: DailyKeys.self)
        guard let open = Double(try container.decode(String.self, forKey: .open)) else {
            throw DecodingError.dataCorruptedError(forKey: DailyKeys.open, in: container, debugDescription: "Open should be converted to a Double")
        }
        guard let close = Double(try container.decode(String.self, forKey: .close)) else {
            throw DecodingError.dataCorruptedError(forKey: DailyKeys.close, in: container, debugDescription: "Close should be converted to a Double")
        }
        self.open = open
        self.close = close
    }
}

class Weekly: NSManagedObject, Decodable {
    enum WeeklyKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        let container = try decoder.container(keyedBy: WeeklyKeys.self)
        guard let open = Double(try container.decode(String.self, forKey: .open)) else {
            throw DecodingError.dataCorruptedError(forKey: WeeklyKeys.open, in: container, debugDescription: "Open should be converted to a Double")
        }
        guard let close = Double(try container.decode(String.self, forKey: .close)) else {
            throw DecodingError.dataCorruptedError(forKey: WeeklyKeys.close, in: container, debugDescription: "Close should be converted to a Double")
        }
        self.open = open
        self.close = close
    }
}

class Monthly: NSManagedObject, Decodable {
    enum MonthlyKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        let container = try decoder.container(keyedBy: MonthlyKeys.self)
        guard let open = Double(try container.decode(String.self, forKey: .open)) else {
            throw DecodingError.dataCorruptedError(forKey: MonthlyKeys.open, in: container, debugDescription: "Open should be converted to a Double")
        }
        guard let close = Double(try container.decode(String.self, forKey: .close)) else {
            throw DecodingError.dataCorruptedError(forKey: MonthlyKeys.close, in: container, debugDescription: "Close should be converted to a Double")
        }
        self.open = open
        self.close = close
    }
}
