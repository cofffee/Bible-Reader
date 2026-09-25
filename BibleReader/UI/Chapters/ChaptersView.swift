//
//  ChaptersView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct ChaptersView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State var showSheet: Bool = false
    var book: BookModel
    init(book: BookModel) {
        self.book = book
    }
    var body: some View {
        ChaptersWithRowScrollView(book: book)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ToolbarButton.textformattoolbar(showSheet: $showSheet)
                ToolbarButton.savedversestoolbar
                ToolbarButton.darkmodetoolbar(isDarkMode: $isDarkMode)
            }
        }
    }
}

#Preview {
    ChaptersView(book: BookModel(name: "", chapters: []))
}
