//
//  NameSection.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/15.
//

import SwiftUI

struct HabitNameSection: View {
    
    @Binding var name: String
    let cardMode: CardMode
    
    init(name: Binding<String>, cardMode: CardMode) {
        self._name = name
        self.cardMode = cardMode
    }
    
    var body: some View {
        VStack(spacing: 3) {
            if case .compact = cardMode {
                Spacer()
                Text("Name".localized)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .smallSectionText()
            } else {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Getting Started\nwith a new Goal")
                        .foregroundColor(ThemeColor.brand)
                        .headline()
                        .lineSpacing(5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading], 10)
                Spacer()
                Text("Tell me the name of the goal.".localized)
                    .smallSectionText()
            }
            TextFieldWithEndButton(FlHabit.sample(number: 0).name, text: $name)
                .flatRowBackground()
            Spacer()
            if case .detail(let pageIndicator) = cardMode {
                Text(pageIndicator)
                    .bodyText()
            }
        }
    }
}
