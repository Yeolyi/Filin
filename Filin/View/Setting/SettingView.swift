//
//  SettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI
import Combine

struct SettingView: View {
    
    @State var isTapSetting = false
    @State var isEndOfDaySetting = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    let appVersion: String
    let build: String
    
    init() {
        appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Button(action: {isTapSetting = true}) {
                        VStack {
                            HStack {
                                Text("Change Default Tab".localized)
                                    .bodyText()
                                Spacer()
                                Text(DefaultTap(rawValue: appSetting.defaultTap)!.description)
                                    .subColor()
                                    .bodyText()
                            }
                        }
                    }
                    .flatRowBackground()
                    .actionSheet(isPresented: $isTapSetting) {
                        ActionSheet(
                            title: Text("Choose Tab".localized),
                            message: nil,
                            buttons: [DefaultTap.list, .summary, .routine].map { tap in
                                Alert.Button.default(Text(tap.description)) {
                                    appSetting.defaultTap = tap.rawValue
                                }
                            } + [Alert.Button.cancel()]
                        )
                    }
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
                        Text("Start week on Monday".localized)
                            .bodyText()
                        Spacer()
                        PaperToggle($appSetting.isMondayStart)
                    }
                    .flatRowBackground()
                    #if DEBUG
                    Button(action: {
                        _ = DataSample.shared
                    }) {
                        HStack {
                            Text("샘플")
                                .bodyText()
                            Spacer()
                        }
                        .onTapGesture {
                            
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
