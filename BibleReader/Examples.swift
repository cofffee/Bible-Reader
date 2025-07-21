//
//  Examples.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/28/25.
//

import SwiftUI

struct Examples: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
/// Example of a generec content
struct MyFirstGeneric<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
    }
}

#Preview {
    Examples()
}


/*
class BibleModel: ObservableObject {
    @Published var bibleVerseArray: [BibleVerseModel] = []
    @Published var isLoading: Bool = false
    init() {
        getBibleVersion()
    }
    func getBibleVersion() {
        // catholic_public_domain_version_bible
        // king_james_version_bible
        if let filepath = Bundle.main.path(forResource: "catholic_public_domain_version_bible", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath, encoding: .utf8)
                
//                bibleRawString = contents
                //words = contents.components(separatedBy: " ")
                let bibleRawStringLines:[String] = contents.components(separatedBy: .newlines)
                for line in bibleRawStringLines {
                    let verse = BibleVerseModel(
                        bookName: "",
                        chapter: "",
                        verseNumber: "",
                        verse: line)
                    self.bibleVerseArray.append(verse)
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
}
*/
