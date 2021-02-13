//
//  ThemeColor.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/08/23.
//

import SwiftUI

class ThemeColor: ObservableObject {
    
    static func mainColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? mainLight : mainDark
    }
    static func subColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? subLight : subDark
    }
    
    static func inActive(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? inActiveLight : inActiveDark
    }
    
    static func buttonInactive(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? buttonInactiveLight : buttonInactiveDark
    }
    
    static var colorList: [Color] = Palette.Default.allCases.map(\.color)
    
    static var brand = Color(hex: "#00629C")
    static var brandPressed = Color(hex: "#003A5C")
    
    static var buttonInactiveLight = Color(hex: "#F0F0F0")
    static var buttonInactiveDark = Color(hex: "#191919")
    
    private static var mainLight = Color(hex: "#5C5C5C")
    private static var mainDark = Color(hex: "#FFFFFF")
    private static var subLight = Color(hex: "#AAAAAA")
    private static var subDark = Color(hex: "#B0B0B0")
    private static var inActiveLight = Color(hex: "#F7F7F7")
    private static var inActiveDark = Color(hex: "#232323")
}

struct ThemeColor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                ForEach(
                    [ThemeColor.mainColor(.light), ThemeColor.subColor(.light), ThemeColor.inActive(.light)]
                    , id: \.self) { color in
                    Circle()
                        .frame(height: 50)
                        .foregroundColor(color)
                }
            }
            HStack {
                ForEach(
                    [ThemeColor.mainColor(.dark), ThemeColor.subColor(.dark), ThemeColor.inActive(.dark)]
                    , id: \.self) { color in
                    Circle()
                        .frame(height: 50)
                        .foregroundColor(color)
                }
            }
            .background(Color.black)
        }
    }
}
