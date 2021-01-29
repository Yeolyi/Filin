//
//  SmallWidget.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import SwiftUI
import WidgetKit

struct HabitWidgetEntryView: View {
    
    var entry: Provider.Entry
    let habitData: HabitWidgetData?
    
    var isNextDay: Bool {
        habitData?.day != mainDate.day
    }
    @Environment(\.colorScheme) var colorScheme
    
    /// 다음 날 정보를 보여줄 시간 설정. 시간 단위. 기본값 0(24시)
    @AutoSave("dayResetTime", defaultValue: 0)
    var dayResetTime: Int 

    var mainDate: Date {
        if Date().hour >= dayResetTime {
            return Date()
        } else {
            return Date().addDate(-1)!
        }
    }
    
    init(entry: Provider.Entry) {
        self.entry = entry
        habitData = WidgetBridge.todayAchievements.first(
            where: {
                $0.id.uuidString == entry.configuration.habit?.identifier
            })
    }
    
    var body: some View {
        if habitData == nil {
            EmptyPlaceholder()
        } else {
            VStack {
                Spacer()
                if habitData!.current < habitData!.numberOfTimes {
                    ZStack {
                        Circle()
                            .trim(
                                from: 0.0,
                                to: isNextDay ? 0 : CGFloat(habitData!.current) / CGFloat(habitData!.numberOfTimes)
                            )
                            .stroke(style: StrokeStyle(lineWidth: 9.0))
                            .foregroundColor(Color(hex: habitData!.colorHex))
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear)
                            .frame(width: 50, height: 50)
                            .zIndex(1)
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 7.0))
                            .foregroundColor(Color.gray.opacity(0.2))
                            .animation(.linear)
                            .frame(width: 50, height: 50)
                    }
                    .padding(.bottom, 8)
                } else {
                    Image(systemName: "checkmark.circle")
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: habitData!.colorHex))
                        .font(.system(size: 60))
                        .padding(.bottom, 8)
                }
                HStack {
                    Text(habitData!.name)
                        .font(.custom("GodoB", size: 18))
                        .mainColor()
                }
                Text("\(isNextDay ? 0 : habitData!.current)/\(habitData!.numberOfTimes)")
                    .foregroundColor(Color(hex: habitData!.colorHex))
                    .headline()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                colorScheme == .light ? Color.white : .black
            )
        }
    }
    
    struct EmptyPlaceholder: View {
        @Environment(\.colorScheme) var colorScheme
        var body: some View {
            Text("Long press and hold the widget to select your goal.".localized)
                .bodyText()
                .padding(15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    colorScheme == .light ? Color.white : .black
                )
        }
    }
    
}

struct HabitWidget_Previews: PreviewProvider {
    
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    
    static var previews: some View {
        let intent = ConfigurationIntent()
        let id = UUID()
        WidgetBridge.todayAchievements =  [
            HabitWidgetData(
                id: id, name: "테스트", numberOfTimes: 10,
                current: 4, colorHex: ThemeColor.colorList[0].hex, day: Date().day
            )
        ]
        intent.habit = HabitCompact(identifier: id.uuidString, display: "테스트")
        return Group {
            HabitWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: intent))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .light)
            HabitWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: intent))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
