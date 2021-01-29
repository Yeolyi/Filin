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
                .headline()
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
