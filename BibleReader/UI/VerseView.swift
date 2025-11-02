//
//  VerseView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/30/25.
//

import SwiftUI

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
    //VerseView()
}
