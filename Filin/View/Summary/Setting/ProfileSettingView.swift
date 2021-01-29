//
//  ProfileSettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct ProfileSettingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var summaryManager: SummaryManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 5) {
                    SummaryStateRow(num: 1, targetHabit: $summaryManager.contents[0].first)
                    SummaryStateRow(num: 2, targetHabit: $summaryManager.contents[0].second)
                    SummaryStateRow(num: 3, targetHabit: $summaryManager.contents[0].third)
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Summary Setting".localized)
            .accentColor(ThemeColor.mainColor(colorScheme))
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        _ = DataSample.shared
        return ProfileSettingView()
    }
}
