//
//  StockListView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/11/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import RHLinePlot
import SwiftUI

struct StockListView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var stocksViewModel: StocksViewModel
    let values: [CGFloat] = [1,2,3,4,3,2,1,2,3,4]

    init(dataController: DataController) {
        let stocksViewModel = StocksViewModel(dataController: dataController)
        self._stocksViewModel = ObservedObject(wrappedValue: stocksViewModel)
    }

//    let segments = [0,4,8]
    var body: some View {
        NavigationView {
            List {
                ForEach(stocksViewModel.stockData, id:\.stockSymbol) { (stock: StockData) in
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            StockRowView(stockData: stock)
                        })

                }
            }
            .navigationTitle("Stocks")
        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView(dataController: DataController.preview)
    }
}
