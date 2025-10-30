//
//  Examples.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/28/25.
//

import SwiftUI
struct Examples: View {
    var body: some View {
        Text("Hello")
    }
}
/// Example of a generec content
struct MyFirstGeneric<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
    }
}

#Preview {
    //CustomScrollIndicatorView(book: BookModel(name: "", chapters: []))
    LazyVStackWithSwipeActions()
}

import SwiftUI

struct CustomSwipeCell: View {
    let item: String
    @State private var offset: CGSize = .zero
    @State private var showActions: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            // Swipe Actions
            HStack {
                Button(action: {
                    print("Delete \(item)")
                    // Perform delete action
                    showActions = false // Hide actions after action
                    offset = .zero
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                // Add more actions here
            }
            .offset(x: showActions ? 0 : 100) // Adjust offset to reveal/hide actions

            // Main Content
            Text(item)
                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(radius: 2)
                .offset(x: offset.width)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset.width = gesture.translation.width
                        }
                        .onEnded { gesture in
                            if gesture.translation.width < -50 { // Swipe left threshold
                                showActions = true
                                offset.width = -100 // Adjust to reveal actions fully
                            } else {
                                showActions = false
                                offset = .zero // Reset position
                            }
                        }
                )
        }
    }
}

struct LazyVStackWithSwipeActions: View {
    let items = (1...20).map { "Item \($0)" }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.self) { item in
                    CustomSwipeCell(item: item)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}
