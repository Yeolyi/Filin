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
    
    @State var _isExpanded = false
    var isExpanded: Binding<Bool> {
        Binding(
            get: {_isExpanded},
            set: {
                _isExpanded = $0
                if $0 && (imageAspect == .square || imageAspect == .fourThree) {
                    imageAspect = .fourFive
                }
            }
        )
    }
    
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
                            isExpanded: isExpanded, selectedDate: $selectedDate, habit1: habit)
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
            VStack(spacing: 0) {
                Text("Image Share")
                    .sectionText()
                    .padding(.bottom, 20)
                HStack {
                    Text("Expand".localized)
                        .bodyText()
                    Spacer()
                    PaperToggle(isExpanded)
                }
                .flatRowBackground()
                HStack {
                    Text("Calendar Mode".localized)
                        .bodyText()
                    Spacer()
                    Button(action: {isEmojiView = false}) {
                        Image(systemName: "calendar")
                            .font(.system(size: 25))
                            .frame(width: 44, height: 44)
                            .foregroundColor(
                                isEmojiView ? ThemeColor.subColor(colorScheme) : ThemeColor.mainColor(colorScheme)
                            )
                    }
                    Button(action: {isEmojiView = true}) {
                        Image(systemName: "face.smiling")
                            .font(.system(size: 25))
                            .frame(width: 44, height: 44)
                            .foregroundColor(
                                !isEmojiView ? ThemeColor.subColor(colorScheme) : ThemeColor.mainColor(colorScheme)
                            )
                    }
                }
                .flatRowBackground(innerBottomPadding: true, 5)
                VStack {
                    HStack {
                        Text("Set Date".localized)
                            .bodyText()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showCalendarSelect.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .frame(width: 44, height: 44)
                                .mainColor()
                                .rotationEffect(showCalendarSelect ? .degrees(90) : .degrees(0))
                        }
                    }
                    if showCalendarSelect {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    }
                }
                .flatRowBackground(innerBottomPadding: true, 5)
            }
            HStack(spacing: 10) {
                Button(action: {imageAspect = .free}) {
                    Text("  \("Free".localized)  ")
                        .foregroundColor(
                            imageAspect == .free ?
                                ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                        )
                        .bodyText()
                        .flatRowBackground(innerBottomPadding: true, 10, 0, 0)
                }
                if isExpanded.wrappedValue == false {
                    Button(action: {imageAspect = .square}) {
                        Text("  \("Square".localized)  ")
                            .foregroundColor(
                                imageAspect == .square ?
                                    ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                            )
                            .bodyText()
                            .flatRowBackground(innerBottomPadding: true, 10, 0, 0)
                    }
                    Button(action: {imageAspect = .fourThree}) {
                        Text("  \("4:3".localized)  ")
                            .foregroundColor(
                                imageAspect == .fourThree ?
                                    ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                            )
                            .bodyText()
                            .flatRowBackground(innerBottomPadding: true, 10, 0, 0)
                    }
                }
                Button(action: {imageAspect = .fourFive}) {
                    Text("  \("4:5".localized)  ")
                        .foregroundColor(
                            imageAspect == .fourFive ?
                                ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                        )
                        .bodyText()
                        .flatRowBackground(innerBottomPadding: true, 10, 0, 0)
                }
                Spacer()
            }
            .padding(.leading, 10)
            Divider()
                .padding(.vertical, 15)
            CaptureCalendar(
                showCalendarSelect: .constant(false), isEmojiView: $isEmojiView,
                isExpanded: isExpanded, selectedDate: $selectedDate, habit1: habit
            )
            .environmentObject(appSetting)
            .if(imageAspect != .free) {
                $0.frame(width: imageAspect.sizeTuple.width, height: imageAspect.sizeTuple.height)
            }
            .padding(20)
            .rowBackground()
            Divider()
                .padding(.vertical, 15)
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
                    .flatRowBackground(innerBottomPadding: true, 15)
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
                    .flatRowBackground(innerBottomPadding: true, 15)
                }
            }
            .padding(.top, 1)
            .padding(.bottom, 20)
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
