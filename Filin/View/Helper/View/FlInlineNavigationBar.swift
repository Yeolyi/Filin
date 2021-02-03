//
//  FlInlineNavigationBar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI

struct FlInlineNavigationBar<Bar: View, Content: View>: View {
    
    let bar: Bar
    let content: Content
    let barHeight: CGFloat = 70
    @Environment(\.colorScheme) var colorScheme
    
    init(@ViewBuilder bar: @escaping () -> Bar, @ViewBuilder content: @escaping () -> Content) {
        self.bar = bar()
        self.content =  content()
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 0) {
                    bar
                    .frame(height: barHeight)
                    Divider()
                }
                .compositingGroup()
                .background(
                    (colorScheme == .light ? Color.white : Color.black)
                        .edgesIgnoringSafeArea(.all)
                )
                Spacer()
            }
            .zIndex(1)
            content
                .padding(.top, barHeight)
                .zIndex(0)
        }
    }
}

struct FlInlineNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        FlInlineNavigationBar(bar: {
            Text("Bar")
        }) {
            List {
                ForEach(1...10, id: \.self) { i in
                    Text("\(i)")
                }
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
