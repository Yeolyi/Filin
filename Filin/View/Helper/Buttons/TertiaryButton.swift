//
//  TertiaryButton.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/12.
//

import SwiftUI

struct TertiaryButton<Content: View>: View {
    @State var isPressing = false
    let content: () -> Content
    let isActive: Bool
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(content: @escaping () -> Content, isActive: Bool = true, action: @escaping () -> Void) {
        self.content = content
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View {
        content()
            .foregroundColor(isPressing ?  ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme))
            .bodyText()
            .frame(maxWidth: .infinity)
            .frame(height: ButtonSize.small.rawValue)
            .contentShape(Rectangle())
            .if(isActive) {
                $0.longPressDetector(isPressed: $isPressing, action: action)
            }
    }
}

struct TertiaryButton_Previews: PreviewProvider {
    static var previews: some View {
        TertiaryButton(content: { Text("Tertiary Button") }) { }
    }
}
