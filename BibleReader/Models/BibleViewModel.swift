//
//  Bible.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/28/25.
//

import Foundation
class BibleViewModel: ObservableObject {
    @Published var bibleRawStringLines: [String] = []
    @Published var bible = BibleModel(books: [])
    init() {
        Task {
            await fetchBooks()
        }
    }

    func fetchBooks() async {
        // catholic_public_domain_version_bible
        // king_james_version_bible
        if let filepath = Bundle.main.path(forResource: "catholic_public_domain_version_bible", ofType: "txt") {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(filePath: filepath))
                if let contents = String(data: data, encoding: .utf8) {
                    Task { await parseStringLines(content: contents) }
                    Task { await setBibleModel(content: contents) }
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
        let parsedBible = await parseModelLines(content: content)
        await MainActor.run { bible = parsedBible }
    }

    func parseModelLines(content: String) async -> BibleModel {
        var buildingBible = BibleModel(books: [])
        let lines = content.components(separatedBy: .newlines)

        for line in lines {
            let lineComponents = line.components(separatedBy: " ")
            guard let firstWord = lineComponents.first else { return buildingBible }
            let bookNameIndex = Int(firstWord) == nil ? 1 : 2 //if first word is not a number 1, else 2
            // TODO: FIX FOR BOOK OF SONGS
            guard let chapterAndVerse = lineComponents[checked: bookNameIndex]?.components(separatedBy: ":") else { return buildingBible }
            let bookName = lineComponents.prefix(bookNameIndex).joined(separator: " ")
            guard let chapterNumber = chapterAndVerse.first else { return buildingBible }
            
            guard let verseLine = line.components(separatedBy: "\t").last else { return  buildingBible }
            
            //guard let numberAndVerseArray = chapterAndVerse.last?.split(separator: "\t") else { return buildingBible } ///empty for the edge case
//            guard let verseNumber = numberAndVerseArray.first else { return }
               
//            print("\(bookName) :: chapter \(chapterNumber) verseNumSubs:: \(numberAndVerseArray) verseNumber:: \(String(chapterAndVerse[checked: 1] ?? "what doesnt exist?") )")

            let verseNumber = String(chapterAndVerse[checked: 1]?.components(separatedBy: "\t").first ?? "")

            let verse = VerseModel(number: verseNumber, verse: verseLine)
            let chapterModel = ChapterModel(number: chapterNumber, verses: [verse])
            let bookModel = BookModel(name: bookName, chapters: [chapterModel])

            //buildingBible.books.append(bookModel) // TODO: create an update method for bible
            if let bookIndex = buildingBible.books.firstIndex(where: { $0.name == bookName }) {
                /// "genesis" exists,
                /// get genesis and update genesis
                /// check if genesis has the first chapter
                if let chapterIndex = buildingBible.books[bookIndex].chapters.firstIndex(where: { $0.number == chapterNumber }) {
                    /// chapter exists, so update the verse
                    buildingBible.books[bookIndex].chapters[chapterIndex].verses.append(verse)
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
