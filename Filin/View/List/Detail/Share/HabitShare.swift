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
                updateImage()
            }
        )
    }
    
    var selectedDate: Binding<Date> {
        Binding(
            get: {_selectedDate},
            set: {_selectedDate = $0; updateImage()}
        )
    }
    
    @State var _selectedDate = Date()
    @State var showCalendarSelect = false
    @State var isEmojiView = false
    @State private var imageAspect: ImageSize = .free
    @State var calendarImage: UIImage?
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.presentationMode) var presentationMode
    
    func updateImage() {
        calendarImage = CalendarWithLogo(
            isExpanded: _isExpanded, habit: habit,
            imageAspect: imageAspect, isEmojiView: isEmojiView,
            selectedDate: selectedDate.wrappedValue, appSetting: appSetting
        )
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
        Button(action: {
            self.imageAspect = imageAspect
            updateImage()
        }) {
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
                Text("Calendar Share".localized)
                    .sectionText()
                    .padding(.bottom, 15)
                settingRow("Expand".localized) {
                    PaperToggle(isExpanded)
                        .padding(.vertical, 10)
                }
                settingRow("Calendar Mode".localized) {
                    Button(action: {isEmojiView = false; updateImage()}) {
                        Image(systemName: "calendar")
                            .font(.system(size: 25))
                            .frame(width: 44, height: 44)
                            .foregroundColor(
                                isEmojiView ? ThemeColor.subColor(colorScheme) : ThemeColor.mainColor(colorScheme)
                            )
                    }
                    Button(action: {isEmojiView = true; updateImage()}) {
                        Image(systemName: "face.smiling")
                            .font(.system(size: 25))
                            .frame(width: 44, height: 44)
                            .foregroundColor(
                                !isEmojiView ? ThemeColor.subColor(colorScheme) : ThemeColor.mainColor(colorScheme)
                            )
                    }
                }
                Button(action: {
                    withAnimation {
                        showCalendarSelect.toggle()
                    }
                }) {
                    settingRow("Set Date".localized) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                            .mainColor()
                            .rotationEffect(showCalendarSelect ? .degrees(90) : .degrees(0))
                    }
                }
                if showCalendarSelect {
                    DatePicker("", selection: selectedDate, displayedComponents: [.date])
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
                if calendarImage != nil {
                    Image(uiImage: calendarImage!)
                        .resizable()
                        .scaledToFit()
                        .animation(nil)
                        .rowBackground()
                        .padding(.vertical, 20)
                }
                Button(action: {
                    if let image = calendarImage {
                        share(items: [image])
                    }
                }) {
                    settingRow("Save/Share".localized) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 25))
                            .frame(width: 44, height: 44)
                            .mainColor()
                    }
                }
                Button(action: {
                    if let image = calendarImage {
                        SharingHandler.instagramStory(imageData: image.pngData()!, colorScheme: colorScheme)
                    }
                }) {
                    settingRow("Instagram Story".localized) {
                        Image("Instagram_AppIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 10)
                            .frame(height: 44)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onAppear {
            updateImage()
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
