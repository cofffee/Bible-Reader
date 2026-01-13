//
//  SavedVersesView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/12/26.
//

import SwiftUI

struct SavedVersesView: View {
    @AppStorage("savedVerses", store: UserDefaults(suiteName: "SavedVerses.OpenBibleReader")) var savedVerses: Data = .init()
    var body: some View {
        List {
            ForEach(Storage.loadStringArray(data: savedVerses), id: \.self) { verse in
                Text("\(verse)")
            }
        }
    }
}
#Preview {
    SavedVersesView()
}
