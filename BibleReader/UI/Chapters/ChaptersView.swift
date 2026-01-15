//
//  ChaptersView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct ChaptersView: View {
    var book: BookModel
    init(book: BookModel) {
        self.book = book
    }
    var body: some View {
        BookChaptersCustomScrollIndicatorView(book: book)
    }
}

#Preview {
    ChaptersView(book: BookModel(name: "", chapters: []))
}
