//
//  SubscriptionScreenView.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/12/26.
//

import SwiftUI

struct CustomListData: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let titleDetail: String
}
struct SubscriptionScreenView: View {
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
                    .foregroundrr(.white)
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
    SubscriptionScreenView()
}
