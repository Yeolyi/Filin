//
//  CalendarImage.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/31.
//

import SwiftUI

enum ImageSize {
    case fourThree
    case fourFive
    case free
    case square
    var sizeTuple: (width: CGFloat, height: CGFloat) {
        switch self {
        case .fourThree:
            return (340, 255)
        case .fourFive:
            return (340, 425)
        case .free:
            return (0, 0)
        case .square:
            return (340, 340)
        }
    }
    var localized: String {
        switch self {
        case .fourThree:
            return "4:3"
        case .fourFive:
            return "4:5"
        case .free:
            return "Free".localized
        case .square:
            return "Square".localized
        }
    }
}

struct CalendarWithLogo: View {
    
    let isExpanded: Bool
    let habit: FlHabit
    let imageAspect: ImageSize
    let isEmojiView: Bool
    let selectedDate: Date
    let appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 0) {
            CaptureCalendar(
                isEmojiView: isEmojiView,
                isExpanded: isExpanded, selectedDate: selectedDate, habit1: habit
            )
            .environmentObject(appSetting)
            .if(imageAspect != .free) {
                $0.frame(width: imageAspect.sizeTuple.width, height: imageAspect.sizeTuple.height)
            }
            .rowBackground()
            HStack(spacing: 4) {
                Spacer()
                Image("Icon1024")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .cornerRadius(4)
                Text("FILIN")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.trailing, 20)
            }
        }
    }
}

struct CalendarImage_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWithLogo(
            isExpanded: false, habit: FlHabit.habit1,
            imageAspect: .free, isEmojiView: false, selectedDate: Date(), appSetting: AppSetting()
        )
    }
}
