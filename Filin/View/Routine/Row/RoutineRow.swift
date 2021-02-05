//
//  RoutineRow.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RoutineRow: View {
    
    @ObservedObject var routine: FlRoutine
    @Binding var isSheet: RoutineSheet?
    
    var subTitle: String {
        var subTitleStr = ""
        if let time = routine.time {
            subTitleStr += "\(time.localizedHourMinute)"
        }
        return subTitleStr
    }
    
    var body: some View {
        HStack {
            VStack {
                if routine.time != nil {
                    HStack {
                        Text(routine.time!.localizedHourMinute)
                            .bodyText()
                        Spacer()
                    }
                } else {
                    HStack {
                        Text(String(format: NSLocalizedString("%d goals", comment: ""), routine.list.count))
                            .bodyText()
                        Spacer()
                    }
                }
                HStack {
                    Text(routine.name)
                        .font(.custom("GodoB", size: 20))
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isSheet = .edit(routine) }
            Spacer()
            NavigationLink(destination:
                        RunRoutine(routine: routine)
            ) {
                Image(systemName: "play")
                    .font(.system(size: 22, weight: .semibold))
                    .mainColor()
                    .frame(width: 40, height: 40)
            }
        }
        .rowBackground()
    }
    
}

struct RoutineRow_Previews: PreviewProvider {
    static var previews: some View {
        RoutineRow(routine: FlRoutine.routine1, isSheet: .constant(nil))
    }
}
