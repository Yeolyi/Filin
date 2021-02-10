//
//  ColoredToggle.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/27.
//

import SwiftUI

struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
            Button(action: {
                withAnimation {
                    configuration.isOn.toggle()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
    }
}
