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
//        VStack {
//            SearchableBibleStackView(bibleLines: bible.bibleRawStringLines!)
//            
////            SearchableBibleStackView(bibleLines: bible.bibleRawStringLines!)
//        }
        TabView(selection: $selectedTab) {
            VStack {
                SearchableBibleStackView(bibleLines: bibleViewModel.bibleRawStringLines)
            }
            .tabItem({
                Image(systemName: "book")
                Text("Book")
            })
            .tag(0)

            VStack {
                //VersesStackView(bibleLines: bible.bibleRawStringLines!)
//                guard let bibleVerses = bible.bibleVerseModel else { return }
                BooksView(books: bibleViewModel.bible.books)
            }
            .tabItem({
                Image(systemName: "book.pages")
                Text("Verses")
            })
            .safeAreaPadding(.bottom)
            .tag(1)

//            VStack {
//                SearchableBibleStackView(bibleLines: bible.bibleRawStringLines!)
//            }
//            .tabItem({
//                Image(systemName: "text.page.badge.magnifyingglass")
//                Text("Search")
//            })
//            .safeAreaPadding(.bottom)
//            .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
struct BooksView: View {
//    @State var bible: Bible
    var books: [BookModel]
    var body: some View {
        content
    }
    @ViewBuilder
    private var content: some View {
        NavigationStack {
            scrollview
            .toolbar {

            }
            .toolbarTitleMenu {
                Button("King James Version") {
                    print("ayooo")
                }
                Button("Catholic Public Domain Version") {
                    print("dude!")
                }
            }
        }
    }
    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(books, id: \.self) { book in
                    
                    NavigationLink(value: book) {
                        Text(book.name)
                    }
                    //Text("\(books[index].name) chapters: \(books[index].chapters.count)")
                        .padding(.vertical, 2)
                    /*
                    Text("\(line.bookName) \(line.chapter) \(line.verseNumber)")
                        .padding(.vertical, 2)
                     */
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
        .navigationTitle("Jesus Christ!")
        .navigationDestination(for: BookModel.self) { book in
            ChaptersView(book: book)
        }
    }
/*
    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(bibleLines ?? [], id: \.self) { line in
                    //line.verse
                    //\()
                    //
                    Text("\(line.bookName) \(line.chapter) \(line.verseNumber)")
                        .padding(.vertical, 2)
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
        .navigationTitle("Jesus Christ!")
    }
 */
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
        NavigationStack {
            scrollview
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    versetoolbar
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    searchtoolbar
                }
                ToolbarItem(placement: .bottomBar) {
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
        .navigationTitle("The Bible")
        .navigationDestination(for: String.self) { value in
            VersesStackView(bibleLines: bibleLines)
        }
    }

    @ViewBuilder
    private var versetoolbar: some View {
        NavigationLink {
            VersesStackView(bibleLines: bibleLines)
        } label: {
            Image(systemName: "book.pages")
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
    @ViewBuilder
    private var amentoolbar: some View {
        Button(action: {
            print("Amen!")
        }) {
            Image(systemName: "cross")
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
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(book.chapters, id: \.self) { chapter in
                    NavigationLink(value: chapter) {
                        Text(chapter.number)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
        .navigationTitle(book.name)
        .navigationDestination(for: ChapterModel.self) { chapter in
            VerseView(chapter: chapter)
        }
    }
}
struct VerseView: View {
    var chapter: ChapterModel
    init(chapter: ChapterModel) {
        self.chapter = chapter
    }
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(chapter.verses, id: \.self) { verse in
                    Text("\(verse.number) \(verse.verse)")
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
        .navigationTitle("Chapter \(chapter.number)")
        .onAppear(perform: speak)
        .onDisappear(perform: stopSpeaking)
    }
    func speak() {
        SpeechManager.shared.queue = chapter.verses.map { $0.verse }
        SpeechManager.shared.speakFromBeginning()
    }
    func stopSpeaking() {
        SpeechManager.shared.stopSpeaking()
    }
}
/*

class Bible: ObservableObject {
    @Published var bibleRawStringLines: [String]?
    @Published var bibleVerseModel: [BibleVerseModel]?
    init() {
        // catholic_public_domain_version_bible
        // king_james_version_bible
        if let filepath = Bundle.main.path(forResource: "catholic_public_domain_version_bible", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath, encoding: .utf8)
                bibleRawStringLines = contents.components(separatedBy: .newlines)
                
                parseBooks()

            } catch {
                // contents could not be loaded
                print("Error loading file: \(error)")
            }
        } else {
            // example.txt not found!
            print("example.txt not found in bundle.")
        }
    }

    func parseBooks() {
        if let rawBibleLines = bibleRawStringLines {
            for line in rawBibleLines {
                var verse: BibleVerseModel
                let lineComponents = line.components(separatedBy: " ")
                if let first = lineComponents.first {
                    if let _ = Int(first) { //first item in string is a number
                        let chapterAndVerse = lineComponents[2].components(separatedBy: ":")
                        let verseNumber = chapterAndVerse.last?.split(separator: "\t")
                        let loneVerse = line.components(separatedBy: "\t").last

                        verse = BibleVerseModel(
                            bookName: "\(first) \(lineComponents[1])",
                            chapter: chapterAndVerse.first ?? "",
                            verseNumber: String(verseNumber?.first ?? ""),
                            verse: loneVerse ?? "")
                    } else {
                        let chapterAndVerse = lineComponents[1].components(separatedBy: ":")
                        let verseNumber = chapterAndVerse.last?.split(separator: "\t")
                        let loneVerse = line.components(separatedBy: "\t").last

                        verse = BibleVerseModel(
                            bookName: first,
                            chapter: chapterAndVerse.first ?? "",
                            verseNumber: String(verseNumber?.first ?? ""),
                            verse: loneVerse ?? "")
                    }
                } else {
                    verse = BibleVerseModel(
                        bookName: "",
                        chapter: "",
                        verseNumber: "",
                        verse: line)
                }
                bibleVerseModel?.append(verse)
            }
        }
    }
}
*/


import AVFoundation

class SpeechhManager: NSObject, AVSpeechSynthesizerDelegate {
    let synthesizer = AVSpeechSynthesizer()
    var textChunks: [String] = []
    var currentUtteranceIndex = 0

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speakLongText(_ longText: String) {
        // Split the text into sentences or paragraphs
        // For simplicity, let's split by sentences here
        textChunks = longText.components(separatedBy: ".")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { $0 + "." } // Add the period back to each sentence
        
        currentUtteranceIndex = 0
        speakNextChunk()
    }

    func speakNextChunk() {
        guard currentUtteranceIndex < textChunks.count else {
            print("Finished speaking all chunks.")
            return
        }

        let utterance = AVSpeechUtterance(string: textChunks[currentUtteranceIndex])
        synthesizer.speak(utterance)
    }

    // MARK: - AVSpeechSynthesizerDelegate

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        currentUtteranceIndex += 1
        speakNextChunk()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("Speech cancelled.")
    }
}
/*
// How to use it:
let speechManager = SpeechManager()
let longText = "This is a very long piece of text that needs to be spoken. It contains multiple sentences and paragraphs. The speech synthesizer will handle each chunk individually to provide a smoother listening experience. You can also pause and resume the speech as needed."
speechManager.speakLongText(longText)
*/
