//
//  BibleVersion.swift
//  BibleReader
//
//  Created by Kevin Remigio on 10/19/26.
//

import SwiftUI
enum BibleVersion: String, CaseIterable, Identifiable {
    var id: Self { self }
    case catholic = "catholic_public_domain_version_bible"
    case kingjames = "king_james_version_bible"
    case americanstandard = "american_standard_version"
    case worldenglish = "world_english_bible"
    case smithsliteral = "smiths_literal_translation"
    case americankingjames = "american_king_james_version"
    
    var title: String {
        switch self {
        case .catholic: return "Catholic Public Domain"
        case .kingjames: return "King James Version"
        case .americanstandard: return "American Standard Version"
        case .worldenglish: return "World English Bible"
        case .smithsliteral: return "Smith's Literal Version"
        case .americankingjames: return "American King James Version"
        }
    }
    var oldTestamentCount: Int {
        return 39
    }
    var newTestamentCount: Int {
        switch self {
        case .catholic: return 27
        case .kingjames: return 28
        case .americanstandard: return 27
        case .worldenglish: return  28
        case .smithsliteral: return 27
        case .americankingjames: return 27
        }
    }
}
