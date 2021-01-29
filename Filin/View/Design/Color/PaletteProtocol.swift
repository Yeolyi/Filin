//
//  PaletteProtocol.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

protocol PaletteComponent: RawRepresentable, CaseIterable where RawValue == String {
    
    var color: Color { get }
}

extension PaletteComponent {
    var color: Color {
        Color(hex: self.rawValue)
    }
}
