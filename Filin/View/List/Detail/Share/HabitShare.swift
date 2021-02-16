//
//  HabitShare.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/19.
//

import SwiftUI

struct HabitShare<TargetView: View>: View {
    
    @State private var imageAspect: ImageSize = .free
    @State var calendarImage: UIImage?
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    let target: (ImageSize) -> TargetView
    let aspectPolicy: (ImageSize) -> Bool
    
    init(@ViewBuilder target: @escaping (ImageSize) -> TargetView, aspectPolicy: @escaping (ImageSize) -> Bool) {
        self.target = target
        self.aspectPolicy = aspectPolicy
    }
    
    func updateImage() {
        calendarImage = target(imageAspect).asImage()
    }
    
    func settingRow<Content: View>(_ label: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        HStack {
            Text(label)
                .bodyText()
            Spacer()
            content()
        }
        .flatRowBackground()
    }
    
    @ViewBuilder
    func imageSizeSelectButton(_ imageAspect: ImageSize) -> some View {
        Button(action: {
            self.imageAspect = imageAspect
            updateImage()
        }) {
            Group {
                Text("  \(imageAspect.localized)  ")
                    .foregroundColor(
                        self.imageAspect == imageAspect ?
                            ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                    )
                    .strikethrough(!aspectPolicy(imageAspect), color: ThemeColor.subColor(colorScheme))
                    .bodyText()
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .background(ThemeColor.inActive(colorScheme).opacity(0.5))
            }
            .cornerRadius(5)
            
        }
        .disabled(!aspectPolicy(imageAspect))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                IconButton(imageName: "xmark") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text("Share Image")
                    .bodyText()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
                ScrollView {
                    VStack(spacing: 10) {
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
                        Divider()
                            .padding(.top, 20)
                        Button(action: {
                            if let image = calendarImage {
                                share(items: [image])
                            }
                        }) {
                            settingRow("Save/Share the Image Above".localized) {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.system(size: 25))
                                    .padding(.trailing, 10)
                                    .mainColor()
                            }
                        }
                        Button(action: {
                            if let image = calendarImage {
                                SharingHandler.instagramStory(imageData: image.pngData()!, colorScheme: colorScheme)
                            }
                        }) {
                            settingRow("Share to Instagram Story".localized) {
                                Image("Instagram_AppIcon")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .onAppear {
                updateImage()
            }
    }
}

struct HabitShare_Previews: PreviewProvider {
    static var previews: some View {
        HabitShare(target: { _ in
            Text("Hello")
        }, aspectPolicy: {_ in true})
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
