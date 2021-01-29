//
//  Test4.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct ThemeSection: View {
    
    @Binding var color: Color
    
    var body: some View {
        HabitAddBadgeView(title: "Theme".localized, imageName: "paintpalette") {
            HStack {
                Text("Select theme color.".localized)
                    .bodyText()
                Spacer()
            }
            .padding(.leading, 20)
            ColorHorizontalPicker(selectedColor: $color)
                .padding(.top, 21)
                .padding(.leading, 20)
        }
    }
}

struct Test4_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSection(color: .constant(.blue))
    }
}
