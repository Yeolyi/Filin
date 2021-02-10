//
//  TimerPicker.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct TimerPicker: View {
    
    @Binding var minute: Int
    @Binding var second: Int
    
    var body: some View {
        HStack {
            VStack {
                Picker(selection: $minute, label: EmptyView(), content: {
                    ForEach(0...500, id: \.self) { minute in
                        Text(String(minute))
                            .bodyText()
                    }
                })
                .frame(width: 150, height: 150)
                .clipped()
                .accessibility(identifier: "minute")
                Text("Minute".localized)
                    .bodyText()
            }
            VStack {
                Picker(selection: $second, label: EmptyView(), content: {
                    ForEach(0...59, id: \.self) { second in
                        Text(String(second))
                            .bodyText()
                    }
                })
                .frame(width: 150, height: 150)
                .accessibility(identifier: "second")
                .clipped()
                Text("Second".localized)
                    .bodyText()
            }
        }
        .padding(.bottom, 5)
    }
}

struct TimerPicker_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var minute = 0
        @State var second = 0
        var body: some View {
            TimerPicker(minute: $minute, second: $second)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
