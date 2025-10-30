//
//  SearchableBibleStackView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct SearchableBibleStackView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    var bibleLines: [String]

    var body: some View {
        if searchIsActive {
            content
                .searchable(
                    text: $searchText,
                    isPresented: $searchIsActive)
        } else { content }
    }

    @ViewBuilder
    private var content: some View {
        scrollview
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                searchtoolbar
            }
        }
    }

    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                if searchIsActive {
                    Text("\(searchResults.count) results")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 8)
                }
                
                ForEach(searchResults, id: \.self) { line in
                    Text(line)
                        .padding(.vertical, 2)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.trailing, 8)
        .padding(.leading, 8)
//        .navigationTitle("The Bible")
//        .navigationDestination(for: String.self) { value in
//            VersesStackView(bibleLines: bibleLines)
//        }
    }

    @ViewBuilder
    private var searchtoolbar: some View {
        Button(action: {
            withAnimation(.linear) {
                searchIsActive.toggle()
            }
        }) {
            Image(systemName: "magnifyingglass")
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return bibleLines
        } else {
            //return bibleLines.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
            return bibleLines.filter { $0.contains(searchText) }
        }
    }
}

#Preview {
    SearchableBibleStackView(bibleLines: [])
}
