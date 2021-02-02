//
//  DayOfWeekSelector.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct DayOfWeekSelector: View {
    
    @Binding var dayOfTheWeek: Set<Int>
    
    @Environment(\.colorScheme) var colorScheme
    
    init(dayOfTheWeek: Binding<Set<Int>>) {
        self._dayOfTheWeek = dayOfTheWeek
    }
    
    func isNextChecked(_ index: Int) -> Bool {
        dayOfTheWeek.contains(index) && dayOfTheWeek.contains(index + 1)
    }
    
    var guideStr: String {
        if dayOfTheWeek.count == 7 {
            return "Every day".localized
        } else {
            return dayOfTheWeek.sorted().map({Date.dayOfTheWeekStr($0)}).joined(separator: ", ")
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 5) {
                ForEach(1..<8) { dayOfTheWeekInt in
                    ZStack {
                        if dayOfTheWeek
                            .contains(dayOfTheWeekInt) {
                            Circle()
                                .mainColor()
                                .frame(width: 40, height: 40)
                        }
                        Text(Date.dayOfTheWeekShortStr(dayOfTheWeekInt))
                            .foregroundColor(
                                dayOfTheWeek.contains(dayOfTheWeekInt) ?
                                    Color.white :
                                    ThemeColor.mainColor(colorScheme)
                            )
                            .bodyText()
                    }
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        if dayOfTheWeek.contains(dayOfTheWeekInt) {
                            dayOfTheWeek.remove(at: dayOfTheWeek.firstIndex(of: dayOfTheWeekInt)!)
                        } else {
                            dayOfTheWeek.insert(dayOfTheWeekInt)
                        }
                    }
                }
            }
            Divider()
            Text(guideStr)
                .bodyText()
        }
    }
}

struct DayOfWeekSelector_Previews: PreviewProvider {
    
    struct PreviewWrapper: View {
        @State var dayOfWeek: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
        var body: some View {
            DayOfWeekSelector(dayOfTheWeek: $dayOfWeek)
        }
    }
    static var previews: some View {
        PreviewWrapper()
            .flatRowBackground()
    }
}
