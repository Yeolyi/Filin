//
//  SmallSectionText.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/10.
//

import SwiftUI

struct SmallSectionText: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
                .bodyText()
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 24)
    }
}

extension View {
    func smallSectionText() -> some View {
        return modifier(SmallSectionText())
    }
}
