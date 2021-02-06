//
//  ListEmptyButton.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct MainRectButton: View {
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void
    let str: String
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(str)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .bodyText()
                    .padding(13)
                Spacer()
            }
        }
        .background(
            Rectangle()
                .foregroundColor(ThemeColor.mainColor(colorScheme))
                .cornerRadius(5)
        )
        .padding(.horizontal, 10)
    }
}

struct ListEmptyButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainRectButton(action: {}, str: "Add new calendar")
            MainRectButton(action: {}, str: "Add new calendar")
                .environment(\.colorScheme, .dark)
        }
    }
}
