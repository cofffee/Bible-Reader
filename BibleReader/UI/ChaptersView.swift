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
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(chapter.verses, id: \.self) { verse in
                    Text("\(verse.number) \(verse.verse)")
                    .textSelection(.enabled)
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.leading, 12)
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
