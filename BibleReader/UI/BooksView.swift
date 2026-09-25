//
//  BooksView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct BooksView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State var showSheet: Bool = false
    @ObservedObject var bibleViewModel: BibleViewModel
    var body: some View {
        content
    }
    @ViewBuilder
    private var content: some View {
        scrollview
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                ToolbarButton.savedversestoolbar
                ToolbarButton.darkmodetoolbar(isDarkMode: $isDarkMode)
            }
            ToolbarItem(placement: .principal) {
                Text("The Bible")
                    .titleStyle()
                    .navigationBarTitleDisplayMode(.inline)
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                ToolbarButton.textformattoolbar(showSheet: $showSheet)
                ToolbarButton.versetoolbar(bibleLines: bibleViewModel.bibleRawStringLines)
                ToolbarButton.searchablebooktoolbar(bibleLines: bibleViewModel.bibleRawStringLines)
            }
        }
        .toolbarTitleMenu {
            bibleVersionsList
        }
    }
    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            if bibleViewModel.isLoading {
                ProgressView()
            } else {
                HStack(alignment: .top) {
                    oldTestamentRows
                    newTestamentRows
                }
            }
        }
        .scrollIndicators(.hidden)
//        .navigationTitle(bibleViewModel.bible.version.title)
        .navigationTitle("The Bible")
        .navigationDestination(for: BookModel.self) { book in
            ChaptersView(book: book)
        }
        .navigationDestination(for: String.self) { value in
            VersesStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        }
        .navigationDestination(for: ChapterModel.self) { chapter in
            VerseView(chapter: chapter)
        }
    }

    @ViewBuilder
    private var oldTestamentRows: some View {
        let count = bibleViewModel.bible.version.oldTestamentCount
        LazyVStack(alignment: .trailing) {
            ForEach(bibleViewModel.bible.books.prefix(count), id: \.self) { book in
                NavigationLink(value: book) {
                    Text(book.name)
                        .bodyStyle()
                }
                .padding(.vertical, 2)
                .padding(.trailing, 12)
            }
        }
    }
    @ViewBuilder
    private var newTestamentRows: some View {
        let count = bibleViewModel.bible.version.newTestamentCount
        LazyVStack(alignment: .leading) {
            ForEach(bibleViewModel.bible.books.suffix(count), id: \.self) { book in
                NavigationLink(value: book) {
                    Text(book.name)
                        .bodyStyle()
                }
                .padding(.vertical, 2)
                .padding(.trailing, 12)
            }
        }
    }

    @ViewBuilder
    private var bibleVersionsList: some View {
        ForEach(BibleVersion.allCases) { version in
            Button(version.title) {
                Task {
                    await bibleViewModel.fetchBooks(version: version)
                }
            }
        }
    }
}
#Preview {
    //BooksView(bibleViewModel: BibleViewModel())
    //SubscriptionScreen(show: true)
    //SubscriptionScreenView()
    FontMenuView()
}
