//
//  BibleModel.swift
//  BibleReader
//
//  Created by Kevin Remigio on 7/11/25.
//

import Foundation

struct BibleModel: Identifiable, Hashable, Equatable {
    let id: String = UUID().uuidString
    var books: [BookModel]
    var version: BibleVersion
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
struct BookModel: Identifiable, Hashable, Equatable {
    let id: String = UUID().uuidString
    let name: String
    var chapters: [ChapterModel]
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: BookModel, rhs: BookModel) -> Bool {
        return lhs.id == rhs.id
    }
}
struct ChapterModel: Identifiable, Hashable, Equatable {
    let id: String = UUID().uuidString
    let book: String
    let number: String
    var verses: [VerseModel]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: ChapterModel, rhs: ChapterModel) -> Bool {
        return lhs.id == rhs.id
    }
}
struct VerseModel: Identifiable, Hashable, Equatable {
    let id: String = UUID().uuidString
    let number: String
    let verse: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: VerseModel, rhs: VerseModel) -> Bool {
        return lhs.id == rhs.id
    }
}
