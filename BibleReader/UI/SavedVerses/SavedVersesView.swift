//
//  SavedVersesView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/12/26.
//

import SwiftUI

struct SavedVersesView: View {
    @AppStorage("savedVerses", store: UserDefaults(suiteName: "SavedVerses.OpenBibleReader")) var savedVerses: Data = .init()
    var body: some View {
        List {
            ForEach(Storage.loadStringArray(data: savedVerses), id: \.self) { line in
                SavedVerseRowView(verse: line.verse, verseIdentifier: line.composite)
                .listRowSeparator(.hidden)
                .contextMenu {
                    CopyButtonView(line: line.verse)
                }
            }
            .onDelete(perform: deleteVerse)
        }
        .listStyle(.plain)
        .navigationTitle("Favorites")
    }
    func deleteVerse(at offsets: IndexSet) {
        var storedVersesArray = Storage.loadStringArray(data: savedVerses)
        storedVersesArray.remove(atOffsets: offsets)
        savedVerses = Storage.archiveStringArray(object: storedVersesArray)
    }
}
struct SavedVerseRowView: View {
    let verse: String
    let verseIdentifier: String
    var body: some View {
        VStack {
            Text(verse)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(verseIdentifier)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
#Preview {
    SavedVersesView()
}
