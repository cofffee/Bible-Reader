//
//  Bible.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/28/25.
//

import Foundation
import Combine

class BibleViewModel: ObservableObject {
    @Published private(set) var bibleRawStringLines: [String] = []
    @Published var bible = BibleModel(books: [], version: .kingjames)
    let defaultBibleVersion: BibleVersion = .americankingjames
    var isLoading = false
    
    @Published private(set) var filteredBibleRawStringLines: [String] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    var isSearching: Bool {
        !searchText.isEmpty
    }
    private func filterBible(searchText: String) {
        guard !searchText.isEmpty else {
            filteredBibleRawStringLines = []
            return
        }
        let search = searchText.lowercased()
        filteredBibleRawStringLines = bibleRawStringLines.filter({ bibleLine in
            return bibleLine.lowercased().contains(search)
        })
    }
    init() {
        addSubscribers()
    }
    func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterBible(searchText: searchText)
            }
            .store(in: &cancellables)
    }

//    @MainActor
    func fetchBooks(version: BibleVersion = .americankingjames) async {
        isLoading = true
        if let filepath = Bundle.main.path(forResource: version.rawValue, ofType: "txt") {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(filePath: filepath))
                if let contents = String(data: data, encoding: .utf8) {
                    Task { await parseStringLines(content: contents) }
                    Task {
                        await setBibleModel(content: contents)
                        await MainActor.run {
                            bible.version = version
                        }
                    }
                }
            } catch {
                // contents could not be loaded
                print("Error loading file: \(error)")
            }
        } else {
            // example.txt not found!
            print("example.txt not found in bundle.")
        }
    }

    func parseStringLines(content: String) async {
        await MainActor.run {
            bibleRawStringLines = content.components(separatedBy: .newlines)
        }
    }

    func setBibleModel(content: String) async {
        let parsedBible = await parseBibleLinesIntoModel(content: content)
        await MainActor.run {
            bible = parsedBible
            isLoading = false
        }
    }
    struct Line: Identifiable, Hashable {
        var id: String = UUID().uuidString
        let book: String
        let chapterNum: String
        let verseNum: String
        let verse: String
        var composite: String {
            return "\(book) \(chapterNum) \(verseNum)"
        }
    }
    static func parse(line: String) -> Line {
        let emptyLine = Line(
            book: "",
            chapterNum: "",
            verseNum: "",
            verse: "")
        let lineComponents = line.components(separatedBy: " ")
        guard let firstWord = lineComponents.first else { return emptyLine }
        let bookNameIndex = firstWord == "Song" ? 3 : Int(firstWord) == nil ? 1 : 2 //if first word is Song then bookNameIndex is 3 else if it is not a number 1, else 2
        guard let chapterAndVerse = lineComponents[checked: bookNameIndex]?.components(separatedBy: ":") else { return emptyLine }

        let bookName = lineComponents.prefix(bookNameIndex).joined(separator: " ")
        guard let chapterNumber = chapterAndVerse.first else { return emptyLine }
        guard let verseLine = line.components(separatedBy: "\t").last else { return  emptyLine }
        let verseNumber = String(chapterAndVerse[checked: 1]?.components(separatedBy: "\t").first ?? "")

        return Line(book: bookName, chapterNum: chapterNumber, verseNum: verseNumber, verse: verseLine)
    }

    func parseBibleLinesIntoModel(content: String) async -> BibleModel {
        var buildingBible = BibleModel(books: [], version: defaultBibleVersion)
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
            let parsedLine = BibleViewModel.parse(line: line)
            let verseModel = VerseModel(number: parsedLine.verseNum, verse: parsedLine.verse)
            let chapterModel = ChapterModel(book: parsedLine.book, number: parsedLine.chapterNum, verses: [verseModel])
            let bookModel = BookModel(name: parsedLine.book, chapters: [chapterModel])

            //buildingBible.books.append(bookModel) // TODO: create an update method for bible
            if let bookIndex = buildingBible.books.firstIndex(where: { $0.name == parsedLine.book }) {
                /// "genesis" exists,
                /// get genesis and update genesis
                /// check if genesis has the first chapter
                if let chapterIndex = buildingBible.books[bookIndex].chapters.firstIndex(where: { $0.number == parsedLine.chapterNum }) {
                    /// chapter exists, so update the verse
                    buildingBible.books[bookIndex].chapters[chapterIndex].verses.append(verseModel)
                } else {
                    /// insert as CHAPTER
                    buildingBible.books[bookIndex].chapters.append(chapterModel)
                }
            } else {
                /// no genesis.. create genesis
                // create the book, the chapter, and the verse and insert to bible
                /// append directly to books
                buildingBible.books.append(bookModel)
                print("name of book to be appended: \(bookModel.name)")
            }
        }
        return buildingBible
    }
}
