//
//  ListRow.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/09/18.
//

import SwiftUI

struct RowBackground: ViewModifier {
    
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
        content
            .padding(.top, innerVerticalPadding)
            .padding(.bottom, isInnerBottomPadding ? innerVerticalPadding : 0)
            .padding(.horizontal, 10)
            .background(
                Rectangle()
                    .foregroundColor(colorScheme == .light ? .white : Color(hex: "#151515"))
                    .cornerRadius(8)
                    .shadow(
                        color: (colorScheme == .light ? Color.gray.opacity(0.6) : .clear),
                        radius: 1.8, y: 1.28
                    )
            )
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, outerVerticalPadding)
    }
}

extension View {
    func rowBackground(innerBottomPadding: Bool = true, _ verticalPadding: CGFloat = 18,
                       _ outerVerticalPadding: CGFloat = 8, _ horizontalPadding: CGFloat = 10) -> some View {
        modifier(RowBackground(innerBottomPadding, verticalPadding, outerVerticalPadding, horizontalPadding))
    }
}

struct RowBackground_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitRow(habit: FlHabit(name: "Text"), showAdd: true)
        }
        .environmentObject(AppSetting())
        // .environment(\.colorScheme, .dark)
    }
}
