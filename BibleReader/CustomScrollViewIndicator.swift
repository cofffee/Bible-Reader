//
//  CustomScrollViewIndicator.swift
//  BibleReader
//
//  Created by Kevin Remigio on 8/8/25.
//

import SwiftUI

struct CustomScrollIndicatorView: View {
    let book: BookModel
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                booksList
                sectionIndexTitles(proxy: proxy)
                .frame(width: 144)
            }
        }
        .navigationBarTitle(book.name)
  }

    var booksList: some View {
        ScrollView {
            LazyVStack {
                
                ForEach(Array(book.chapters.map { $0.number }), id: \.self) { title in //.sorted()
                    Section(header: HeaderView(title: title)) {
                        chapterVerses(index: Int(title) ?? 0)
                    }
                }
                 /*
                ForEach(book.chapters, id: \.self) { title in //.sorted()
                    Section(header: HeaderView(title: title)) {
                        chapterVerses(index: Int(title.number) ?? 0)
                    }
                }
                  */
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    func chapterVerses(index: Int) -> some View {
        ForEach(book.chapters[checked: index-1]?.verses ?? []) { item in
            RowView(text: "\(item.number) \(item.verse)")
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
//    let title: ChapterModel
    var body: some View {
        NavigationLink(value: title) {
//            Text(title.number)
            Text(title)
            .font(.title)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct RowView: View {
    let text: String
    var body: some View {
        Text(text)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .padding(.bottom, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .frame(width: 40)
        .overlay(
            Text(title)
            .foregroundColor(.blue)
            .font(.system(size: 12))
        )
    }
}
#Preview {
    CustomScrollIndicatorView(book: BookModel(
        name: "gem",
        chapters: [
            ChapterModel(
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
