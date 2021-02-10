//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitScrollView: View {
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @State var searchWord = ""
    
    var isTodayEmpty: Bool {
        habitManager.contents.filter({$0.isTodo(at: appSetting.mainDate.dayOfTheWeek)}).isEmpty
    }
    var isGeneralEmpty: Bool {
        (
            habitManager.contents.count -
                habitManager.contents.filter({$0.isTodo(at: appSetting.mainDate.dayOfTheWeek)}).count
        ) == 0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Today".localized)
                    .sectionText()
                if !isTodayEmpty {
                    ForEach(
                        habitManager.contents.filter {
                            $0.isTodo(at: appSetting.mainDate.dayOfTheWeek)
                        }.sorted(by: { habit1, habit2 in
                            habit1.achievement.progress(at: appSetting.mainDate) <
                                habit2.achievement.progress(at: appSetting.mainDate)
                        })
                    ) { habitInfo in
                        HabitRow(habit: habitInfo, showAdd: true)
                            .environmentObject(habitInfo)
                    }
                } else {
                    SubIndicatingRow(label: "There is no planned goal today.".localized)
                }
                Text("Others".localized)
                    .sectionText()
                if !isGeneralEmpty {
                    ForEach(
                        habitManager.contents.filter({!$0.isTodo(at: appSetting.mainDate.dayOfTheWeek)})
                    ) { habitInfo in
                        HabitRow(habit: habitInfo, showAdd: false)
                    }
                } else {
                    SubIndicatingRow(label: "There is no goal on other days.".localized)
                }
            }
        }
        .padding(.top, 1)
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        let coredataPreview = PreviewDataProvider.shared
        return
            NavigationView {
                HabitScrollView()
                    .environmentObject(AppSetting())
                    .environmentObject(coredataPreview.habitManager)
                    .navigationBarTitle(Text("Test"))
            }
    }
}
