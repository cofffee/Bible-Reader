//
//  Extensions.swift
//  BibleReader
//
//  Created by Kevin Remigio on 7/11/25.
//

import Foundation

extension Array {
    subscript(checked index: Int) -> Element? {
        guard index < endIndex, index >= startIndex else {
            return nil
        }
        return self[index]
    }
}
