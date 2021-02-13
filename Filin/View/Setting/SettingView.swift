//
//  SettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct SettingView: View {
    
    @State var isTapSetting = false
    @State var isEndOfDaySetting = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var routineManager: RoutineManager
    
    var endOfDayActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Select the time to initialize the goal.".localized),
            buttons: [
                (0, "24:00"), (1, "01:00"),
                (2, "02:00"), (3, "03:00"),
                (4, "04:00"), (5, "05:00")
            ].map { tuple in
                Alert.Button.default(Text(tuple.1)) {
                    appSetting.dayResetTime = tuple.0
                }
            } + [Alert.Button.cancel()]
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Text("General".localized)
                        .smallSectionText()
                    HStack {
                        Text("The End of the Day".localized)
                            .bodyText()
                        Spacer()
                        Text("\(appSetting.dayResetTime == 0 ? "24" : "0\(appSetting.dayResetTime)"):00")
                            .subColor()
                            .bodyText()
                    }
                    .flatRowBackground()
                    .onTapGesture { isEndOfDaySetting = true }
                    .actionSheet(isPresented: $isEndOfDaySetting) { endOfDayActionSheet }
                    Text("""
                        If you go to bed late, consider setting it after 24:00.
                        """.localized)
                        .subColor()
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    Text("Calendar".localized)
                        .smallSectionText()
                    HStack {
                        Text("Set Start of the Week to Monday".localized)
                            .bodyText()
                        Spacer()
                        FlToggle($appSetting.isMondayStart)
                    }
                    .flatRowBackground()
                    HStack(spacing: 20) {
                        Text("Calendar Theme".localized)
                            .bodyText()
                        Spacer()
                        Button(action: { appSetting.calendarMode = .ring }) {
                            Circle()
                                .trim(from: 0.0, to: 0.7)
                                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round))
                                .foregroundColor(
                                    appSetting.calendarMode == .ring ?
                                        ThemeColor.brand : ThemeColor.subColor(colorScheme)
                                )
                                .rotationEffect(Angle(degrees: -90))
                                .frame(width: 25, height: 25)
                        }
                        Button(action: { appSetting.calendarMode = .tile }) {
                            Circle()
                                .foregroundColor(
                                    appSetting.calendarMode == .tile ?
                                        ThemeColor.brand :
                                        ThemeColor.subColor(colorScheme)
                                )
                                .frame(width: 30, height: 30)
                        }
                    }
                    .flatRowBackground()
                    #if DEBUG
                    Text("디버그 전용".localized)
                        .smallSectionText()
                    Button(action: { CheckVersionCompatability.addSample(
                            habitManager: habitManager, summaryManager: summaryManager, routineManager: routineManager
                    ) }) {
                        HStack {
                            Text("샘플")
                                .bodyText()
                            Spacer()
                        }
                        .flatRowBackground()
                    }
                    HStack {
                        Text("데이터 보존")
                            .bodyText()
                        Spacer()
                        Text(String(CheckVersionCompatability.isDataPreservedOnVersionChange(
                                        habitManager: habitManager, routineManager: routineManager)
                        ))
                    }
                    .flatRowBackground()
                    #endif
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Setting".localized)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(AppSetting())
    }
}
