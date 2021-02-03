//
//  EditSummary.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI

struct EditSummary: View {
    
    @EnvironmentObject var summaryManager: SummaryManager
    @ObservedObject var listData: EditableList<FlHabit>
    let separatorID: UUID
    
    @Environment(\.presentationMode) var presentationMode
    
    init(habits: [FlHabit], current: [FlHabit]) {
        let separatorID = UUID()
        self.separatorID = separatorID
        let separatorHabit = FlHabit(
            id: separatorID,
            name: "⬆️ Goals to be displayed ⬆️".localized
        )
        separatorHabit.color = Color.gray
        var habitsWithSeparator = current
        habitsWithSeparator.append(separatorHabit)
        for habit in habits where !habitsWithSeparator.contains(habit) {
            habitsWithSeparator.append(habit)
        }
        listData = EditableList(values: habitsWithSeparator, save: { habits in
            var saved = [FlHabit]()
            for habit in habits {
                if habit.id == separatorID { break }
                saved.append(habit)
            }
        })
    }
    
    var orderedHabit: [FlHabit] {
        var saved = [FlHabit]()
        for habit in listData.allValues {
            if habit.id == separatorID { break }
            saved.append(habit)
        }
        return saved
    }
    
    var body: some View {
        FlInlineNavigationBar(bar: {
            HStack {
                Text("Edit Summary".localized)
                    .headline()
                Spacer()
                BasicTextButton("Save".localized) {
                    summaryManager.contents[0].list = orderedHabit.map(\.id)
                    summaryManager.objectWillChange.send()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 20)
        }) {
            VStack(spacing: 0) {
                EditableListView(listData: listData) { id in
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
                Spacer()
            }
        }
    }
}

struct EditSummary_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = DataSample.shared
        return Text("")
            .sheet(isPresented: .constant(true)) {
                EditSummary(habits: dataSample.habitManager.contents, current: [])
                    .environmentObject(dataSample.summaryManager)
            }
    }
}
