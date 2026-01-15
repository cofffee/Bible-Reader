//
//  CustomScrollViewIndicator.swift
//  BibleReader
//
//  Created by Kevin Remigio on 8/8/25.
//

import SwiftUI

struct BookChaptersCustomScrollIndicatorView: View {
    let book: BookModel
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                booksList
                sectionIndexTitles(proxy: proxy)
                .frame(width: 64) //144 //84
            }
        }
        .navigationBarTitle(book.name)
  }

    var booksList: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(book.chapters.map { $0.number }), id: \.self) { title in //.sorted()
                    if let chapterNumber = Int(title),
                       let chapter = book.chapters[checked: chapterNumber-1] {
                        Section(header: HeaderView(
                            title: title,
                            chapter: chapter)) {
                                chapterVerses(index: chapterNumber)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    func chapterVerses(index: Int) -> some View {
        ForEach(book.chapters[checked: index-1]?.verses ?? []) { item in
            RowView(
                text: "\(item.number) \(item.verse)",
                verse: SaveLine(
                    book: book.name,
                    chapterNum: "\(index)",
                    verseNum: item.number,
                    verse: item.verse))
        }
    }
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitles(
            proxy: proxy,
            titles: Array(book.chapters.map { $0.number }))
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 12)
 
    }
}

struct HeaderView: View {
    let title: String
    let chapter: ChapterModel
    var body: some View {
        NavigationLink(value: chapter) {
            Text(title)
            .font(.title)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct RowView: View {
    @State private var showAlert = false
    let text: String
    let verse: SaveLine
    var body: some View {
        Text(text)
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .padding(.bottom, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contextMenu {
            SaveVerseButtonView(line: verse)
        }
    }
}
struct SectionIndexTitles: View {
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
        .frame(width: 30)//40)
        .overlay(
            Text(title)
            .foregroundColor(.blue)
            .font(.system(size: 12))
        )
    }
}
#Preview {
    BookChaptersCustomScrollIndicatorView(book: BookModel(
        name: "gem",
        chapters: [
            ChapterModel(
                book: "Genesis",
                number: "judas",
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
                number: "carrot",
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
                number: "beach",
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
