//
//  VersesStackView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/28/25.
//

import SwiftUI

struct VersesStackView: View {
    @State private var scrollPosition: String? = nil
    var bibleLines: [String]
    var body: some View {
        content
        .onAppear{ randomize() }
    }

    @ViewBuilder
    var content: some View {
        VStack(spacing: 0) {
            Spacer()
            scrollview
        }
        .navigationTitle("Verses")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
//                favoritetoolbar
                randomizetoolbar
            }
        }
    }

    @ViewBuilder
    var randomizetoolbar: some View {
        Button(action: { randomize() })
        { Image(systemName: "richtext.page") }
    }
    @ViewBuilder
    var favoritetoolbar: some View {
        Button(action: { print("save the verse here :// TODO!") })
        { Image(systemName: "heart") }
    }
    @ViewBuilder
    var scrollview: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(bibleLines, id: \.self) { line in
                    let lineModel = BibleViewModel.parse(line: line)
                    Rectangle()
                        .fill(.clear)
                        .overlay{
                            ZStack {
                                VStack {
                                    Text(lineModel.verse)
                                        .padding(.trailing, 12)
                                        .padding(.leading, 12)
                                        .font(.system(size: 24))
                                        .contextMenu {
                                            SaveVerseButtonView(
                                                line: SaveLine(
                                                    book: lineModel.book,
                                                    chapterNum: lineModel.chapterNum,
                                                    verseNum: lineModel.verseNum,
                                                    verse: lineModel.verse))
                                        }
                                    HStack {
                                        Text(lineModel.composite)
                                            .font(.system(size: 13))
                                        
                                    }
                                    .padding(.top, 8)
                                }
                                .padding(.bottom, 160)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .containerRelativeFrame(.vertical, alignment: .center)
                        //.background(.yellow) /// to see the tops and bottoms
                        .id(line)
                }
            }
        }
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollBounceBehavior(.basedOnSize)
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .toolbarBackground(.white, for: .tabBar)
    }

    func randomize() {
        guard let randomVerse = bibleLines.randomElement() else { return }
        scrollPosition = randomVerse
    }
}

#Preview {
    VersesStackView(bibleLines: ["Hi"])
}
