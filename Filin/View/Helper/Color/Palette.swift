//
//  Palette.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

struct Palette {

    enum Default: String, PaletteComponent {
        case red = "#f07264"
        case orange = "#f5ad60"
        case green = "#83d378"
        case blue = "#5996f8"
        case purple = "#b57ddf"
        case pink = "#FE7F9C"
    }
    
    enum Classic: String, PaletteComponent {
        case red = "#DD4124"
        case orange = "#FF6F61"
        case yellow = "#F5E050"
        case green = "#45B5AA"
        case blue = "#0F4C81"
        case purple = "#5F4B8B"
        case gray = "#8C8C8C"
    }
    
    static var allCases: [(name: String, colors: [Color])] {
        [("Default".localized, Default.allCases.map(\.color)), ("Classic".localized, Classic.allCases.map(\.color))]
    }
    
}
