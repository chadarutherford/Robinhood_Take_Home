//
//  StockViewerHeader.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import SwiftUI

struct StockViewerHeader: View {
    let stock: Stock

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.stockSymbol)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                Text(stock.stockName)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)

                HStack {
                    Text("$\(String(format: "%.2f", stock.firstValue?.close ?? 0.0))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right.circle")
                }
            }
            Spacer()
        }
    }
}

struct StockViewerHeader_Previews: PreviewProvider {
    static var previews: some View {
        StockViewerHeader(stock: Stock.example)
    }
}
