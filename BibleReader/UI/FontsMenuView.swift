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
    @Environment(\.colorScheme) var colorScheme
    let fontsList: [String] = ["Baskerville",
                               "Bookerly",
                               "Caecilia", ///CaeciliaLTPro55Roman
                               "Georgia",
                               "Helvetica",
                               "OpenDyslexic",
                               "Palatino",
                               "SF Pro"
    ]
    static let PlusImage = Image(systemName: "plus")
    static let MinusImage = Image(systemName: "minus")

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
                FontMenuView.MinusImage
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
            .frame(width: 50, height: 50)
            Slider(value: $bodyFontSize, in: 8...30)
                .tint(colorScheme == .dark ? .white : .black)
            Button {
                bodyFontSize = min(max(bodyFontSize + 1.0, 1), 30)
            } label: {
                FontMenuView.PlusImage
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
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
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.custom(item, size: 10, relativeTo: .title))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

