//
//  ContextMenuButtons.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/15/26.
//

import SwiftUI

struct SaveVerseButtonView: View {
    @AppStorage("savedVerses", store: UserDefaults(suiteName: "SavedVerses.OpenBibleReader")) var savedVerses: Data = .init()
    @State var tempVersesArray: [SaveLine] = []
    let line: SaveLine
    var body: some View {
        Button {
            tempVersesArray = Storage.loadStringArray(data: savedVerses)
            tempVersesArray.append(line)
            savedVerses = Storage.archiveStringArray(object: tempVersesArray)
        } label: {
            Label("Save", systemImage: "heart")
        }
    }
}

struct CopyButtonView: View {
    let line: String
    var body: some View {
        Button {
            UIPasteboard.general.string = line
        } label: {
            Label("Copy", systemImage: "document.on.document")
        }

    }
}


#Preview {
//    ContextMenuButtons()
}
