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
    
    init(_ isInnerBottomPadding: Bool) {
        self.isInnerBottomPadding = isInnerBottomPadding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.top, 18)
            .padding(.bottom, isInnerBottomPadding ? 18 : 0)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .if(colorScheme == .light) {
                        $0.foregroundColor(.white)
                            .shadow(
                                color: Color.gray.opacity(0.6),
                                radius: 1.8, y: 1.28
                            )
                    }
                    .if(colorScheme == .dark) {
                        $0.foregroundColor(.black)
                            .shadow(
                                color: Color.white.opacity(0.5),
                                radius: 1
                            )
                    }
                    
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
    }
}

extension View {
    func rowBackground(innerBottomPadding: Bool = true) -> some View {
        modifier(RowBackground(innerBottomPadding))
    }
}

struct RowBackground_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack(spacing: 0) {
                ForEach(0...4, id: \.self) { _ in
                    HabitRow(habit: FlHabit(name: "Text"), showAdd: true)
                }
            }
        }
        .environmentObject(AppSetting())
        .environment(\.colorScheme, .light)
        .previewDevice(.init(stringLiteral: "iPhone 12 Pro"))
        NavigationView {
            VStack(spacing: 0) {
                ForEach(0...4, id: \.self) { _ in
                    HabitRow(habit: FlHabit(name: "Text"), showAdd: true)
                }
            }
        }
        .environmentObject(AppSetting())
        .environment(\.colorScheme, .dark)
        .previewDevice(.init(stringLiteral: "iPhone 12 Pro"))
    }
}
