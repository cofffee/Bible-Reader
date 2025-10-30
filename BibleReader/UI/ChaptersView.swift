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
        CustomScrollIndicatorView(book: book)
    }
}
struct VerseView: View {
    @State private var isPlaying: Bool = false
    var chapter: ChapterModel
    init(chapter: ChapterModel) {
        self.chapter = chapter
        SpeechManager.shared.queue = chapter.verses.map { $0.verse }
    }
//    @Environment(\.presentationMode) var mode
    var body: some View {
        /*
        List {
            ForEach(chapter.verses, id: \.self) { verse in
                Text("\(verse.number) \(verse.verse)")
                    .listRowSeparator(.hidden)
                    .listRowSpacing(0)
                    .swipeActions {
                        Button("Save") {
                            print("\(verse.verse)")
                        }
                        .tint(.green)
                    }
                    .background(Color.blue)
//                .textSelection(.enabled)
                //CustomSwipeCell(item: "\(verse.number) \(verse.verse)")
            }
        }
        .listStyle(.plain)
//        .listRowSeparator(.hidden)
//        .environment(\.defaultMinListRowHeight, 0)
        .navigationTitle("\(chapter.number)")
        .onDisappear(perform: stop)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                stopButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                playPauseButton
            }
        }
         */
        
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(chapter.verses, id: \.self) { verse in
                    Text("\(verse.number) \(verse.verse)")
                    //.textSelection(.enabled)
                    //CustomSwipeCell(item: "\(verse.number) \(verse.verse)")
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.trailing, 8)
        .padding(.leading, 8)
        .navigationTitle("\(chapter.number)")
        .onDisappear(perform: stop)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                stopButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                playPauseButton
            }
        }
    }

    @ViewBuilder
    private var playPauseButton: some View {
        Button(action: {
            isPlaying ? pause() : speak()
            isPlaying.toggle()
        }) {
            Image(systemName: isPlaying ? "pause" : "play")
        }
    }
    @ViewBuilder
    private var stopButton: some View {
        Button(action: {
            stop()
            isPlaying = false
        }) {
            Image(systemName: "stop")
        }
    }
    func speak() {
        SpeechManager.shared.speakFromBeginning()
    }
    func pause() {
        SpeechManager.shared.pauseSpeaking()
    }
    func stop() {
        SpeechManager.shared.stopSpeaking()
    }
}

#Preview {
    ChaptersView(book: BookModel(name: "", chapters: []))
}
