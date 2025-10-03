//
//  Examples.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/28/25.
//

import SwiftUI
struct Examples: View {
    var body: some View {
        Text("Hello")
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
    CustomScrollIndicatorView(book: BookModel(name: "", chapters: []))
}
