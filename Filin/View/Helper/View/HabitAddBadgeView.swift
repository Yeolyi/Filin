//
//  HabitAddBadgeView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct HabitAddBadgeView<Content: View>: View {
    let title: String
    let imageName: String
    let content: Content
    @Environment(\.colorScheme) var colorScheme
    init(title: String, imageName: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.imageName = imageName
        self.content = content()
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image(systemName: imageName)
                    .font(.system(size: 63))
                    .mainColor()
                    .padding(.bottom, 13)
                    .padding(.top, 55)
                Text(title)
                    .title()
                    .padding(.bottom, 89)
                Spacer()
                content
                Spacer()
            }
        }
    }
}

struct HabitAddBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        HabitAddBadgeView(title: "Preview", imageName: "gear") {
            Text("Test")
        }
    }
}
