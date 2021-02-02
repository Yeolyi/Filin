//
//  FlatRowBackground.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/27.
//

import SwiftUI

struct FlatRowBackground: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    let isInnerBottomPadding: Bool
    let innerVerticalPadding: CGFloat
    let outerVerticalPadding: CGFloat
    let horizontalPadding: CGFloat
    
    init(_ isInnerBottomPadding: Bool, _ verticalPadding: CGFloat,
         _ outerVerticalPadding: CGFloat, _ horizontalPadding: CGFloat) {
        self.isInnerBottomPadding = isInnerBottomPadding
        self.innerVerticalPadding = verticalPadding
        self.outerVerticalPadding = outerVerticalPadding
        self.horizontalPadding = horizontalPadding
    }
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
                .padding(.top, innerVerticalPadding)
                .padding(.bottom, isInnerBottomPadding ? innerVerticalPadding : 0)
                .padding(.horizontal, 10)
                .background(ThemeColor.inActive(colorScheme).opacity(0.5))
        }
        .cornerRadius(5)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, outerVerticalPadding)
    }
}

extension View {
    func flatRowBackground(
        innerBottomPadding: Bool = true, _ verticalPadding: CGFloat = 20,
        _ outerVerticalPadding: CGFloat = 4, _ horizontalPadding: CGFloat = 10
    ) -> some View {
        modifier(FlatRowBackground(innerBottomPadding, verticalPadding, outerVerticalPadding, horizontalPadding))
    }
}

struct FlatRowBackground_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach(0..<4) {_ in
                HStack {
                    Text("기본 탭 변경")
                    Spacer()
                }
                .flatRowBackground()
            }
        }
        .environmentObject(AppSetting())
    }
}
