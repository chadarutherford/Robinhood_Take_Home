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

    let stock: Stock
    var values: [CGFloat] {
        stock.rowTickerValues.map { CGFloat($0.close) }
    }

    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(stock.stockSymbol)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(stock.stockName)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .leading)
                    .lineLimit(1)
            }

            Spacer()
            if !stock.rowTickerValues.isEmpty {
                RHLinePlot(values: values)
                    .frame(width: 80, height: 40, alignment: .center)
                    .foregroundColor(stock.isUp ? Color.green : Color.red)
            }
            Spacer()

            if !stock.intradayValues.isEmpty, let firstValue = stock.firstValue {
                Text("$\(String(format: "%.2f", firstValue.close))")
                    .foregroundColor(Color(.systemBackground))
                    .padding(.vertical, 9)
                    .padding(.horizontal, 10)
                    .background(stock.isUp ? Color.green : Color.red)
                    .cornerRadius(8)
            }
        }
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(stock: Stock.example)
    }
}
