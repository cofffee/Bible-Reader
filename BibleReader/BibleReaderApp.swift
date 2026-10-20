//
//  BibleReaderApp.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/21/25.
//

import SwiftUI

@main
struct BibleReaderApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView(viewModel: BibleViewModel())
        }
    }
}
