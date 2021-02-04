//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

extension FlHabit {
    
    typealias HabitData = (name: String, color: Color, numberOfTimes: Int, requiredSec: Int)
    
    static var habit1: FlHabit {
        let habitData: HabitData =  ("중간 스트레칭🙆‍♀️".localized, Palette.Default.pink.color, 10, 10)
        let habit = FlHabit(
            name: habitData.name, color: habitData.color, numberOfTimes:
                habitData.numberOfTimes, requiredSec: habitData.requiredSec
        )
        habit.achievement.content = (-60...0).reduce(into: [:], { result, num in
            let newDateKey = Date().addDate(num)!.dictKey
            result[newDateKey] = Int.random(in: 0...habit.achievement.numberOfTimes)
        })
        return habit
    }
    
    static var habit2: FlHabit {
        let habitData: HabitData =  ("물 2L 마시기💧".localized, Palette.Default.blue.color, 8, 0)
        let habit = FlHabit(
            name: habitData.name, color: habitData.color, numberOfTimes:
                habitData.numberOfTimes, requiredSec: habitData.requiredSec
        )
        habit.achievement.content = (-60...0).reduce(into: [:], { result, num in
            let newDateKey = Date().addDate(num)!.dictKey
            result[newDateKey] = Int.random(in: 0...habit.achievement.numberOfTimes)
        })
        return habit
    }
}

extension FlRoutine {
    
    static var routine1: FlRoutine {
        let temp = FlRoutine(UUID(), name: "After wake up".localized)
        temp.list = [FlHabit.habit1, FlHabit.habit2]
        temp.time = Date()
        return temp
    }
    
    static var routine2: FlRoutine {
        let temp = FlRoutine(UUID(), name: "Before bed".localized)
        temp.list = [FlHabit.habit1, FlHabit.habit2, FlHabit.habit1, FlHabit.habit2]
        return temp
    }
    
}

/// Xcode preview와 앱스토어 스크린샷을 위한 임시 manager들과 데이터들을 제공.
/// - Note: 데이터가 중복으로 저장됨을 막기 위해 싱글톤 패턴 사용.
/// - Todo: 싱글톤 패턴을 꼭 사용해야되는지 생각해보기. 의존성 주입이 뭔지 공부하기.
final class DataSample {
    
    let habitManager = HabitManager.shared
    let summaryManager = SummaryManager.shared
    let routineManager = RoutineManager.shared
    
    static let shared = DataSample()

    private init() {
        let habitDatas: [(name: String, color: Color, numberOfTimes: Int, requiredSec: Int)] = [
            ("유산균 챙겨먹기🥛".localized, Palette.Default.green.color, 2, 0),
            ("물 2L 마시기💧".localized, Palette.Default.blue.color, 8, 0),
            ("10분 걷기🚶".localized, Palette.Default.red.color, 3, 600),
            ("중간 스트레칭🙆‍♀️".localized, Palette.Default.pink.color, 8, 10)
        ]
        var usedIds: [UUID] = []
        let habits: [FlHabit] = habitDatas.map { data in
            let id = UUID()
            usedIds.append(id)
            return FlHabit(
                id: id, name: data.name, color: data.color,
                numberOfTimes: data.numberOfTimes, requiredSec: data.requiredSec
            )
        }
        for habit in habits {
            habit.achievement.content = (-60...0).reduce(into: [:], { result, num in
                let newDateKey = Date().addDate(num)!.dictKey
                result[newDateKey] = Int.random(in: 0...habit.achievement.numberOfTimes)
            })
            habitManager.append(habit, summaryManager: summaryManager)
        }
        
        summaryManager.append(.init(name: "Default", list: habitManager.contents.map(\.id)))
        
        let routine1 = FlRoutine(UUID(), name: "After wake up".localized)
        routine1.list = Array(habits[0...1])
        let routine2 = FlRoutine(UUID(), name: "Before bed".localized)
        routine2.list = Array(habits[0...3])
        routineManager.append(routine1)
        routineManager.append(routine2)
    }

}
