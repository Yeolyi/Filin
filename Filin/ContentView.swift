//
//  HabitListView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    init(defaultTab: Int) {
        _currentTab = State(initialValue: defaultTab)
    }
    
    var body: some View {
        ZStack {
            Group {
                HabitList()
                    .opacity(currentTab == 0 ? 1 : 0)
                SummaryView()
                    .opacity(currentTab == 1 ? 1 : 0)
                RoutineView()
                    .opacity(currentTab == 2 ? 1 : 0)
                SettingView()
                    .opacity(currentTab == 3 ? 1 : 0)
            }
            .padding(.bottom, 55)
            VStack(spacing: 0) {
                Spacer()
                Divider()
                HStack {
                    Image(systemName: currentTab == 0 ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2")
                        .font(.system(size: 20))
                        .mainColor()
                        .frame(width: 75, height: 55)
                        .onTapGesture {
                            currentTab = 0
                        }
                    Spacer()
                    Image(systemName: currentTab == 1 ? "pin.fill" : "pin")
                        .font(.system(size: 20))
                        .mainColor()
                        .frame(width: 75, height: 55)
                        .onTapGesture {
                            currentTab = 1
                        }
                    Spacer()
                    Image(systemName: currentTab == 2 ? "alarm.fill" : "alarm")
                        .font(.system(size: 20))
                        .mainColor()
                        .frame(width: 75, height: 55)
                        .onTapGesture {
                            currentTab = 2
                        }
                    Spacer()
                    Image(systemName: currentTab == 3 ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 20))
                        .mainColor()
                        .frame(width: 75, height: 55)
                        .onTapGesture {
                            currentTab = 3
                        }
                }
                .padding(.horizontal, 15)
                .edgesIgnoringSafeArea([.bottom, .horizontal])
                .background(colorScheme == .light ? Color.white : .black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(defaultTab: 0)
            .environmentObject(DataSample.shared.habitManager)
            .environmentObject(DataSample.shared.summaryManager)
            .environmentObject(DataSample.shared.routineManager)
            .environmentObject(AppSetting())
    }
}
