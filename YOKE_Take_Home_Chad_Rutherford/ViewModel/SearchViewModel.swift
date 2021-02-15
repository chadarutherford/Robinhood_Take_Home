//
//  SearchViewModel.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/15/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CRNetworkingManager
import Foundation

class SearchViewModel: ObservableObject {

    @Published var results = [SearchResult]()
    @Published var stockSymbol = "" {
        didSet {
            if stockSymbol == "" {
                results.removeAll()
            } else {
                fetchStockSymbols()
            }
        }
    }

    var tasks = [URLSessionDataTask]()
    let networkManager = NetworkManager()

    func fetchStockSymbols() {
        guard let baseURL = URL(string: "https://www.alphavantage.co/")?.appendingPathComponent("query") else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "function", value: "SYMBOL_SEARCH")
        let keywordItem = URLQueryItem(name: "keywords", value: stockSymbol)
        let apiKey = URLQueryItem(name: "apikey", value: APIConstants.apiKey)
        components?.queryItems = [queryItem, keywordItem, apiKey]
        guard let url = components?.url else { return }

        networkManager.decodeObjects(using: url) { (result: Result<SearchResults, NetworkError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let stockSymbols):
                DispatchQueue.main.async {
                    self.results = stockSymbols.results
                }
            }
        }
    }
}
