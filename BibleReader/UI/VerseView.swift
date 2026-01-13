//
//  VerseView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/30/25.
//

import SwiftUI

struct VerseView: View {
    @AppStorage("savedVerses", store: UserDefaults(suiteName: "SavedVerses.OpenBibleReader")) var savedVerses: Data = .init()
    @State var tempVersesArray: [String] = []
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
                        .contextMenu { // Adds custom menu items on long press
                            Button {
                                UIPasteboard.general.string = "\(chapter.book) \(chapter.number):\(verse.number) \(verse.verse)"//"\(verse.number) \(verse.verse)"
                            } label: {
                                Label("Copy", systemImage: "document.on.document")
                            }
                            ShareLink(item: "\(verse.number) \(verse.verse)")
                            Button {
                                // SAVE THE VERSE
                                tempVersesArray = Storage.loadStringArray(data: savedVerses)
                                tempVersesArray.append("\(chapter.book) \(chapter.number):\(verse.number) \(verse.verse)")
                                savedVerses = Storage.archiveStringArray(object: tempVersesArray)
                                
                            } label: {
                                Label("Save", systemImage: "heart")
                            }
                        }
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
