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
        .animation(.spring, value: savedVerses)
        .listStyle(.plain)
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                sharetoolbar
            }
            
        }
        .scrollIndicators(.hidden)

    }
    func deleteVerse(at offsets: IndexSet) {
        var storedVersesArray = Storage.loadStringArray(data: savedVerses)
        storedVersesArray.remove(atOffsets: offsets)
        savedVerses = Storage.archiveStringArray(object: storedVersesArray)
    }

    @ViewBuilder
    private var sharetoolbar: some View {
        let copyOfSaved = Storage.loadStringArray(
            data: savedVerses).map {
                "\($0.verse) \($0.composite)"
            }.joined(separator: "\n")
        ShareLink(item: copyOfSaved)
    }
}
struct SavedVerseRowView: View {
    let verse: String
    let verseIdentifier: String
    var body: some View {
        VStack {
            Text(verse)
                .bodyStyle(fontSize: 21)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
                .padding(.trailing, 13)
            Text(verseIdentifier)
                .bodyStyle(fontSize: 13)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 13)
        }
    }
}
#Preview {
    SavedVersesView()
}
