//
//  SearchableBibleStackView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct SearchableBibleStackView: View {
    @ObservedObject var viewModel: BibleViewModel
    @State var isSearchShowing = false
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                lineCount
                ForEach(viewModel.isSearching ? viewModel.filteredBibleRawStringLines :  viewModel.bibleRawStringLines, id: \.self) { line in
                    Text(line)
                }
            }
            .padding(.trailing, 8)
            .padding(.leading, 8)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ToolbarButton.searchtoolbar(isSearching: $isSearchShowing)
            }
        }
        .searchable(text: $viewModel.searchText, isPresented: $isSearchShowing, placement: .automatic, prompt: Text("Search"))
    }

    @ViewBuilder
    private var lineCount: some View {
        if viewModel.isSearching {
            Text("\(viewModel.filteredBibleRawStringLines.count) results")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 8)
        }
    }
}

#Preview {
    SearchableBibleStackView(viewModel: BibleViewModel())
}
