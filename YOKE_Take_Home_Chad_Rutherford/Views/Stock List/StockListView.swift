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
//    let segments = [0,4,8]
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ... 8, id: \.self) { number in
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("VIAC")
                                        .font(.body)
                                        .fontWeight(.semibold)

                                    Text("Viacom CBS")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                                RHLinePlot(values: values)
                                    .frame(width: 80, height: 40, alignment: .center)
                                Spacer()

                                Text("$56.89")
                                    .foregroundColor(Color(.systemBackground))
                                    .padding(.vertical, 9)
                                    .padding(.horizontal, 10)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
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
