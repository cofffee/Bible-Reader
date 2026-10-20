//
//  ContentView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/21/25.
//

import SwiftUI

struct MainContentView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("Font") var defaultFont: String?
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: BibleViewModel
    var body: some View {
        NavigationStack {
            BooksView(bibleViewModel: viewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            //.environment(\.font, .custom(defaultFont ?? "SF Pro", size: 17))
        }
        .task {
            await viewModel.fetchBooks()
        }
    }
}

#Preview {
    //SavedVersesView()
    MainContentView(viewModel: BibleViewModel())
    
}


