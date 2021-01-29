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
        GeometryReader { geo in
            HStack {
                VStack {
                    Picker(selection: $minute, label: EmptyView(), content: {
                        ForEach(0...500, id: \.self) { minute in
                            Text(String(minute))
                                .bodyText()
                        }
                    })
                    .frame(height: 170)
                    .frame(maxWidth: geo.size.width/2 - 10)
                    .clipped()
                    Text("Minute")
                        .bodyText()
                }
                VStack {
                    Picker(selection: $second, label: EmptyView(), content: {
                        ForEach(0...59, id: \.self) { second in
                            Text(String(second))
                                .bodyText()
                        }
                    })
                    .frame(height: 170)
                    .frame(maxWidth: geo.size.width/2 - 10)
                    .clipped()
                    Text("Second")
                        .bodyText()
                }
            }
        }
        .frame(height: 200)
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
