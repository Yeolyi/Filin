//
//  PrimaryButton.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/11.
//

import SwiftUI

struct PrimaryButton: View {
    
    @State var isPressing = false
    let label: String
    let isActive: Bool
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(label: String, isActive: Bool = true, action: @escaping () -> Void) {
        self.label = label
        self.isActive = isActive
        self.action = action
    }
    
    var backgroundColor: Color {
        if isActive {
            if isPressing {
                return ThemeColor.brandPressed
            } else {
                return ThemeColor.brand
            }
        } else {
            return ThemeColor.buttonInactive(colorScheme)
        }
    }
    
    var body: some View {
        ZStack {
            Text(label)
                .foregroundColor(.white)
                .font(.custom("GodoB", size: FontSize.subHeadline.rawValue))
                .zIndex(1)
            Rectangle()
                .foregroundColor(backgroundColor)
                .frame(height: ButtonSize.large.rawValue)
                .clipShape(Capsule())
        }
        .contentShape(Rectangle())
        .if(isActive) {
            $0.longPressDetector(isPressed: $isPressing, action: action)
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(label: "Primary Button", isActive: true, action: {})
            .padding(.horizontal, 20)
    }
}
