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
    @ObservedObject var bibleViewModel: BibleViewModel = BibleViewModel()
    var body: some View {
        NavigationStack {
            BooksView(bibleViewModel: bibleViewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                //.environment(\.font, .custom(defaultFont ?? "SF Pro", size: 17))
        }
    }
}

#Preview {
    //SavedVersesView()
    MainContentView()
    
}


