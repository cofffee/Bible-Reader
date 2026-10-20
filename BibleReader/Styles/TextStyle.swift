//
//  TextStyle.swift
//  BibleReader
//
//  Created by Kevin Remigio on 9/23/26.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    let fontSize: CGFloat
    @AppStorage("Font") var defaultFont: String?
    
    func body(content: Content) -> some View {
        content
            .font(.custom(defaultFont ?? "SF Pro", size: fontSize))
            .fontWeight(.bold)
    }
}
struct BodyStyle: ViewModifier {
    @AppStorage("Font") var defaultFont: String?
    @AppStorage("BodyFontSize") var bodyFontSize: Double?
    let fontSize: CGFloat
    func body(content: Content) -> some View {
        if let sizeDouble = bodyFontSize {
            content
                .font(.custom(defaultFont ?? "SF Pro", size: CGFloat(sizeDouble)))
        } else {
            content
                .font(.custom(defaultFont ?? "SF Pro", size: fontSize))
        }
        
    }
}

extension Text {
    func titleStyle(fontSize: CGFloat = 28) -> some View {
        modifier(TitleStyle(fontSize: fontSize))
    }
    func bodyStyle(fontSize: CGFloat = 17) -> some View {
        modifier(BodyStyle(fontSize: fontSize))
    }

}


extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
