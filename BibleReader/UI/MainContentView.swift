//
//  ContentView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/21/25.
//

import SwiftUI



struct MainContentView: View {
    @ObservedObject var bibleViewModel: BibleViewModel = BibleViewModel()
    var body: some View {
        NavigationStack {
            BooksView(bibleViewModel: bibleViewModel)
        }
    }
}

#Preview {
    MainContentView()
}

