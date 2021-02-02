//
//  HabitShare.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/19.
//

import SwiftUI

struct HabitShare: View {
    
    let habit: FlHabit
    let selectedDate: Date
    let isEmojiView: Bool
    let isExpanded: Bool
    @State private var imageAspect: ImageSize = .free
    @State var calendarImage: UIImage?
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.presentationMode) var presentationMode
    
    func updateImage() {
        calendarImage = CalendarWithLogo(
            isExpanded: isExpanded, habit: habit,
            imageAspect: imageAspect, isEmojiView: isEmojiView,
            selectedDate: selectedDate, appSetting: appSetting
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
                .strikethrough(isExpanded && imageAspect == .fourThree, color: ThemeColor.subColor(colorScheme))
                .bodyText()
                .flatRowBackground(innerBottomPadding: true, 10, 0, 0)
        }
        .disabled((imageAspect == .fourThree) && isExpanded)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Share".localized)
                    .sectionText()
                Divider()
                    .padding(.bottom, 15)
                if calendarImage != nil {
                    Image(uiImage: calendarImage!)
                        .resizable()
                        .scaledToFit()
                        .animation(nil)
                        .rowBackground()
                }
                HStack(spacing: 10) {
                    imageSizeSelectButton(.free)
                    imageSizeSelectButton(.square)
                    imageSizeSelectButton(.fourThree)
                    imageSizeSelectButton(.fourFive)
                    Spacer()
                }
                .padding(.leading, 10)
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

struct HabitShare_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = DataSample.shared
        return HabitShare(
            habit: dataSample.habitManager.contents[0],
                          selectedDate: Date(), isEmojiView: false, isExpanded: true
        ).environmentObject(AppSetting())
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
