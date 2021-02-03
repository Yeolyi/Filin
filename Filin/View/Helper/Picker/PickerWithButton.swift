//
//  PickerWithButton.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct PickerWithButton: View {
    
    let str: String
    let size: Int
    @Binding var number: Int
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Picker(selection: $number, label: Text(""), content: {
                    ForEach(1..<size + 1, id: \.self) { num in
                        Text(String(num))
                            .bodyText()
                    }
                })
                .frame(width: 150, height: 150)
                .clipped()
                if str != "" {
                    Text(str.localized)
                        .bodyText()
                }
            }
        }
    }
}

struct PickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        PickerWithButton(str: "Hello", size: 100, number: .constant(10))
    }
}
