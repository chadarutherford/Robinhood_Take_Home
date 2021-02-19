//
//  StockListView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/11/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import RHLinePlot
import SwiftUI

struct StockListView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Stock.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Stock.symbol, ascending: true)])
    var stocks: FetchedResults<Stock>

    var body: some View {
        NavigationView {
            List {
                ForEach(stocks) { stock in
                    NavigationLink(
                        destination: StockViewerView(stock: stock),
                        label: {
                            StockRowView(stock: stock)
                        })
                }
            }
            .navigationTitle("Stocks")
        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView()
    }
}
