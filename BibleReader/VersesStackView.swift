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
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                scrollview
            }
            .navigationTitle("Verses")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    randomizetoolbar
                }
            }
        }
    }

    @ViewBuilder
    var randomizetoolbar: some View {
        Button(action: { randomize() })
        { Image(systemName: "sparkles") }
    }

    @ViewBuilder
    var scrollview: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(bibleLines, id: \.self) { line in
                    Rectangle()
                        .fill(.clear)
                        .overlay{
                            ZStack {
                                VStack {
                                    Text(line)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 12)
                                        .padding(.leading, 12)
                                        .padding(.bottom, 160)
                                        .font(.system(size: 24))
                                }
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
