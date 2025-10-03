//
//  ContentView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/21/25.
//

import SwiftUI



struct ContentView: View {
    @State var selectedTab = 0
    @ObservedObject var bibleViewModel: BibleViewModel = BibleViewModel()

    var body: some View {
        //SearchableBibleStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        /*
        TabView(selection: $selectedTab) {
            NavigationStack {
                SearchableBibleStackView(bibleLines: bibleViewModel.bibleRawStringLines,
                                         books: bibleViewModel.bible.books)
            }
            .tabItem({
                Image(systemName: "book")
                Text("Book")
            })
            .tag(0)

            VStack {
                BooksView(books: bibleViewModel.bible.books)
            }
            .tabItem({
                Image(systemName: "book.pages")
                Text("Verses")
            })
            .safeAreaPadding(.bottom)
            .tag(1)

            VStack {
                Text("Under Construction")
            }
            .tabItem({
                Image(systemName: "book.pages")
                Text("Custom Scroll Indicator")
            })
            .safeAreaPadding(.bottom)
            .tag(2)
        }
         */
        NavigationStack {
            BooksView(bibleViewModel: bibleViewModel)
        }
    }
}

#Preview {
    ContentView()
}
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
                booktoolbar
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
                        .padding(.vertical, 4)
                        .padding(.horizontal, 12)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.trailing, 12)
        .padding(.leading, 12)
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
    private var versetoolbar: some View {
        NavigationLink {
            VersesStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        } label: {
            Image(systemName: "book.pages")
        }
    }
    @ViewBuilder
    private var booktoolbar: some View {
        NavigationLink {
            SearchableBibleStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        } label: {
            Image(systemName: "book")
        }
    }
}

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
        .toolbarTitleMenu {
            Button("King James Version") {
//                    searchIsActive.toggle()
            }
            Button("Catholic Public Domain Version") {
                
            }
        }
    }

    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(searchResults, id: \.self) { line in
                    Text(line)
                        .padding(.vertical, 2)
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
        .navigationTitle("Jesus Christ!")
        .navigationDestination(for: String.self) { value in
            VersesStackView(bibleLines: bibleLines)
        }
    }

    @ViewBuilder
    private var searchtoolbar: some View {
        Button(action: {
            searchIsActive.toggle()
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

struct ChaptersView: View {
    var book: BookModel
    init(book: BookModel) {
        self.book = book
    }
    var body: some View {
        CustomScrollIndicatorView(book: book)
    }
}
struct VerseView: View {
    @State private var isPlaying: Bool = false
    var chapter: ChapterModel
    init(chapter: ChapterModel) {
        self.chapter = chapter
        SpeechManager.shared.queue = chapter.verses.map { $0.verse }
    }
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(chapter.verses, id: \.self) { verse in
                    Text("\(verse.number) \(verse.verse)")
                    .textSelection(.enabled)
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
        .navigationTitle("Chapter \(chapter.number)")
        .onDisappear(perform: stop)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                stopButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                playPauseButton
            }
        }
    }

    @ViewBuilder
    private var playPauseButton: some View {
        Button(action: {
            isPlaying ? pause() : speak()
            isPlaying.toggle()
        }) {
            Image(systemName: isPlaying ? "pause" : "play")
        }
    }
    @ViewBuilder
    private var stopButton: some View {
        Button(action: {
            stop()
            isPlaying = false
        }) {
            Image(systemName: "stop")
        }
    }
    func speak() {
        SpeechManager.shared.speakFromBeginning()
    }
    func pause() {
        SpeechManager.shared.pauseSpeaking()
    }
    func stop() {
        SpeechManager.shared.stopSpeaking()
    }
}


