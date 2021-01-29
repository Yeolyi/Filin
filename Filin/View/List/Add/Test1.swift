//
//  Test1.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct NameSection: View {
    
    @Binding var name: String
    @State var nameExamples = [
        "Foreign language", "Reading",
        "Get Certified", "Playing musical instruments",
        "Eating vitamins", "Push-up", "Diet", "Morning jogging",
        "Yoga", "Stretching"
    ].shuffled().map({$0.localized})
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LottieView(filename: "lottiePlus")
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 5)
                    .padding(.top, 21)
                    .if(colorScheme == .dark) {
                        $0.colorInvert()
                    }
                Text(appSetting.isFirstRun && habitManager.contents.isEmpty ?
                        "Make first goal".localized : "Make new goal".localized)
                    .title()
                    .padding(.bottom, 89)
                HStack {
                    Text("What is the name of the goal?".localized)
                        .bodyText()
                    Spacer()
                }
                .padding(.leading, 20)
                TextFieldWithEndButton("Drink water".localized, text: $name)
                    .rowBackground()
                    .padding(.bottom, 15)
                FlowLayout(mode: .scrollable, items: nameExamples) { text in
                    Button(action: { name = text }) {
                    Text(text)
                        .bodyText()
                        .padding(10)
                        .background(
                            Rectangle()
                                .subColor()
                                .opacity(0.2)
                        )
                    }
                }
                .rowPadding()
            }
        }
    }
    
}

struct Test1_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var selectedText = "Text"
        var body: some View {
            _ = DataSample.shared
            return NameSection(name: $selectedText)
                .environmentObject(AppSetting())
        }
    }
    static var previews: some View {
        StateWrapper()
    }
}
