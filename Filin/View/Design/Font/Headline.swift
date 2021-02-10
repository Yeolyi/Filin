//
//  RowHeadline.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/19.
//

import SwiftUI

struct Headline: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.custom("GodoB", size: 24))
            .mainColor()
    }
}

extension View {
    func headline() -> some View {
        return modifier(Headline())
    }
}
