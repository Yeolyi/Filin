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
            return (400, 300)
        case .fourFive:
            return (400, 500)
        case .free:
            return (0, 0)
        case .square:
            return (400, 400)
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
    var paddingSize: (horizontal: CGFloat, vertical: CGFloat) {
        switch self {
        case .free, .square:
            return (20, 20)
        case .fourFive:
            return (20, 25)
        case .fourThree:
            return (20, 15)
        }
    }
}

struct CalendarWithLogo: View {
    
    let isExpanded: Bool
    let habits: HabitGroup
    let imageAspect: ImageSize
    let isEmojiView: Bool
    let selectedDate: Date
    let appSetting: AppSetting
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            CaptureCalendar(
                isEmojiView: isEmojiView,
                selectedDate: selectedDate, isExpanded: isExpanded, habits: habits
            )
            .environmentObject(appSetting)
            .rowBackground()
            HStack(spacing: 4) {
                Spacer()
                Image(colorScheme == .light ? "Icon1024" : "icon_dark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .cornerRadius(4)
                Text("FILIN")
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.trailing, 10)
        }
        .if(imageAspect != .free) {
            $0.frame(width: imageAspect.sizeTuple.width, height: imageAspect.sizeTuple.height)
        }
        .if(imageAspect == .free) {
            $0.frame(width: 400)
        }
        .padding(.horizontal, imageAspect.paddingSize.horizontal)
        .padding(.vertical, imageAspect.paddingSize.vertical)
    }
}

struct CalendarImage_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWithLogo(
            isExpanded: false, habits: .init(contents: [FlHabit.habit1]),
            imageAspect: .free, isEmojiView: false, selectedDate: Date(), appSetting: AppSetting()
        )
        .environment(\.colorScheme, .dark)
    }
}
