//
//  SearchViewModel.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/15/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()

    // The results of the search
    @Published var results = [SearchResult]()

    // The text the user entered in the search bar
    @Published var stockSymbol = "" {
        didSet {
            if stockSymbol == "" {
                results.removeAll()
            } else {
                fetchStockSymbols()
            }
        }
    }

    /// The fetch for the stock the user searched for
    func fetchStockSymbols() {
        guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "function", value: "SYMBOL_SEARCH")
        let keywordItem = URLQueryItem(name: "keywords", value: stockSymbol)
        let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
        components?.queryItems = [queryItem, keywordItem, apiKey]
        guard let url = components?.url else { return }

        let decoder = JSONDecoder()

        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: SearchResults.self, decoder: decoder)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Something went wrong: \(error)")
                }
            } receiveValue: { [weak self] results in
                guard let self = self else { return }
                self.results = results.results
            }
            .store(in: &cancellables)
    }
}
