//
//  SearchRowView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import SwiftUI

struct SearchRowView: View {

    let result: SearchResult
    @EnvironmentObject var dataImporter: DataImporter
    @State private var selectedStock: SearchResult?

    var body: some View {
        HStack {
            Text(result.symbol)
                .font(.headline)
                .fontWeight(.semibold)

            Spacer()

            Text(result.name)
                .lineLimit(2)
                .frame(width: 140, height: 40, alignment: .trailing)

            Button(action: {
                selectedStock = result
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Color(.label))
            }
        }
        .alert(item: $selectedStock) { result in
            Alert(title: Text("Add \(result.name)?"), message: Text("Do you want to add \(result.name) to your stock list?"), primaryButton: .default(Text("Add"), action: {
                dataImporter.fetchStocks(stockSymbols: [result.symbol])
                dataImporter.fetchTimeSeries(for: result.symbol, withType: .intraday)
                dataImporter.fetchTimeSeries(for: result.symbol, withType: .daily)
                dataImporter.fetchTimeSeries(for: result.symbol, withType: .weekly)
                dataImporter.fetchTimeSeries(for: result.symbol, withType: .monthly)
            }), secondaryButton: .cancel())
        }
    }
}
