//
//  HabitShare.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/19.
//

import SwiftUI

struct HabitShare: View {
    
    private enum ImageSize {
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
    }
    
    let habit: FlHabit

    @State var isExpanded = false
    @State var selectedDate = Date()
    @State var showCalendarSelect = false
    @State var isEmojiView = false
    @State private var imageAspect: ImageSize = .free
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.presentationMode) var presentationMode
    
    init(habit: FlHabit) {
        self.habit = habit
    }
    
    var calendarImage: UIImage {
        VStack(spacing: 0) {
            CaptureCalendar(showCalendarSelect: $showCalendarSelect, isEmojiView: $isEmojiView,
                            isExpanded: $isExpanded, selectedDate: $selectedDate, habit1: habit)
                .environmentObject(appSetting)
                .if(imageAspect != .free) {
                    $0.frame(width: imageAspect.sizeTuple.width, height: imageAspect.sizeTuple.height)
                }
                .rowBackground()
            HStack(spacing: 4) {
                Spacer()
                Image("Icon1024")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .cornerRadius(4)
                Text("FILIN")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.trailing, 10)
            }
        }
        .padding(20) // 비율 맞게 패딩값 조절하기
        .asImage()
    }
    
    var body: some View {
        ScrollView {
            Text("Preview".localized)
                .sectionText()
            CaptureCalendar(showCalendarSelect: $showCalendarSelect, isEmojiView: $isEmojiView,
                            isExpanded: $isExpanded, selectedDate: $selectedDate, habit1: habit)
                .environmentObject(appSetting)
                .if(imageAspect != .free) {
                    $0.frame(width: imageAspect.sizeTuple.width, height: imageAspect.sizeTuple.height)
                }
                .padding(20)
                .rowBackground()
            Divider()
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                        if isExpanded && (imageAspect == .square || imageAspect == .fourThree) {
                            imageAspect = .fourFive
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        VStack(spacing: 5) {
                            BasicImage(
                                imageName: isExpanded ?
                                    "arrow.down.right.and.arrow.up.left" :
                                    "arrow.up.left.and.arrow.down.right"
                            )
                            Text(isExpanded ? "Fold".localized : "Expand".localized)
                                .subColor()
                                .bodyText()
                        }
                        Spacer()
                    }
                    .rowBackground(8)
                }
                Button(action: {
                    withAnimation {
                        isEmojiView.toggle()
                    }
                }) {
                    HStack {
                        Spacer()
                        VStack(spacing: 5) {
                            BasicImage(imageName: isEmojiView ? "percent" : "face.smiling")
                            Text(isEmojiView ? "Progress".localized : "Emoji".localized)
                                .subColor()
                                .bodyText()
                        }
                        Spacer()
                    }
                    .rowBackground(8)
                }
                Button(action: {
                    withAnimation {
                        showCalendarSelect.toggle()
                    }
                }) {
                    HStack {
                        Spacer()
                        VStack(spacing: 7) {
                            BasicImage(imageName: showCalendarSelect ? "checkmark" : "calendar")
                            Text("Date".localized)
                                .subColor()
                                .bodyText()
                        }
                        Spacer()
                    }
                    .rowBackground(8)
                }
            }
            .padding(.horizontal, 10)
            HStack(spacing: 0) {
                HStack(spacing: 3) {
                    Image(systemName: imageAspect == .free ? "square.dashed.inset.fill" : "square.dashed")
                        .subColor()
                    BasicTextButton("Free".localized) {
                        imageAspect = .free
                    }
                }
                .rowBackground(5, 0, 5)
                if isExpanded == false {
                HStack(spacing: 3) {
                    Image(systemName: imageAspect == .square ? "square.fill" : "square")
                        .subColor()
                    BasicTextButton("Square".localized) {
                        imageAspect = .square
                    }
                }
                .rowBackground(5, 0, 5)
                HStack(spacing: 3) {
                    Image(systemName: imageAspect == .fourThree ? "rectangle.fill" : "rectangle")
                        .subColor()
                    BasicTextButton("4:3".localized) {
                        imageAspect = .fourThree
                    }
                }
                .rowBackground(5, 0, 5)
                }
                HStack(spacing: 3) {
                    Image(systemName: imageAspect == .fourFive ? "rectangle.portrait.fill" : "rectangle.portrait")
                        .subColor()
                    BasicTextButton("4:5".localized) {
                        imageAspect = .fourFive
                    }
                }
                .rowBackground(5, 0, 5)
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 5)
            Divider()
            VStack(spacing: 0) {
                Button(action: {
                    share(items: [calendarImage])
                }) {
                    HStack {
                        Spacer()
                        Text("Image Save/Share".localized)
                            .bodyText()
                        Spacer()
                    }
                    .rowBackground(innerBottomPadding: true, 15)
                }
                Button(action: {
                    SharingHandler.instagramStory(imageData: calendarImage.pngData()!, colorScheme: colorScheme)
                }) {
                    HStack {
                        Spacer()
                        Text("Instagram Story".localized)
                            .bodyText()
                        Spacer()
                    }
                    .rowBackground(innerBottomPadding: true, 15)
                }
            }
            .padding(.top, 1)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
         }
    }
}

@discardableResult
func share(
    items: [Any],
    excludedActivityTypes: [UIActivity.ActivityType]? = nil
) -> Bool {
    guard let source = UIApplication.shared.windows.last?.rootViewController else {
        return false
    }
    let vc = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    vc.excludedActivityTypes = excludedActivityTypes
    vc.popoverPresentationController?.sourceView = source.view
    source.present(vc, animated: true)
    return true
}

struct HabitShare_Previews: PreviewProvider {
    static var previews: some View {
        HabitShare(habit: FlHabit.habit1)
            .environmentObject(AppSetting())
    }
}
