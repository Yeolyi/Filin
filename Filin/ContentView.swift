//
//  HabitListView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Group {
                HabitList()
                    .opacity(currentTab == 0 ? 1 : 0)
                    .zIndex(currentTab == 0 ? 2 : 1)
                SummaryView()
                    .opacity(currentTab == 1 ? 1 : 0)
                    .zIndex(currentTab == 1 ? 2 : 1)
                RoutineView()
                    .opacity(currentTab == 2 ? 1 : 0)
                    .zIndex(currentTab == 2 ? 2 : 1)
                SettingView()
                    .opacity(currentTab == 3 ? 1 : 0)
                    .zIndex(currentTab == 3 ? 2 : 1)
            }
            .padding(.bottom, 55)
            VStack(spacing: 0) {
                Spacer()
                Divider()
                HStack {
                    VStack(spacing: 0) {
                        Image(systemName: currentTab == 0 ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2")
                            .font(.system(size: 20))
                            .onTapGesture {
                                currentTab = 0
                            }
                            .frame(width: 50, height: 32)
                        Text("Goal".localized)
                            .font(.system(size: FontSize.micro.rawValue, weight: .semibold))
                    }
                    .foregroundColor(currentTab == 0 ? ThemeColor.brand : ThemeColor.mainColor(colorScheme))
                    
                    Spacer()
                    VStack(spacing: 0) {
                        Image(systemName: currentTab == 1 ? "pin.fill" : "pin")
                            .font(.system(size: 20))
                            .frame(width: 50, height: 32)
                            .onTapGesture {
                                currentTab = 1
                            }
                        Text("Summary".localized)
                            .font(.system(size: FontSize.micro.rawValue, weight: .semibold))
                    }
                    .foregroundColor(currentTab == 1 ? ThemeColor.brand : ThemeColor.mainColor(colorScheme))
                    Spacer()
                    VStack(spacing: 0) {
                        Image(systemName: currentTab == 2 ? "alarm.fill" : "alarm")
                            .font(.system(size: 20))
                            .frame(width: 50, height: 32)
                            .onTapGesture {
                                currentTab = 2
                            }
                        Text("Routine".localized)
                            .font(.system(size: FontSize.micro.rawValue, weight: .semibold))
                    }
                    .foregroundColor(currentTab == 2 ? ThemeColor.brand : ThemeColor.mainColor(colorScheme))
                    Spacer()
                    VStack(spacing: 0) {
                        Image(systemName: currentTab == 3 ? "gearshape.fill" : "gearshape")
                            .font(.system(size: 20))
                            .frame(width: 50, height: 32)
                            .onTapGesture {
                                currentTab = 3
                            }
                        Text("Setting".localized)
                            .font(.system(size: FontSize.micro.rawValue, weight: .semibold))
                    }
                    .foregroundColor(currentTab == 3 ? ThemeColor.brand : ThemeColor.mainColor(colorScheme))
                }
                .padding(.horizontal, 25)
                .padding(.top, 5)
                .padding(.bottom, 1)
                .edgesIgnoringSafeArea([.bottom, .horizontal])
                .background(colorScheme == .light ? Color.white : .black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PreviewDataProvider.shared.habitManager)
            .environmentObject(PreviewDataProvider.shared.summaryManager)
            .environmentObject(PreviewDataProvider.shared.routineManager)
            .environmentObject(AppSetting())
    }
}
