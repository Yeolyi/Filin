//
//  FlatRowBackground.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/27.
//

import SwiftUI

struct FlatRowBackground: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
                .background(ThemeColor.inActive(colorScheme))
        }
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
    }
}

extension View {
    func flatRowBackground() -> some View {
        modifier(FlatRowBackground())
    }
}

struct FlatRowBackground_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<4) {_ in
                    HStack {
                        Text("기본 탭 변경")
                        Spacer()
                    }
                    .flatRowBackground()
                }
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
