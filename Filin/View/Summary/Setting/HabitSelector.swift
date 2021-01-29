//
//  HabitSelector.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct HabitSelector: View {
    
    let position: Int
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var targetHabit: UUID?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(HabitManager.shared.contents, id: \.self) { habit in
                    Button(action: {
                        targetHabit = habit.id
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(habit.name)
                                .mainColor()
                                .bodyText()
                            Spacer()
                            if targetHabit == habit.id {
                                Image(systemName: "checkmark")
                                    .mainColor()
                                    .bodyText()
                            }
                        }
                    }
                    .flatRowBackground()
                }
                Button(action: {
                    targetHabit = nil
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Empty".localized)
                            .mainColor()
                            .bodyText()
                        Spacer()
                    }
                    .flatRowBackground()
                }
            }
            .padding(.top, 10)
        }
        .padding(.top, 1)
        .navigationBarTitle(Text("Habit List".localized), displayMode: .inline)
    }
}
