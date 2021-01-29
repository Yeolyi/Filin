//
//  AddRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

/// 새로운 루틴을 추가하는 뷰
struct AddRoutine: View {
    
    let totalPage = 4
    
    @State var currentPage = 1
    @State var isReminder = true
    @State var tempRoutineTime = Date()
    
    @ObservedObject var newRoutine = FlRoutine(UUID(), name: "")
    @ObservedObject var listData = EditableList<UUID>(values: [], save: {_ in })
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var habitManager: HabitManager
    
    var isNextAvailable: Bool {
        if currentPage == 1 {
            return newRoutine.name != ""
        } else if currentPage == 2 {
            return !listData.list.isEmpty
        } else if currentPage == 3 {
            return true
        } else if currentPage == 4 {
            return true
        } else {
            assertionFailure("페이지 범위를 벗어났습니다.")
            return true
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            if currentPage == 1 {
                RoutineName(name: $newRoutine.name)
            }
            if currentPage == 2 {
                RoutineSetList(listData: listData)
            }
            if currentPage == 3 {
                RoutineDate(dayOfTheWeek: $newRoutine.dayOfWeek)
            }
            if currentPage == 4 {
                RoutineTime(routineTime: $tempRoutineTime, isTimer: $isReminder)
            }
            Spacer()
            HStack {
                previousButton
                Spacer()
            }
            nextButton
        }
        .padding(.bottom, 20)
    }
    var previousButton: some View {
        Button(action: {
            withAnimation { self.currentPage = max(self.currentPage - 1, 1) }
        }) {
            Text("Previous".localized)
                .bodyText()
                .fixedSize()
                .padding(.leading, 20)
                .padding(.bottom, 8)
        }
        .if(currentPage == 1) {
            $0.hidden()
        }
    }
    var nextButton: some View {
        MainRectButton(
            action: {
                if isNextAvailable == false { return }
                if currentPage == totalPage {
                    if isReminder {
                        newRoutine.time = tempRoutineTime
                    }
                    newRoutine.list = listData.allValues.compactMap { id in
                        habitManager.contents.first(where: {id == $0.id})
                    }
                    routineManager.append(newRoutine)
                    presentationMode.wrappedValue.dismiss()
                    return
                }
                withAnimation { self.currentPage += 1 }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            },
            str: currentPage == totalPage ? "Done".localized: "\("Next".localized) (\(currentPage)/\(totalPage))"
        )
        .opacity(isNextAvailable ? 1.0 : 0.5)
    }
}

struct AddRoutine_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutine()
    }
}
