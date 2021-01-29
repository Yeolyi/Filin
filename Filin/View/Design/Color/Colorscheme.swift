//
//  Colorscheme.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct MainColor: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeColor.mainColor(colorScheme))
    }
}

extension View {
    func mainColor() -> some View {
        return modifier(MainColor())
    }
}

struct SubColor: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeColor.subColor(colorScheme))
    }
}

extension View {
    func subColor() -> some View {
        return modifier(SubColor())
    }
}
