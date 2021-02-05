//
//  SelectRoutineList.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/05.
//

import SwiftUI

struct SelectRoutineList: View {
    
    @EnvironmentObject var listData: EditableList<FlHabit>
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    let cursorID: UUID
    
    var body: some View {
        VStack(spacing: 0) {
            EditableListView(listData: listData) { id in
                HStack(spacing: 15) {
                    if listData.value(of: id).id != cursorID {
                        Button(action: {
                            listData.append(listData.value(of: id))
                        }) {
                            Image(systemName: "plus.rectangle.on.rectangle")
                                .font(.system(size: 18, weight: .semibold))
                                .subColor()
                        }
                    }
                    Text(listData.value(of: id).name)
                        .foregroundColor(listData.value(of: id).color)
                        .font(.custom("GodoB", size: 16))
                }
            }
            .padding(.horizontal, 10)
            MainRectButton(action: { presentationMode.wrappedValue.dismiss() }, str: "Done".localized)
                .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
    }
}

struct SelectRoutineList_Previews: PreviewProvider {
    static var previews: some View {
        SelectRoutineList(cursorID: UUID())
            .environmentObject(EditableList(values: DataSample.shared.habitManager.contents, save: {_ in}))
    }
}
