//
//  FontsMenuView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 9/24/26.
//

import SwiftUI

struct FontMenuView: View {
    @AppStorage("Font") var defaultfont: String = "Georgia"
    let fontsList: [String] = ["Baskerville",
                               "Bookerly",
                               "Caecilia", ///CaeciliaLTPro55Roman
                               "Georgia",
                               "Helvetica",
                               "OpenDyslexic",
                               "Palatino",
                               "SF Pro"
    ]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(fontsList, id: \.self) { item in
                    Button {
                        defaultfont = item
                    } label: {
                        ZStack {
                            VStack {
                                Text("Aa")
                                    .font(.custom(item, size: 30, relativeTo: .title))
                                Text(item)
                            }
                            .foregroundStyle(Color.black)
                            .font(.custom(item, size: 10, relativeTo: .title))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

