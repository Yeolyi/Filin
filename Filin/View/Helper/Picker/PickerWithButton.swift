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
            HStack {
                Text(str.localized)
                    .bodyText()
                Spacer()
            }
            HStack {
                Picker(selection: $number, label: Text(""), content: {
                    ForEach(1..<size + 1, id: \.self) { num in
                        Text(String(num))
                            .bodyText()
                    }
                })
                .frame(width: 200, height: 150)
                .clipped()
                VStack(spacing: 48) {
                    BasicButton("chevron.left.2") {
                        withAnimation {
                            number = max(1, number - 25)
                        }
                    }
                    .rotationEffect(.init(degrees: 90))
                    BasicButton("chevron.right.2") {
                        withAnimation {
                            number = min(size, number + 25)
                        }
                    }
                    .rotationEffect(.init(degrees: 90))
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
