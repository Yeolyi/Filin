//
//  TextFieldWithEndButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct TextFieldWithEndButton: View {
    let titleKey: String
    @State var isEditing = false
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    init(_ titleKey: String, text: Binding<String>) {
        self.titleKey = titleKey
        self._text = text
    }
    var body: some View {
        HStack {
            TextField(titleKey, text: $text, onEditingChanged: { (changed) in
                if changed {
                    isEditing = true
                } else {
                    isEditing = false
                }
            }) {
                isEditing = false
            }
            if isEditing {
                Button(action: {
                    UIApplication.shared.endEditing()
                    isEditing = false
                }) {
                    Text("Done".localized)
                        .foregroundColor(ThemeColor.mainColor(colorScheme))
                }
            }
        }
    }
}
