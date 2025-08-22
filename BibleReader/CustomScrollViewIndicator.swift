//
//  CustomScrollViewIndicator.swift
//  BibleReader
//
//  Created by Kevin Remigio on 8/8/25.
//

import SwiftUI

struct CustomScrollIndicatorView: View {
//    let book: [String: [String]] = ["a": ["b", "c"]]
    
//    let bookk: [ChapterModel]

    let book: BookModel
    let devices: [String: [String]] = ["a": ["a", "b", "c", "d", "e"],
                                       "b": ["a", "b", "c", "d", "e"],
                                       "c": ["a", "b", "c", "d", "e"],
                                       "d": ["a", "b", "c", "d", "e"],
                                       "e": ["a", "b", "c", "d", "e"],
                                       "f": ["a", "b", "c", "d", "e"],
                                       "g": ["a", "b", "c", "d", "e"],
                                       "h": ["a", "b", "c", "d", "e"]]
    //let chapterTitles: [String] = book.chapters.map { $0.number })
    let chapterTitles: [String] = ["1", "2", "3",
                                   "4", "5", "6",
                                   "7", "8", "9",
                                   "10", "11", "12",
                                   "13", "14", "15",
                                   "16", "17", "18"]
    
    let chapterchapter: [ChapterModel] = [ChapterModel(number: "1", verses: []),
                                         ChapterModel(number: "2", verses: []),
                                         ChapterModel(number: "3", verses: []),
                                         ChapterModel(number: "4", verses: []),
                                         ChapterModel(number: "5", verses: []),
                                         ChapterModel(number: "6", verses: []),
                                         ChapterModel(number: "7", verses: []),
                                         ChapterModel(number: "8", verses: []),
                                         ChapterModel(number: "9", verses: []),
                                          ChapterModel(number: "10", verses: []),
                                          ChapterModel(number: "11", verses: []),
                                          ChapterModel(number: "12", verses: []),
                                          ChapterModel(number: "13", verses: []),
                                          ChapterModel(number: "14", verses: []),
                                          ChapterModel(number: "15", verses: []),
                                          ChapterModel(number: "16", verses: [])]

//    let arrayObjectTestList = []
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                ScrollView {
                    LazyVStack {
                        devicesList
                    }

                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity, alignment: .leading)

                sectionIndexTitles(proxy: proxy)
                    .frame(width: 144)
          }
//          .overlay(sectionIndexTitles(proxy: proxy))
         }
        /*
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    devicesList
                }
          }
          .overlay(sectionIndexTitles(proxy: proxy))
         }
         */
