//
//  FontsMenuView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 9/24/26.
//

import SwiftUI

struct FontMenuView: View {
    @AppStorage("BodyFontSize") var bodyFontSize: Double = 17
    @AppStorage("Font") var defaultFont: String = "Georgia"
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
        VStack {
            fontListView
            fontSizeSlider
        }
        .padding(.top, 12)
        .padding(.trailing, 12)
        .padding(.leading, 12)
    }
    var fontSizeSlider: some View {
        HStack {
            Button {
                bodyFontSize = bodyFontSize - 1.0
            } label: {
                Image(systemName: "minus")
            }
            .frame(width: 50, height: 50)
            Slider(value: $bodyFontSize, in: 8...30)
            Button {
                bodyFontSize = min(max(bodyFontSize + 1.0, 1), 30)
            } label: {
                Image(systemName: "plus")
            }
            .frame(width: 50, height: 50)
        }
        
    }

    var fontListView: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(fontsList, id: \.self) { item in
                    Button {
                        defaultFont = item
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

