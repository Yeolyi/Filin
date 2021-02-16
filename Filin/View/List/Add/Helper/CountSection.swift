//
//  CountSection.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/15.
//

import SwiftUI

struct HabitCountSection: View {
    
    @ObservedObject var tempHabit: FlHabit
    let cardMode: CardMode
    
    init(tempHabit: FlHabit, cardMode: CardMode) {
        self.tempHabit = tempHabit
        self.cardMode = cardMode
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                if case .compact = cardMode {
                    Text("Number of Times".localized)
                        .smallSectionText()
                } else {
                    Text("How many times a day will you do it?".localized)
                        .smallSectionText()
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            HabitNumberSetting(tempHabit)
            Spacer()
            if case .detail(let pageIndicator) = cardMode {
                Text(pageIndicator)
                    .bodyText()
            }
        }
    }
}
