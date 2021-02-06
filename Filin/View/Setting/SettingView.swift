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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("General".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
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
                    .actionSheet(isPresented: $isEndOfDaySetting) {
                        ActionSheet(
                            title: Text("The End of the Day".localized),
                            message: Text("Choose time to initialize info.".localized),
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
                    HStack {
                        Text("Calendar".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    HStack {
                        Text("Start week on Monday".localized)
                            .bodyText()
                        Spacer()
                        PaperToggle($appSetting.isMondayStart)
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
                                        ThemeColor.mainColor(colorScheme) : ThemeColor.inActive(colorScheme)
                                )
                                .rotationEffect(Angle(degrees: -90))
                                .frame(width: 25, height: 25)
                        }
                        Button(action: { appSetting.calendarMode = .tile }) {
                            Circle()
                                .foregroundColor(
                                    appSetting.calendarMode == .tile ?
                                        ThemeColor.mainColor(colorScheme).opacity(0.8) :
                                        ThemeColor.inActive(colorScheme)
                                )
                                .frame(width: 30, height: 30)
                        }
                    }
                    .flatRowBackground()
                    #if DEBUG
                    HStack {
                        Text("DEBUG".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    Button(action: { _ = PreviewDataProvider.shared }) {
                        HStack {
                            Text("샘플")
                                .bodyText()
                            Spacer()
                        }
                        .flatRowBackground()
                    }
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
