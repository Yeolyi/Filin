//
//  SingleRing.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/01.
//

import SwiftUI

struct Ring: View {
    
    @ObservedObject var habits: HabitGroup
    @EnvironmentObject var appSetting: AppSetting
    let date: Date
    let selectedDate: Date
    let isExpanded: Bool
    
    var isProgressEmpty: Bool {
        habits.count != 1 &&
        habits.contents.filter({($0.achievement.progress(at: date) ?? 0) != 0}).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 2) {
            if habits.count != 1 {
                Text("\(date.day)")
                    .bodyText()
            }
            ZStack {
                if isProgressEmpty {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 5.0))
                        .inactiveColor()
                        .frame(width: 16, height: 16)
                }
                ForEach(0..<min(3, habits.count), id: \.self) { index in
                    Circle()
                        .trim(from: 0.0, to: CGFloat(habits[index].achievement.progress(at: date) ?? 0))
                        .stroke(style: StrokeStyle(lineWidth: 5.0 - CGFloat(index) * 0.5, lineCap: .round))
                        .if(selectedDate.month != date.month && isExpanded) {
                            $0.inactiveColor()
                        }
                        .foregroundColor(habits[index].color)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 40 - CGFloat(index * 12), height: 40 - CGFloat(index * 12))
                }
                if habits.count == 1 {
                    Text("\(date.day)")
                        .if(selectedDate.month != date.month && isExpanded) {
                            $0.inactiveColor()
                        }
                        .if(selectedDate.dictKey == date.dictKey) {
                            $0.foregroundColor(habits[0].color)
                        }
                        .bodyText()
                }
            }
        }
        .padding(.bottom, 4)
    }
}

struct SingleRing_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = DataSample.shared
        return Ring(
            habits: .init(contents: [dataSample.habitManager.contents[0]]),
            date: Date(), selectedDate: Date(), isExpanded: false
        )
    }
}
