//
//  SearchView.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/11/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isEditing = false

    var body: some View {
        VStack {
            HStack {
                SearchBar(placeholder: "Search ...", text: $searchText)
                    .onTapGesture {
                        self.isEditing = true
                    }

                if isEditing {
                    Button(action: {
                        UIApplication.shared.endEditing(true)
                        self.isEditing = false
                        self.searchText = ""
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.horizontal, 10)

            List {
                ForEach(0 ... 8, id: \.self) { number in
                    Text("Hello")
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
