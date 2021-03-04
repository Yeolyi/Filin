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
        VStack(spacing: 20) {
            Text("Preview".localized)
                .bodyText()
                .frame(maxWidth: .infinity, alignment: .leading)
            Circle()
                .trim(from: 0.0, to: 0.7)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round))
                .foregroundColor(selectedColor)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 100, height: 100)
            Divider()
            VStack(spacing: 15) {
                ForEach(Palette.allCases, id: \.name) { theme in
                    VStack(spacing: 3) {
                        Text(theme.name)
                            .bodyText()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 3)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(theme.colors, id: \.self) { color in
                                    Button(action: {
                                        withAnimation {
                                            self.selectedColor = color
                                        }
                                    }) {
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
                }
            }
        }
    }
}

struct ColorHorizontalPicker_Previews: PreviewProvider {
    private struct ColorHorizontalPickerWrapper: View {
        @State var selectedColor = Palette.allCases[0].colors[0]
        var body: some View {
            ColorHorizontalPicker(selectedColor: $selectedColor)
                .rowBackground()
        }
    }
    static var previews: some View {
        ColorHorizontalPickerWrapper()
    }
}
