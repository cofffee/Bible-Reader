//
//  ToolbarItems.swift
//  BibleReader
//
//  Created by Kevin Remigio on 9/24/26.
//

import SwiftUI

struct ToolbarButton {

    @ViewBuilder
    static var savedversestoolbar: some View {
        NavigationLink { SavedVersesView() } label: {
            Image(systemName: "list.star")
        }
    }

    @ViewBuilder
    static func textformattoolbar(showSheet: Binding<Bool>) -> some View {
        Button { showSheet.wrappedValue.toggle() } label: {
           Image(systemName: "textformat.alt")
       }
        .sheet(isPresented: showSheet) {
           FontMenuView()
               .presentationDetents([.height(180)])
       }
    }

    @ViewBuilder
    static func darkmodetoolbar(isDarkMode: Binding<Bool>) -> some View {
        Button { isDarkMode.wrappedValue.toggle() } label: {
            Image(systemName: isDarkMode.wrappedValue ? "sun.max" : "moon" )
        }
    }

    @ViewBuilder
    static func versetoolbar(bibleLines: [String]) -> some View {
        NavigationLink {
            VersesStackView(bibleLines: bibleLines)
        } label: {
            Image(systemName: "book.pages")
        }
    }

    @ViewBuilder
    static func searchablebooktoolbar(viewModel: BibleViewModel) -> some View {
        NavigationLink {
            SearchableBibleStackView(viewModel: viewModel)
        } label: {
            Image(systemName: "book")
        }
    }

    @ViewBuilder
    static func searchtoolbar(isSearching: Binding<Bool>) -> some View {
        Button { isSearching.wrappedValue.toggle() } label : { Image(systemName: "magnifyingglass") }

    }
}
