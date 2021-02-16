//
//  RepeatSection.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/15.
//

import SwiftUI

struct RepeatSection: View {
    
    let cardMode: CardMode
    
    @Binding var dayOfWeek: Set<Int>
    @EnvironmentObject var appSetting: AppSetting
    
    var pageIndicator: String? {
        if case .detail(let str) = cardMode {
            return str
        } else {
            return nil
        }
    }
    
    init(cardMode: CardMode, dayOfWeek: Binding<Set<Int>>) {
        self.cardMode = cardMode
        self._dayOfWeek = dayOfWeek
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            if case .detail = cardMode {
                Text("Choose the day of the week to repeat your goal.".localized)
                    .bodyText()
                    .lineLimit(nil)
                    .padding(.bottom, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 10) {
                ForEach(
                    appSetting.isMondayStart ? [2, 3, 4, 5, 6, 7, 1] : [1, 2, 3, 4, 5, 6, 7],
                    id: \.self
                ) { dayOfWeekInt in
                    TextButton(content: {
                        HStack {
                            Text(Date.dayOfTheWeekStr(dayOfWeekInt))
                                .bodyText()
                            Spacer()
                            if dayOfWeek.contains(dayOfWeekInt) {
                                IconButtonWithoutGesture(imageName: "checkmark") { }
                            }
                        }
                    }) {
                        if dayOfWeek.contains(dayOfWeekInt) {
                            dayOfWeek.remove(dayOfWeekInt)
                        } else {
                            dayOfWeek.insert(dayOfWeekInt)
                        }
                    }
                    Divider()
                }
            }
            .padding(.horizontal, 10)
            Spacer()
            if pageIndicator != nil {
                Text(pageIndicator!)
                    .bodyText()
            }
        }
    }
}
