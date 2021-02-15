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
    let values: [CGFloat] = [1,2,3,4,3,2,1,2,3,4]
    let segments = [0,4,8]
    var body: some View {
        RHInteractiveLinePlot(values: values, occupyingRelativeWidth: 0.8, showGlowingIndicator: true, lineSegmentStartingIndices: segments) { index in

        } customLatestValueIndicator: {

        } valueStickLabel: { value in

        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView()
    }
}
