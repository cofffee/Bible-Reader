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
struct CustomScrollIndicatorVieww: View {
    var alphabet = ["a","b","c", "d", "e","f","g", "h", "i","j","k", "l",
                    "m","n","o", "p", "q","r","s", "t", "u","v","w", "x", "y", "z"]
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                ForEach((alphabet), id: \.self) { row in
                    Text("Row \(row)")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .id(row)
                }
            }
            .overlay(alignment: .top) {
                HStack {
                    Spacer()
                    VStack {
                        ForEach(alphabet, id: \.self) { title in
                            Button(action: {
                                withAnimation(.spring()) {
                                    proxy.scrollTo(title, anchor: .top)
                                    print("did tap: \(title)")
                                }
                            }) {
                                Text(title)
                                    .frame(width: 34, height: 18)
                                    .font(.system(size: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.blue, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.trailing)
                }
            }
        }
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
    CustomScrollIndicatorVieww()
}
