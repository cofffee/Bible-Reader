//
//  ChaptersWithRowScrollView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 8/8/25.
//

import SwiftUI

struct ChaptersWithRowScrollView: View {
    let book: BookModel
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                chapterRow
                sectionIndexTitlesRow(proxy: proxy)
                .frame(width: 70)//64) //144 //84
            }
        }
        .navigationBarTitle(book.name)
  }

    var chapterRow: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(book.chapters.map { $0.number }), id: \.self) { title in //.sorted()
                    if let chapterNumber = Int(title),
                       let chapter = book.chapters[checked: chapterNumber-1] {
                        Section(header: ChapterNumberView(
                            title: title,
                            chapter: chapter)) {
                                verses(index: chapterNumber)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    func verses(index: Int) -> some View {
        ForEach(book.chapters[checked: index-1]?.verses ?? []) { item in
            VerseRowView(
                verseNumberString: item.number,
                verseString: "\(item.verse)",
                verse: SaveLine(
                    book: book.name,
                    chapterNum: "\(index)",
                    verseNum: item.number,
                    verse: item.verse))
        }
    }
    func sectionIndexTitlesRow(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitlesRowView(
            proxy: proxy,
            titles: Array(book.chapters.map { $0.number }))
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 12)
    }
}

struct ChapterNumberView: View {
    let title: String
    let chapter: ChapterModel
    var body: some View {
        NavigationLink(value: chapter) {
            Text(title)
                .titleStyle()
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct VerseRowView: View {
    @Environment(\.font) var currentFont
    let verseNumberString: String
    let verseString: String
    let verse: SaveLine
    var body: some View {
        HStack(alignment: .top) {
            Text(verseNumberString)
                .bodyStyle(fontSize: 8)
            Text(verseString)
                .bodyStyle()
        }
        .padding(.leading, 10)
        .padding(.trailing, 4)
        .padding(.bottom, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contextMenu {
            SaveVerseButtonView(line: verse)
        }
    }
}

struct SectionIndexTitlesRowView: View {
    let proxy: ScrollViewProxy
    let titles: [String]
    @GestureState private var dragLocation: CGPoint = .zero
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(titles), id: \.self) { title in
                    SectionIndexTitle(title: title)
                        .background(dragObserver(title: title))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .gesture(
                DragGesture(
                    minimumDistance: 0,
                    coordinateSpace: .global)
                    .updating($dragLocation) { value, state, _ in
                        state = value.location
                    })
        }
        .scrollIndicators(.hidden)
//        .background(Color.red)
    }
    
    func dragObserver(title: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title)
        }
    }
    private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    proxy.scrollTo(title, anchor: .top)
                }
            }
        }
        return Rectangle().fill(Color.clear)
    }
}

struct SectionIndexTitle: View {
    let title: String
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
        .foregroundColor(Color.clear)
        .frame(width: 38)//30)//40)
        .overlay(
            Text(title)
            .foregroundColor(.blue)
            .font(.system(size: 12))
        )
    }
}
#Preview {
    ChaptersWithRowScrollView(book: BookModel(
        name: "gem",
        chapters: [
            ChapterModel(
                book: "Genesis",
                number: "1",
                verses: [ VerseModel(number: "1", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "2", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "3", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "4", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "5", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "6", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "7", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                        ]
            ),
            ChapterModel(
                book: "Genesis",
                number: "2",
                verses: [ VerseModel(number: "1", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "2", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "3", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "4", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "5", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "6", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "7", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                        ]
            ),
            ChapterModel(
                book: "Genesis",
                number: "3",
                verses: [ VerseModel(number: "1", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "2", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "3", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "4", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "5", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "6", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                          VerseModel(number: "7", verse: "And there went out to him all the region of Judea and all those of Jerusalem, and they were baptized by him in the river Jordan, confessing their sins."),
                        ]
            )
            ]
    ))
}
