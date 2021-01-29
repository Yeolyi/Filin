//
//  CircleProgress.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CircleProgress<Content: View>: View {
    
    let ringGroup: RingGroup
    let content: Content
    let expanded: Bool
    @State var isAnimation = false
    
    init(_ ringGroup: RingGroup, @ViewBuilder content: @escaping () -> Content) {
        self.ringGroup = ringGroup
        if ringGroup[raw: 1] != nil || ringGroup[raw: 2] != nil {
            expanded = true
        } else {
            expanded = false
        }
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if expanded {
                content
                    .padding(.bottom, 5)
                    .padding(.top, 8)
            }
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .trim(from: 0.0, to: CGFloat(ringGroup[index].progress))
                        .stroke(style: StrokeStyle(lineWidth: 5.0 - CGFloat(index) * 0.5))
                        .foregroundColor(ringGroup[index].color)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(isAnimation ? .linear : nil)
                        .frame(width: 40 - CGFloat(index * 12), height: 40 - CGFloat(index * 12))
                }
                .zIndex(0)
                if !expanded {
                    content
                }
                if ringGroup.isEmpty && expanded {
                    Circle()
                        .subColor()
                        .opacity(0.3)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnimation = true
            }
        }
    }
}

struct CircleProgress_Previews: PreviewProvider {
    @Environment(\.colorScheme) var colorScheme
    static var previews: some View {
        CircleProgress(RingGroup([Ring(0.3, .blue)])) {
            Text("15")
        }
    }
}
