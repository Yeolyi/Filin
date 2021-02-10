//
//  FilinTests.swift
//  FilinTests
//
//  Created by SEONG YEOL YI on 2021/02/10.
//

import XCTest
@testable import Filin

class FilinTests: XCTestCase {
    
    private func initManagers() {
        HabitManager().reset()
        SummaryManager().reset()
        RoutineManager().reset()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHabitSave() {
        let habits = Array(0..<FlHabit.sampleCount).map { FlHabit.sample(number: $0) }
        var habitManager = HabitManager()
        habitManager.append(contentsOf: habits, summaryManager: SummaryManager())
        let routines = Array(0..<FlRoutine.sampleCount).map { FlRoutine.sample(number: $0) }
        var routineManager = RoutineManager()
        routineManager.append(contentsOf: routines)
        habitManager = HabitManager()
        routineManager = RoutineManager()
        let isSaved = habitManager.contents.enumerated().allSatisfy { index, value in
            FlHabit.sample(number: index) == value
        } &&
        routineManager.contents.enumerated().allSatisfy { index, value in
            FlRoutine.sample(number: index) == value
        }
        XCTAssert(isSaved)
    }

}
