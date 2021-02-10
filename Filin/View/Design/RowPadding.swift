//
//  RowPadding.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct RowPadding: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        Group {
            VStack(spacing: 0) {
                content
                    .padding(.top, 21)
                    .padding(.bottom, 5)
            }
            .padding(.horizontal, 20)
        }
    }
}

extension View {
    func rowPadding(corners: UIRectCorner = .allCorners) -> some View {
        return modifier(RowPadding())
    }
}
