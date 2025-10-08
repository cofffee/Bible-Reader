//
//  BooksView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct BooksView: View {
    @ObservedObject var bibleViewModel: BibleViewModel
    var body: some View {
        content
    }
    @ViewBuilder
    private var content: some View {
        scrollview
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                versetoolbar
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                searchablebooktoolbar
            }
        }
        .toolbarTitleMenu {
            ForEach(BibleVersion.allCases) { version in
                Button(version.title) {
                    Task {
                        await bibleViewModel.fetchBooks(version: version)
                    }
                }
            }
        }
    }
    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            if bibleViewModel.isLoading {
                ProgressView()
            } else {
                LazyVStack(alignment: .trailing) {
                    ForEach(bibleViewModel.bible.books, id: \.self) { book in
                        NavigationLink(value: book) {
                            Text(book.name)
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 12)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.trailing, 4)
        .padding(.leading, 12)
        .navigationTitle(bibleViewModel.bible.version.title)
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
    private var versetoolbar: some View {
        NavigationLink {
            VersesStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        } label: {
            Image(systemName: "book.pages")
        }
    }
    @ViewBuilder
    private var searchablebooktoolbar: some View {
        NavigationLink {
            SearchableBibleStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        } label: {
            Image(systemName: "book")
        }
    }
}

#Preview {
    BooksView(bibleViewModel: BibleViewModel())
}
