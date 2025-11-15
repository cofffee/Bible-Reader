//
//  BooksView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/8/25.
//

import SwiftUI

struct BooksView: View {
    @State var showSheet: Bool = false
    @ObservedObject var bibleViewModel: BibleViewModel
    var body: some View {
        content
    }
    @ViewBuilder
    private var content: some View {
        scrollview
        .toolbar {
            /*
            ToolbarItemGroup(placement: .topBarLeading) {
                premiumsubscriptiontoolbar
            }
             */
            ToolbarItemGroup(placement: .topBarTrailing) {
                versetoolbar
                searchablebooktoolbar
            }
        }
        .toolbarTitleMenu {
            bibleVersionsList
        }
    }
    @ViewBuilder
    private var scrollview: some View {
        ScrollView(.vertical) {
            if bibleViewModel.isLoading {
                ProgressView()
            } else {
                HStack(alignment: .top) {
                    oldTestamentRows
                    newTestamentRows
                }
            }
        }
        .scrollIndicators(.hidden)
//        .navigationTitle(bibleViewModel.bible.version.title)
        .navigationTitle("The Bible")
        .navigationDestination(for: BookModel.self) { book in
            ChaptersView(book: book)
        }
        .navigationDestination(for: String.self) { value in
            VersesStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        }
        .navigationDestination(for: ChapterModel.self) { chapter in
            VerseView(chapter: chapter)
        }
    }

    @ViewBuilder
    private var oldTestamentRows: some View {
        let count = bibleViewModel.bible.version.oldTestamentCount
        LazyVStack(alignment: .trailing) {
            ForEach(bibleViewModel.bible.books.prefix(count), id: \.self) { book in
                NavigationLink(value: book) {
                    Text(book.name)
                }
                .padding(.vertical, 2)
                .padding(.trailing, 12)
            }
        }
    }
    @ViewBuilder
    private var newTestamentRows: some View {
        let count = bibleViewModel.bible.version.newTestamentCount
        LazyVStack(alignment: .leading) {
            ForEach(bibleViewModel.bible.books.suffix(count), id: \.self) { book in
                NavigationLink(value: book) {
                    Text(book.name)
                }
                .padding(.vertical, 2)
                .padding(.trailing, 12)
            }
        }
    }
    @ViewBuilder
    private var premiumsubscriptiontoolbar: some View {
        Button(action: {
            showSheet.toggle()
       }) {
           Image(systemName: "crown")
       }
        /* Full Screen Cover
       .fullScreenCover(isPresented: $showSheet) {
           SubscriptionScreen()
       }
         */
        ///*Sheet
       .sheet(isPresented: $showSheet) {
           //SubscriptionScreen(show: $showSheet)
           SubscriptionScreen()
       }
         //*/
//        ZStack {
//            if showSheet {
//                SubscriptionScreen(show: $showSheet)
//                    .padding(.top, 100)
//                    .transition(.move(edge: .bottom))
//                    .animation(.spring())
//            }
//        }
//        .zIndex(2.0)
//        SubscriptionScreen(show: $showSheet)
//            .padding(.top, 100)
//            .offset(y: showSheet ? 0 : UIScreen.main.bounds.height)
//            .animation(.spring())
        
//        if showSheet {
//            SubscriptionScreen()
//                .transition(.move(edge: .bottom))
//                .animation(.spring())//, value: UUID())
//        }
    }

    @ViewBuilder
    private var versetoolbar: some View {
        NavigationLink {
            VersesStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        } label: {
            Image(systemName: "book.pages")
        }
    }

    @ViewBuilder
    private var searchablebooktoolbar: some View {
        NavigationLink {
            SearchableBibleStackView(bibleLines: bibleViewModel.bibleRawStringLines)
        } label: {
            Image(systemName: "book")
        }
    }

    @ViewBuilder
    private var bibleVersionsList: some View {
        ForEach(BibleVersion.allCases) { version in
            Button(version.title) {
                Task {
                    await bibleViewModel.fetchBooks(version: version)
                }
            }
        }
    }
}

struct CustomListData: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let titleDetail: String
}
struct SubscriptionScreen: View {
//    @Environment(\.presentationMode) var mode
//    @Binding var show: Bool
    
    var body: some View {
        /*
        ZStack(alignment: .topLeading) {
            Color.red.edgesIgnoringSafeArea(.all)
            Button {
                //mode.wrappedValue.dismiss()
                //show.toggle()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
            }
            
        }*/
        VStack {
            Image(systemName: "book")
                .frame(width: 120, height: 120, alignment: .center)
            Text("Subscribe to Bible")
                .font(.system(size: 36, weight: .medium))
            /// product list
            List {
                ProductRow(title: "One-time purchase", price: "$9.99", detailTitle: "")
                ProductRow(title: "Monthly", price: "$4.99", detailTitle: "7-day free trial")
                ProductRow(title: "Yearly", price: "$39.99", detailTitle: "7-day free trial")
            }
            .listStyle(.grouped)
            .frame(width: .infinity, height: 260, alignment: .center)
            /// features list
//            List {
                Text("Audio Bible")
                Text("Audio Bible")
                Text("Audio Bible")
                Text("Audio Bible")
//            }
            .scrollDisabled(true)
            Text("Audio Bible")
            Button("Restore Purchase") {
                print("BUY")
            }
            .buttonStyle(.bordered)
            Spacer()
        }
    }
}

struct ProductRow: View {
    let title: String
    let price: String
    let detailTitle: String
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 20, weight: .medium))
                    if !detailTitle.isEmpty {
                        Text(detailTitle)
                    }
                }
                Spacer()
                Text(price)
                    .font(.system(size: 20, weight: .medium))
            }
        }
        
        .padding(.horizontal)
    }
}
#Preview {
    BooksView(bibleViewModel: BibleViewModel())
    //SubscriptionScreen(show: true)
    //SubscriptionScreen()
}
