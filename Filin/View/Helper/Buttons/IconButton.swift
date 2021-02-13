//
//  IconButton.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/12.
//

import SwiftUI

struct IconButton: View {
    
    @State var isPressed = false
    
    let imageName: String
    let isActive: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(imageName: String, isActive: Bool = true, action: @escaping () -> Void) {
        self.imageName = imageName
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
        Image(systemName: imageName)
            .font(.system(size: FontSize.label.rawValue, weight: .bold))
            .frame(height: ButtonSize.small.rawValue)
            .frame(minWidth: ButtonSize.medium.rawValue)
            .foregroundColor(color)
            .contentShape(Rectangle())
            .if(isActive) {
                $0.longPressDetector(isPressed: $isPressed, action: action)
            }
    }
}

struct IconButtonWithoutGesture: View {
    
    let imageName: String
    let isActive: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(imageName: String, isActive: Bool = true, action: @escaping () -> Void) {
        self.imageName = imageName
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View {
        Image(systemName: imageName)
            .font(.system(size: FontSize.label.rawValue, weight: .bold))
            .frame(height: ButtonSize.small.rawValue)
            .frame(minWidth: ButtonSize.medium.rawValue)
            .foregroundColor(ThemeColor.subColor(colorScheme))
            .contentShape(Rectangle())
            .if(isActive) {
                $0.onTapGesture {
                    action()
                }
            }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(imageName: "plus", isActive: true, action: {})
    }
}
