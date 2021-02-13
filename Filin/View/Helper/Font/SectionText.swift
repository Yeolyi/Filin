//
//  SectionText.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/19.
//

import SwiftUI

/// Substitutes SwiftUI list section header
struct SectionText: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
                .font(.system(size: FontSize.subHeadline.rawValue, weight: .bold))
                .mainColor()
            Spacer()
        }
        .padding(.top, 21)
        .padding(.leading, 20)
    }
}

extension View {
    func sectionText() -> some View {
        return modifier(SectionText())
    }
}
