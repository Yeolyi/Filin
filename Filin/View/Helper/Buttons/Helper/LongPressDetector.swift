//
//  LongPressWithTap.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/12.
//

import SwiftUI

struct LongPressDetector: ViewModifier {
    
    @Binding var isPressed: Bool
    let action: () -> Void
    
    init(isPressed: Binding<Bool>, action: @escaping () -> Void) {
        self._isPressed = isPressed
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onLongPressGesture(minimumDuration: 100, pressing: { isPressing in
                self.isPressed = isPressing
            }, perform: {})
            .simultaneousGesture(
                TapGesture()
                    .onEnded { action() }
            )
    }
}

extension View {
    func longPressDetector(isPressed: Binding<Bool>, action: @escaping () -> Void) -> some View {
        modifier(LongPressDetector(isPressed: isPressed, action: action))
    }
}
