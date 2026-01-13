//
//  Utilities.swift
//  BibleReader
//
//  Created by Kevin Remigio on 1/12/26.
//

import Foundation
import UIKit

class Storage: NSObject {
    static func archiveStringArray(object: [String]) -> Data {
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: object,
                requiringSecureCoding: false)
                return data
        } catch {
            fatalError("Can't encode data: \(error)")
        }
    }

    static func loadStringArray(data: Data) -> [String] {
        do {
            let allowedClasses = [NSArray.self, NSString.self]
            guard let array = try NSKeyedUnarchiver.unarchivedObject(
                ofClasses: allowedClasses,
                from: data) as? [String] else { return []
            }
            return array
        } catch {
            return []
//            fatalError("loadWStringArray - Can't encode data: \(error)")
        }
    }
}
