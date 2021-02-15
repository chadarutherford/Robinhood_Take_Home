//
//  SearchViewModel.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/15/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var stockSymbol = "" {
        didSet {
            print("\(stockSymbol)")
        }
    }
}
