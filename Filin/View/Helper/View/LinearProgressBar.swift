//
//  ColorGauge.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct LinearProgressBar: View {
    let color: Color
    let progress: Double
    @State var isAnimation = false
    @Environment(\.colorScheme) var colorScheme
    init(color: Color, progress: Double) {
        self.color = color
        self.progress = max(0, min(progress, 1))
    }
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .foregroundColor(color)
                .frame(width: CGFloat(progress) * geo.size.width + (progress == 0 ? 5 : 0), height: 24)
                .offset(x: 2, y: 4)
                .if(isAnimation) {
                    $0.animation(.default)
                }
        }
        .frame(height: 24)
        .overlay(
            Rectangle()
                .stroke(ThemeColor.mainColor(colorScheme), lineWidth: 1.5)
        )
        .onAppear {
            self.isAnimation = true
        }
    }
}

struct LinearProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgressBar(color: .blue, progress: 0.4)
            .padding(10)
    }
}
