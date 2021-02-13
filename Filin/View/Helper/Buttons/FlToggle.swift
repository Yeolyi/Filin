//
//  PaperToggle.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct FlToggle: View {
    
    @Binding var isOn: Bool
    @Environment(\.colorScheme) var colorScheme
    
    init(_ isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: ThemeColor.brand
                )
            )
    }
}

struct PaperToggle_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var isOn = false
        var body: some View {
            FlToggle($isOn)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}

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
        }
    }
}
