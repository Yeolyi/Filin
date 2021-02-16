//
//  ColorSection.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/15.
//

import SwiftUI

struct ColorSection: View {

    @Binding var color: Color
    let cardMode: CardMode
    
    init(color: Binding<Color>, cardMode: CardMode) {
        self._color = color
        self.cardMode = cardMode
    }
    
    var body: some View {
        VStack(spacing: 3) {
            Spacer()
            if case .compact = cardMode {
                Text("Theme".localized)
                    .smallSectionText()
            } else {
                Text("Choose a color that matches your goal.".localized)
                    .smallSectionText()
            }
            ColorHorizontalPicker(selectedColor: $color)
                .frame(maxWidth: .infinity)
                .flatRowBackground()
            Spacer()
            if case .detail(let pageIndicator) = cardMode {
                Text(pageIndicator)
                    .bodyText()
            }
        }
    }
}
