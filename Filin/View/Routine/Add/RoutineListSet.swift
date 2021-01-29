//
//  1_Name.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct RoutineSetList: View {
    
    @ObservedObject var listData: EditableList<UUID>
    @Environment(\.presentationMode) var presentationMode
    
    init(listData: EditableList<UUID>) {
        self.listData = listData
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Add the desired goal to the routine. Duplicates are also possible.".localized)
                    .bodyText()
                    .padding(10)
                ScrollView {
                    ForEach(HabitManager.shared.contents) { habit in
                        HStack {
                            Text(habit.name)
                                .bodyText()
                            Spacer()
                            BasicButton("plus") {
                                let id = habit.id
                                listData.append(id)
                            }
                        }
                    }
                }
                .flatRowBackground()
            }
            .padding(.bottom, 8)
            VStack(spacing: 0) {
                HStack {
                    Text("Routine List".localized)
                        .headline()
                    Spacer()
                }
                EditableListView(listData: listData, view: { id in
                    HStack {
                        BasicButton("minus") {
                            listData.remove(id)
                        }
                        Text(
                            HabitManager.shared.contents.first(
                                where: {$0.id == listData.value(of: id)}
                            )?.name ?? "Test"
                        )
                            .bodyText()
                    }
                })
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle(Text("List".localized))
    }
    
}

struct RoutineSetList_Previews: PreviewProvider {
    static var previews: some View {
        RoutineSetList(listData: EditableList(values: FlRoutine.routine1.list.map(\.id), save: {_ in}))
    }
}
