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
//                premiumsubscriptiontoolbar
                savedversestoolbar
                darkmodetoolbar
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                versetoolbar
                searchablebooktoolbar
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
                }
                .padding(.vertical, 2)
                .padding(.trailing, 12)
            }
        }
    }
    @ViewBuilder
    private var premiumsubscriptiontoolbar: some View {
        Button(action: {
            showSheet.toggle()
       }) {
           Image(systemName: "crown")
       }
        /* Full Screen Cover
       .fullScreenCover(isPresented: $showSheet) {
           SubscriptionScreen()
       }
         */
        ///*Sheet
       .sheet(isPresented: $showSheet) {
           //SubscriptionScreenView(show: $showSheet)
//           SubscriptionScreenView()
           /* SettingsView() */
           SavedVersesView()
       }

//        ZStack {
//            if showSheet {
//                SubscriptionScreen()//show: $showSheet)
//                    .padding(.top, 100)
//                    .transition(.move(edge: .bottom))
//                    .animation(.spring())
//            }
//        }
//        .zIndex(2.0)
//        SubscriptionScreenView()//show: $showSheet)
//            .padding(.top, 100)
//            .offset(y: showSheet ? 0 : UIScreen.main.bounds.height)
//            .animation(.spring())
        
//        if showSheet {
//            VersesStackView(bibleLines: bibleViewModel.bibleRawStringLines)
//                .transition(.move(edge: .bottom))
//                .animation(.spring(), value: UUID())
//
//            SubscriptionScreenView()
//                .transition(.move(edge: .bottom))
//                .animation(.spring(), value: UUID())
//        }
    }

    @ViewBuilder
    private var darkmodetoolbar: some View {
        Button(action: {
            isDarkMode.toggle()
       }) {
           Image(systemName: "moon")
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
    @ViewBuilder
    private var savedversestoolbar: some View {
        NavigationLink {
            SavedVersesView()
        } label: {
            Image(systemName: "list.star")
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
    BooksView(bibleViewModel: BibleViewModel())
    //SubscriptionScreen(show: true)
    //SubscriptionScreenView()
}
