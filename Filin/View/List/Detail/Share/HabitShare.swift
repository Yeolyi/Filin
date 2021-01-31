//
//  HabitShare.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/19.
//

import SwiftUI

struct HabitShare: View {
    
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
    
    var calendarImage: UIImage {
        CalendarWithLogo(
            isExpanded: _isExpanded, habit: habit,
            imageAspect: imageAspect, isEmojiView: isEmojiView, selectedDate: selectedDate, appSetting: appSetting
        )
        .padding(20) // 비율 맞게 패딩값 조절하기
        .asImage()
    }
    
    func settingRow<Content: View>(_ label: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        HStack {
            Text(label)
                .bodyText()
            Spacer()
            content()
        }
        .flatRowBackground(innerBottomPadding: true, 8, 0, 10)
    }
    
    @ViewBuilder
    func imageSizeSelectButton(_ imageAspect: ImageSize) -> some View {
        Button(action: {self.imageAspect = imageAspect}) {
            Text("  \(imageAspect.localized)  ")
                .foregroundColor(
                    self.imageAspect == imageAspect ?
                        ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                )
                .bodyText()
                .flatRowBackground(innerBottomPadding: true, 10, 0, 0)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Image Share")
                    .sectionText()
                    .padding(.bottom, 15)
                settingRow("Expand".localized) {
                    PaperToggle(isExpanded)
                        .padding(.vertical, 10)
                }
                settingRow("Calendar Mode".localized) {
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
                settingRow("Set Date".localized) {
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
                HStack(spacing: 10) {
                    imageSizeSelectButton(.free)
                    if isExpanded.wrappedValue == false {
                        imageSizeSelectButton(.square)
                        imageSizeSelectButton(.fourThree)
                    }
                    imageSizeSelectButton(.fourFive)
                    Spacer()
                }
                .padding(.leading, 10)
                Group {
                    Divider()
                        .padding(.top, 20)
                    CalendarWithLogo(
                        isExpanded: _isExpanded, habit: habit,
                        imageAspect: imageAspect, isEmojiView: isEmojiView, selectedDate: selectedDate, appSetting: appSetting
                    )
                    Divider()
                        .padding(.bottom, 20)
                }
                settingRow("Save/Share".localized) {
                    Button(action: {
                        share(items: [calendarImage])
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 25))
                            .frame(width: 44, height: 44)
                            .mainColor()
                    }
                }
                settingRow("Instagram Story".localized) {
                    Button(action: {
                        SharingHandler.instagramStory(imageData: calendarImage.pngData()!, colorScheme: colorScheme)
                    }) {
                        Image("Instagram_AppIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 10)
                    }
                    .frame(height: 44)
                }
            }
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
