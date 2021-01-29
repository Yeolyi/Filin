//
//  DefaultTap.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI

/// - Note: Int값은 TabView의 태그값과 일치해야함.
enum DefaultTap: Int, CaseIterable {
    var description: String {
        switch self {
        case .list: return "List".localized
        case .summary: return "Summary".localized
        case .routine: return "Routine".localized
        case .setting: return "Setting".localized
        }
    }
    case list, summary, routine, setting
}