//        .navigationBarTitle("\(Array(devices.keys)[0])") ///Array(devices.keys)
  }

    var devicesList: some View {
        /*
        ForEach(devices.sorted(by: { (lhs, rhs) -> Bool in false }), id: \.key) { categoryName, devicesArray in
            Section(header: HeaderView(title: categoryName)) {
            ForEach(devicesArray, id: \.self) { deviceName in
              RowView(text: deviceName)
            }
          }
        }
         */
        /*
        ForEach(Array(devices.keys), id: \.self) { key in
            Section(header: HeaderView(title: key)) {
                if let sectionTitle = devices[key] {
                    ForEach(sectionTitle, id: \.self) { item in
                        RowView(text: item)
                    }
                }
            }
        }
         */
        /*
        ForEach(Array(book.keys), id: \.self) { key in
            Section(header: HeaderView(title: key)) {
                if let sectionTitle = book[key] {
                    ForEach(sectionTitle, id: \.self) { item in
                        RowView(text: item)
                    }
                }
            }
        }
         */
        /*
        /* THIS WORKS*/
        ForEach(Array(chapterTitles), id: \.self) { title in //.sorted()
            Section(header: HeaderView(title: title)) {
                
            }
        }
*/
        
        ForEach(Array(book.chapters.map { $0.number }), id: \.self) { title in //.sorted()
            Section(header: HeaderView(title: title)) {
                chapterVerses(index: Int(title) ?? 0)
                /*
                ForEach(book.chapters[Int(title)].verses) { item in
                    RowView(text: "\(item.number) \(item.verse)")
//                RowView(text: "\(item.number) \(item.verse)")
                }
                 */
            }
        }
        /*
        ForEach(book.chapters.indices, id: \.self) { index in
            Section(header: HeaderView(title: book.chapters[index].number ) ) {
                let sectionTitle = book.chapters[index]
                ForEach(sectionTitle.verses, id: \.self) { item in
                    RowView(text: "\(item.number) \(item.verse)")
                }
            }
        }
        */
        /*
        ForEach(chapterTitles.indices, id: \.self) { index in
            Section(header: HeaderView(title: chapterTitles[index] ) ) {
//                let sectionTitle = book.chapters[index]
//                ForEach(sectionTitle.verses, id: \.self) { item in
//                    RowView(text: "\(item.number) \(item.verse)")
//                }
            }
        }
         */
        
        /*
        ForEach(Array(book.chapters)) { chapter in
            Section(header: HeaderView(title: chapter.number)) {
                ForEach(chapter.verses) { item in
                    RowView(text: "\(item.number) \(item.verse)")
                }
            }
        }
         */
        /*
        ForEach(book.chapters) { chapter in
            Section(header: HeaderView(title: chapter.number)) {
                ForEach(chapter.verses) { item in
                    RowView(text: "\(item.number) \(item.verse)")
                }
            }
        }*/
    }
    func chapterVerses(index: Int) -> some View {
        ForEach(book.chapters[checked: index-1]?.verses ?? []) { item in
            RowView(text: "\(item.number) \(item.verse)")
        }
    }
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        //SectionIndexTitles(proxy: proxy, titles: devices.keys.sorted())
        //SectionIndexTitles(proxy: proxy, titles: Array(chapterTitles))//.sorted())
//        let titles = book.chapters.map { $0.number }
        /*
        ScrollView {
            LazyVStack {
                devicesList
            }
        }
         
         */
        /*
        ScrollView {
            LazyVStack {
                ForEach(Array(chapterTitles), id: \.self) { title in
                    Text(title)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
         */

        SectionIndexTitles(proxy: proxy, titles: Array(book.chapters.map { $0.number }))
         
//        SectionIndexTitles(proxy: proxy, titles: chapterTitles)
//        SectionIndexTitles(proxy: proxy, titles: book.chapters)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
 
    }
}

struct HeaderView: View {
    let title: String
    var body: some View {
        Text(title)
        .font(.title)
        .fontWeight(.bold)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
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
            Color(.yellow)
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
        /*
        VStack {
            ForEach(titles, id: \.self) { title in
                SectionIndexTitle(title: title)
                    .background(dragObserver(title: title))
            }
        }
        .gesture(
            DragGesture(
                minimumDistance: 0,
                coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                })
         */
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

                    print("did tap: \(title)")
                }
            }
        }
        return Rectangle().fill(Color.clear)
    }
}

struct SectionIndexTitle: View {
    let title: String
    var body: some View {
//        Text(title)
//        .frame(width: 34, height: 8)
//        .font(.system(size: 8))
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//            .stroke(Color.blue, lineWidth: 1)
//        )
        
        
        RoundedRectangle(cornerRadius: 8, style: .continuous)
        .foregroundColor(Color.gray.opacity(0.1))
        .frame(width: 40, height: 40)
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
        /* book: ["iPhone": ["a", "b", "c"],
                           "iPad": ["a", "b", "c"],
                           "iPod": ["a", "b", "c"],
                           "Apple TV": ["a", "b", "c"],
                           "Apple Watch": ["a", "b", "c"],
                           "Homepod": ["a", "b", "c", "d"],
                           "g": ["a", "b", "c"],
                           "h": ["a", "b", "c"],
                           "i": ["a", "b", "c"]]) */
}
