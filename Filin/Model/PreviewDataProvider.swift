//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

/// Xcode preview와 앱스토어 스크린샷을 위한 임시 manager들과 데이터들을 제공.
/// - Note: 데이터가 중복으로 저장됨을 막기 위해 싱글톤 패턴 사용.
/// - Warning: **프리뷰 전용으로 초기화시 데이터가 추가됨**
/// - Todo: 싱글톤 패턴을 꼭 사용해야되는지 생각해보기. 의존성 주입이 뭔지 공부하기.
final class PreviewDataProvider {
    
    let habitManager = HabitManager()
    let summaryManager = SummaryManager()
    let routineManager = RoutineManager()
    
    static let shared = PreviewDataProvider()

    private init() {
        #if DEBUG
        let habits: [FlHabit] = [0, 1, 2, 3].map { FlHabit.sample(number: $0) }
        habitManager.append(contentsOf: habits, summaryManager: summaryManager)
        routineManager.append(FlRoutine.sample(number: 0))
        routineManager.append(FlRoutine.sample(number: 1))
        habitManager.save()
        routineManager.save()
        #else
        print("PreviewDataProvider가 디버그 환경이 아닐 때 초기화가 시도되었습니다.")
        #endif
    }

}

class CheckVersionCompatability {

    static func addSample(habitManager: HabitManager, summaryManager: SummaryManager, routineManager: RoutineManager) {
        let habits: [FlHabit] = [0, 1, 2, 3].map { FlHabit.sample(number: $0) }
        habitManager.append(contentsOf: habits, summaryManager: summaryManager)
        routineManager.append(FlRoutine.sample(number: 0))
        routineManager.append(FlRoutine.sample(number: 1))
        habitManager.save()
        routineManager.save()
    }

    static func isDataPreservedOnVersionChange(habitManager: HabitManager, routineManager: RoutineManager) -> Bool {
        FlHabit.sampleCount == habitManager.contents.count &&
            FlRoutine.sampleCount == routineManager.contents.count &&
        habitManager.contents.enumerated().allSatisfy { index, value in
            FlHabit.sample(number: index) == value
        } &&
        routineManager.contents.enumerated().allSatisfy { index, value in
            FlRoutine.sample(number: index) == value
        }
    }

}
