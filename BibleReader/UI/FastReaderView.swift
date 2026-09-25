//
//  FastReaderView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/17/26.
//

import SwiftUI

struct FastReaderView: View {
    @State private var isReading: Bool = false
    @Binding var isFastReader: Bool
    @StateObject var reader: FastReaderViewModel
    @State var viewSpeed: Double = 0
    
    @State private var sliderValue: Double = 0.0

    var body: some View {
        VStack {
            Spacer()
            Text(reader.currentWord)
                .font(
                    .system(
                        size: 40))
//                .padding(.bottom, 100)
                .offset(y: -120)
            HStack {
                Button("-") {
                    reader.speed = reader.speed - 15.0
                }
                Slider(value: $reader.speed, in: 50...1000)
                Button("+") {
                    reader.speed = reader.speed + 15.0
                }
            }
            .padding(.trailing, 60)
            .padding(.leading, 60)

            Text("\(reader.speed)")
            playPauseButton
            Spacer()
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                fastReaderButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                playPauseButton
            }
        }
    }
    @ViewBuilder
    private var fastReaderButton: some View {
        Button(action: {
            isFastReader.toggle()
        }) {
            Image(systemName: "hare")
        }
    }
    @ViewBuilder
    private var playPauseButton: some View {
        Button(action: {
            isReading.toggle()
            reader.read()
        }) {
            Image(systemName: isReading ? "pause" : "play")
        }
    }
}


class FastReaderViewModel: ObservableObject {
    @Published var currentWord: String = ""
    let chapter: [String]
    @Published var stop: Bool = false
    @Published var speed: Double = 200
    init(chapter: [String]) {
        self.chapter = chapter
        Task {
            await wordIterator()
        }
    }
    func read() {
        Task {
            await wordIterator()
        }
    }
//    @MainActor
    func wordIterator() async {
        for verse in chapter {
            for theWord in verse.components(separatedBy: " ") {
                // Suspend the current task for 1 second
                do {
                    await MainActor.run {
                        currentWord = theWord
                    }
                    
                    try await Task.sleep(for: .milliseconds(Int(speed)))
                    print(speed)
                } catch {
                    // Handle cancellation or other errors
                    print("Task sleep cancelled or failed: \(error)")
                    break // Exit the loop if cancelled
                }
            }
        }
    }

}
#Preview {/*
    FastReaderView(
        isFastReader: .constant(true),
        reader: FastReaderViewModel(
            chapter:
                ["In the beginning was the Word, and the Word was with God, and the Word was God."]))
           */
    GeometryReaderBootcamp()
}

struct GeometryReaderBootcamp: View {
    func getPercentage(geo: GeometryProxy) -> Double {
        let maxDistance = UIScreen.main.bounds.width / 2
        let currentX = geo.frame(in: .global).midX
        return Double(1 - (currentX / maxDistance))
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<20) { index in
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 20)
                            .rotation3DEffect(Angle(degrees: getPercentage(geo: geometry) * 40), axis: (x: 0.0, y: 1.0, z: 0.0))
                    }
                    .frame(width: 300, height: 250)
                    .padding()
                }
            }
        }
    }
}
