//
//  EditSummary.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI

struct EditSummary: View {
    
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var habitManager: HabitManager
    
    @StateObject var listData = FlListModel<FlHabit>(values: [], save: {_ in })
    let separatorID = UUID()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    IconButton(imageName: "xmark") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Edit Summary".localized)
                        .bodyText()
                    TextButton(content: {
                        Text("Complete".localized)
                    }) {
                        if let index = listData.allValues.firstIndex(where: { $0.id == separatorID }) {
                            if index == 0 {
                                summaryManager.contents[0].list = []
                                presentationMode.wrappedValue.dismiss()
                                return
                            }
                            summaryManager.contents[0].list = Array(listData.allValues[0..<index].map(\.id))
                            summaryManager.objectWillChange.send()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                FlList(listData: listData) { id in
                    Text(listData.value(of: id).name)
                        .foregroundColor(listData.value(of: id).color)
                        .font(.custom("GodoB", size: 16))
                }
                .padding(.horizontal, 20)
                Divider()
                .padding(.bottom, 10)
                /*
                if orderedHabit.count > 3 {
                    Text("⭐️ " + "Four or more goals are displayed in tile form.")
                        .bodyText()
                        .frame(maxWidth: .infinity)
                        .flatRowBackground()
                }
                Text("The goals at the top of the line are added.".localized)
                    .bodyText()
                    .frame(maxWidth: .infinity)
                    .flatRowBackground()
 */
            }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onAppear {
            if listData.list.isEmpty {
                let separatorHabit = FlHabit(
                    id: separatorID, name: "⬆️ Goals to be displayed ⬆️".localized
                )
                separatorHabit.color = Color.gray
                var habitsWithSeparator = summaryManager.contents[0].list.compactMap { habitID in
                    habitManager.contents.first(where: { $0.id == habitID })
                }
                habitsWithSeparator.append(separatorHabit)
                for habit in habitManager.contents where !habitsWithSeparator.contains(habit) {
                    habitsWithSeparator.append(habit)
                }
                for habit in habitsWithSeparator {
                    listData.append(habit)
                }
            }
        }
    }
}

struct EditSummary_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = PreviewDataProvider.shared
        return Text("")
            .sheet(isPresented: .constant(true)) {
                EditSummary()
                    .environmentObject(dataSample.summaryManager)
            }
    }
}
