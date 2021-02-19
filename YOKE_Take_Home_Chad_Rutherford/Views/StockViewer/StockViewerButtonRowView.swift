//
//  StockViewerButtonRowView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/19/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import SwiftUI

struct StockViewerButtonRowView: View {

    @Binding var timeSeriesDisplayOption: TimeSeriesDisplayOption
    
    var body: some View {
        HStack {
            ForEach(0 ..< 5, id: \.self) { index in
                Spacer()
                Button(action: {
                    switch index {
                    case 0:
                        timeSeriesDisplayOption = .oneDay
                    case 1:
                        timeSeriesDisplayOption = .oneWeek
                    case 2:
                        timeSeriesDisplayOption = .oneMonth
                    case 3:
                        timeSeriesDisplayOption = .oneYear
                    case 4:
                        timeSeriesDisplayOption = .fiveYears
                    default:
                        break
                    }
                }, label: {
                    switch index {
                    case 0:
                        Text("1D")
                    case 1:
                        Text("1W")
                    case 2:
                        Text("1M")
                    case 3:
                        Text("1Y")
                    case 4:
                        Text("5Y")
                    default:
                        EmptyView()
                    }
                })
                .foregroundColor(Color(.label))
                .padding(8)
                .background(Color.red)
                .cornerRadius(8)
                Spacer()
            }
        }
    }
}

struct StockViewerButtonRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockViewerButtonRowView(timeSeriesDisplayOption: .constant(.oneDay))
    }
}
