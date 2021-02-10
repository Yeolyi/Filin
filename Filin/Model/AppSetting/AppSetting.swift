//
//  SharedViewDagta.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import CoreData

class AppSetting: ObservableObject {
    
    init() {
        guard appGroupUpdated else {
            let previousUserDefaults = UserDefaults(suiteName: "group.wannasleep.habitdiary")!
            for key in ["runCount", "defaultTap", "mondayCalendar", "dayResetTime", "addUnit"] {
                guard let data = previousUserDefaults.object(forKey: key) as? Data else {
                    return
                }
                UserDefaults.snuYum.set(data, forKey: key)
            }
            appGroupUpdated = true
            return
        }
    }
    
    func summaryConvert(moc: NSManagedObjectContext, summaryManager: SummaryManager) {
        guard summaryUpdated else {
            let entityName = String(describing: Summary.self)
            let fetchRequest = NSFetchRequest<Summary>(entityName: entityName)
            if let fetched = try? moc.fetch(fetchRequest) {
                guard !fetched.isEmpty else {
                    return
                }
                let summaryManager = summaryManager
                if summaryManager.contents.isEmpty {
                    summaryManager.contents.append(TempSummary.makeSample(usingIDs: fetched.map(\.id)))
                } else {
                    var seen: Set<UUID> = []
                    let legacyFiltered = [fetched[0].first, fetched[0].second, fetched[0].third]
                        .compactMap({$0}).filter {
                        seen.insert($0).inserted
                    }
                    summaryManager.contents[0].list = legacyFiltered
                }
            }
            summaryUpdated = true
            return
        }
    }
    
    @AutoSave("appGroupUpdated", defaultValue: false)
    var appGroupUpdated: Bool
    
    @AutoSave("summaryUpdated", defaultValue: false)
    var summaryUpdated: Bool
    
    @AutoSave("runCount", defaultValue: 0)
    var runCount: Int
    
    @AutoSave("mondayCalendar", defaultValue: false)
    var isMondayStart: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    
    /// 다음 날 정보를 보여줄 시간 설정. 시간 단위. 기본값 0(24시)
    @AutoSave("dayResetTime", defaultValue: 0)
    var dayResetTime: Int {
        didSet {
            objectWillChange.send()
        }
    }
    
    var isFirstRun: Bool {
        runCount == 1
    }
    
    @AutoSave("calendarMode", defaultValue: .tile)
    var calendarMode: CalendarMode {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AutoSave("sceneBackgroundTime", defaultValue: nil)
    var sceneBackgroundTime: Date?

    var mainDate: Date {
        if Date().hour >= dayResetTime {
            return Date()
        } else {
            return Date().addDate(-1)!
        }
    }
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

}
