//
//  Utilities.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/12/26.
//

import Foundation
import UIKit

class Storage: NSObject {
    static func archiveStringArray(object: [SaveLine]) -> Data {
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: object,
                requiringSecureCoding: false)
                return data
        } catch {
            fatalError("Can't encode data: \(error)")
        }
    }

    static func loadStringArray(data: Data) -> [SaveLine] {
        do {
            let allowedClasses = [NSArray.self, SaveLine.self]
            guard let array = try NSKeyedUnarchiver.unarchivedObject(
                ofClasses: allowedClasses,
                from: data) as? [SaveLine] else { return []
            }
            return array
        } catch {
            return []
//            fatalError("loadWStringArray - Can't encode data: \(error)")
        }
    }
}
class SaveLine:  NSObject, NSSecureCoding {
    func encode(with coder: NSCoder) {
        coder.encode(book, forKey: "book")
        coder.encode(chapterNum, forKey: "chapterNum")
        coder.encode(verseNum, forKey: "verseNum")
        coder.encode(verse, forKey: "verse")
    }

    required init?(coder: NSCoder) {
        book = coder.decodeObject(
            forKey: "book") as! String
        chapterNum = coder.decodeObject(
            forKey: "chapterNum") as! String
        verseNum = coder.decodeObject(
            forKey: "verseNum") as! String
        verse = coder.decodeObject(
            forKey: "verse") as! String
    }
    init(
        book: String,
        chapterNum: String,
        verseNum: String,
        verse: String) {

        self.book = book
        self.chapterNum = chapterNum
        self.verseNum = verseNum
        self.verse = verse
    }
    static var supportsSecureCoding: Bool {
        return true
    }
    let book: String
    let chapterNum: String
    let verseNum: String
    let verse: String
    var composite: String {
        return "\(book) \(chapterNum) \(verseNum)"
    }
}
