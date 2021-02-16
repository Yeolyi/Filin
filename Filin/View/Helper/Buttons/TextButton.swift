//
//  TextButton.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/12.
//

import SwiftUI

struct TextButton<Content: View>: View {
    
    @State var isPressed = false
    
    let content: Content
    let isActive: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(content: @escaping () -> Content, isActive: Bool = true, action: @escaping () -> Void) {
        self.content = content()
        self.isActive = isActive
        self.action = action
    }
    
    var color: Color {
        if !isActive {
            return ThemeColor.subColor(colorScheme).opacity(0.3)
        }
        return isPressed ? ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
    }
    
    var body: some View {
        content
            .foregroundColor(color)
            .font(.system(size: FontSize.label.rawValue, weight: .bold))
            .frame(height: ButtonSize.small.rawValue)
            .frame(minWidth: ButtonSize.medium.rawValue)
            .contentShape(Rectangle())
            .if(isActive) {
                $0.longPressDetector(isPressed: $isPressed, action: action)
            }
    }
}

struct TextButtonWithoutGesture<Content: View>: View {
    
    @State var isPressed = false
    
    let content: Content
    let isActive: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(content: @escaping () -> Content, isActive: Bool = true, action: @escaping () -> Void) {
        self.content = content()
        self.isActive = isActive
        self.action = action
    }
    
    var color: Color {
        if !isActive {
            return ThemeColor.subColor(colorScheme)
        }
        return isPressed ? ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
    }
    
    var body: some View {
        content
            .foregroundColor(color)
            .font(.system(size: FontSize.label.rawValue, weight: .bold))
            .frame(height: ButtonSize.small.rawValue)
            .frame(minWidth: ButtonSize.medium.rawValue)
            .contentShape(Rectangle())
            .if(isActive) {
                $0.onTapGesture {
                    action()
                }
            }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(content: { Text("편집") }, isActive: false, action: {})
    }
}
