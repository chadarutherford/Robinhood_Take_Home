//
//  StockViewerView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/15/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import RHLinePlot
import SwiftUI

struct StockViewerView: View {

    let stock: Stock
    var values: [CGFloat] {
        stock.rowTickerValues.map { CGFloat($0.close) }
    }

    var segments: [Int] {
        Array(0 ..< values.count)
    }
    var body: some View {
        VStack(alignment: .leading) {
            StockViewerHeader(stock: stock)
            
            RHInteractiveLinePlot(values: values, occupyingRelativeWidth: 0.9, showGlowingIndicator: true, lineSegmentStartingIndices: segments) { index in

            } customLatestValueIndicator: {
                AnyView(GlowingIndicator())
            } valueStickLabel: { value in
                valueStickLabel(value)
            }
            .foregroundColor(stock.isUp ? Color.green : Color.red)
        }
        .padding(.horizontal, 10)
    }

    func valueStickLabel(_ value: CGFloat) -> some View {
        let valueString = String(format: "%.2f", value)
        return Text("$\(valueString)").padding(2)
    }
}

struct StockViewerView_Previews: PreviewProvider {
    static var previews: some View {
        StockViewerView(stock: Stock.example)
    }
}
