//
//  AppIcon.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/11.
//

import SwiftUI

struct AppIcon: View {
    
    let circleTrim: CGFloat = 0.77
    var pointAngle: CGFloat {
        let remainAngle: CGFloat = 2 * CGFloat.pi * (1 - circleTrim)
        let angle = CGFloat.pi / 2 - remainAngle / 2
        return tan(angle)
    }
    
    var body: some View {
        GeometryReader { geo in
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#00629C").opacity(0.8), Color(hex: "#00629C")]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .mask(
                ZStack {
                    Circle()
                        .trim(from: 0, to: circleTrim)
                        .stroke(style: StrokeStyle(lineWidth: geo.size.width * 0.1, lineCap: .round))
                        .rotationEffect(.degrees(270))
                        .padding(geo.size.width * 0.25)
                        .foregroundColor(.white)
                    Circle()
                        .frame(width: geo.size.width * 0.165)
                        .foregroundColor(.white)
                        .offset(x: -geo.size.width*0.16, y: -geo.size.width*0.15 * pointAngle)
                    
                }
            )
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
            AppIcon()
                .background(Color.white)
                .padding(20)
        }
    }
}
