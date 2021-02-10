//
//  ColorHorizontalPicker.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct ColorHorizontalPicker: View {
    
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            ForEach(ThemeColor.colorList, id: \.self) { color in
                Button(action: { self.selectedColor = color }) {
                    ZStack {
                        Circle()
                            .foregroundColor(color)
                            .frame(width: 40, height: 40)
                            .zIndex(0)
                        if selectedColor == color {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(color)
                                .brightness(0.2)
                                .zIndex(1)
                        }
                    }
                }
            }
        }
    }
}

struct ColorHorizontalPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorHorizontalPicker(selectedColor: .constant(.blue))
    }
}
