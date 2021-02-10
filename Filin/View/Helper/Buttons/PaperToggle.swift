//
//  PaperToggle.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct PaperToggle: View {
    
    @Binding var isOn: Bool
    @Environment(\.colorScheme) var colorScheme
    
    init(_ isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: ThemeColor.mainColor(colorScheme)
                )
            )
    }
}

struct PaperToggle_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var isOn = false
        var body: some View {
            PaperToggle($isOn)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
