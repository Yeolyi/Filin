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
    
    static var colorList: [Color] = Palette.Default.allCases.map(\.color)
    
    private static var mainLight = Color(hex: "#404040")
    private static var mainDark = Color(hex: "#BFBFBF")
    private static var subLight = Color(hex: "#BEBEBE")
    private static var subDark = Color(hex: "#414141")
}

extension UIColor {
    var hue: CGFloat {
        var hue: CGFloat = 0
        self.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
}
extension Color {
    var hue: CGFloat {
        self.uiColor().hue
    }
    private func uiColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }
        let scanner = Scanner(string: description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000FF) / 255
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
    var hex: String {
        let components = self.uiColor().cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let hexString = String.init(
            format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255))
        )
        return hexString
    }
}
