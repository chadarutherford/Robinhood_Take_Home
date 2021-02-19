//
//  SearchResult.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Foundation


/// Struct responsible for decoding Stocks the user has searched for.
struct SearchResult: Codable, Identifiable {
    var id: String {
        return symbol
    }

    let symbol: String
    let name: String

    enum SearchResultKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResultKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
    }
}

 /// Outer container responsible for decoding the array of Stock Symbols
struct SearchResults: Codable {
    let results: [SearchResult]

    enum SearchResultsKeys: String, CodingKey {
        case results = "bestMatches"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResultsKeys.self)
        results = try container.decode([SearchResult].self, forKey: .results)
    }
}
