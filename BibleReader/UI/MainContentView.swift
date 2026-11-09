//
//  ContentView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 6/21/25.
//

import SwiftUI
import FoundationModels
import Combine
//struct Intelligence {
//    public func generate(_ input: String) async throws -> String {
//        if #available(iOS 26.0, *) {
//            guard SystemLanguageModel.default.isAvailable else {
//                return input
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        if #available(iOS 26.0, *) {
//            let session = LanguageModelSession()
//            let response = try await session.respond(to: input)
//            return response.content
//        } else {
//            // Fallback on earlier versions
//            return "Doesnt Work"
//        }
//    }
//}
//@MainActor
//class FoundationAIViewModel: ObservableObject {
//    @Published var testString = ""
//    let intelligence = Intelligence()
//    func generateInput() async {
//        do {
//            testString = try await intelligence.generate("List of names")
//        } catch {
//            print(error)
//        }
//    }
//}
struct MainContentView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("Font") var defaultFont: String?
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: BibleViewModel
//    @StateObject var aiViewModel = FoundationAIViewModel()
    var body: some View {
        NavigationStack {
            BooksView(bibleViewModel: viewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }

//        VStack {
//            Text(aiViewModel.testString)
//        }
        .task {
            await viewModel.fetchBooks()
//            await aiViewModel.generateInput()
        }
    }
}

#Preview {
    //SavedVersesView()
    MainContentView(viewModel: BibleViewModel())
    
}


