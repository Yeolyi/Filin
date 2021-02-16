//
//  TimerSection.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/15.
//

import SwiftUI

struct HabitTimerSection: View, Equatable {
    
    static func == (lhs: HabitTimerSection, rhs: HabitTimerSection) -> Bool {
        lhs.requiredSec == rhs.requiredSec
    }
    
    @Binding var requiredSec: Int
    let cardMode: CardMode
    
    init(requiredSec: Binding<Int>, cardMode: CardMode) {
        self._requiredSec = requiredSec
        self.cardMode = cardMode
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                if case .compact = cardMode {
                    Text("Timer".localized)
                        .smallSectionText()
                } else {
                    Text("Should I prepare a timer when you perform this goal?".localized)
                        .smallSectionText()
                }
                Spacer()
            }
            HabitTimerSetting(requiredSec: $requiredSec)
            Spacer()
            if case .detail(let pageIndicator) = cardMode {
                Text(pageIndicator)
                    .bodyText()
            }
        }
    }
}
