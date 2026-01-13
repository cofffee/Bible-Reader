//
//  SettingsView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/12/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    var body: some View {
        List {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .toggleStyle(.automatic)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
#Preview {
    SettingsView()
}
