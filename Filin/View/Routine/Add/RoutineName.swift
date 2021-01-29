//
//  1_RoutineName.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/10.
//

import SwiftUI

struct RoutineName: View {
    
    @Binding var name: String
    
    var body: some View {
        VStack(spacing: 0) {
            LottieView(filename: "lottieStack")
                .frame(width: 130, height: 130)
                .padding(.bottom, 5)
                .padding(.top, 21)
            Text("Add routine".localized)
                .title()
                .padding(.bottom, 89)
            VStack {
                HStack {
                    Text("Name".localized)
                        .bodyText()
                    Spacer()
                }
                .padding(.leading, 20)
                TextFieldWithEndButton("After wake up".localized, text: $name)
                    .rowBackground()
            }
        }
    }
}

struct RoutineName_Previews: PreviewProvider {
    static var previews: some View {
        RoutineName(name: .constant(""))
    }
}
