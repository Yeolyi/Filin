//
//  TimerPicker.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct FlTimePicker: View {
    
    @Binding var requiredSec: Int
    
    var minute: Binding<Int> {
        Binding(
            get: {
                requiredSec / 60
            }, set: {
                requiredSec = $0 * 60 + second.wrappedValue
            }
        )
    }
    
    var second: Binding<Int> {
        Binding(
            get: {
                requiredSec % 60
            }, set: {
                requiredSec = minute.wrappedValue * 60 + $0
            }
        )
    }
    
    init(requiredSec: Binding<Int>) {
        self._requiredSec = requiredSec
    }
    
    var body: some View {
        HStack {
            VStack {
                Picker(selection: minute, label: EmptyView(), content: {
                    ForEach(0...500, id: \.self) { minute in
                        Text(String(minute))
                            .bodyText()
                    }
                })
                .frame(width: 150, height: 150)
                .clipped()
                Text("Minute".localized)
                    .bodyText()
            }
            VStack {
                Picker(selection: second, label: EmptyView(), content: {
                    ForEach(0...59, id: \.self) { second in
                        Text(String(second))
                            .bodyText()
                    }
                })
                .frame(width: 150, height: 150)
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
        @State var requiredSec = 0
        var body: some View {
            FlTimePicker(requiredSec: $requiredSec)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
