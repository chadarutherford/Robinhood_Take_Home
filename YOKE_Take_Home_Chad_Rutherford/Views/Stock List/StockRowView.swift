//
//  StockRowView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import RHLinePlot
import SwiftUI

struct StockRowView: View {

    @State var stock: Stock
//    var values: [CGFloat] {
//        stockData.rowTickerValues.map { CGFloat($0.intraClose) }
//    }

    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(stock.stockSymbol)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(stock.stockName)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }

            Spacer()
//            if !stockData.rowTickerValues.isEmpty {
//                RHLinePlot(values: values)
//                    .frame(width: 80, height: 40, alignment: .center)
//            }
            Spacer()

//            if !stockData.intradayValues.isEmpty {
//                Text("$\(String(format: "%.2f", stockData.firstValue.intraClose))")
//                    .foregroundColor(Color(.systemBackground))
//                    .padding(.vertical, 9)
//                    .padding(.horizontal, 10)
//                    .background(stockData.isUp ? Color.green : Color.red)
//                    .cornerRadius(8)
//            }
        }
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(stock: Stock.example)
    }
}
