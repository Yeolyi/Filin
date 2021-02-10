//
//  ShareHandler.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct SharingHandler {
    static func instagramStory(imageData: Data, colorScheme: ColorScheme) {
        guard let instagramUrl = URL(string: "instagram://app") else {
            return
        }
        if UIApplication.shared.canOpenURL(instagramUrl) {
            // share something on Instagram
            let urlScheme = URL(string: "instagram-stories://share?source_application=com.wannasleep.fillin")
            if let urlScheme = urlScheme {
                if UIApplication.shared.canOpenURL(urlScheme) {
                    // Assign background image asset to pasteboard
                    let pasteboardItems: [[String: Any]]?
                        = [
                            ["com.instagram.sharedSticker.backgroundImage": imageData
                            ]
                        ]
                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
                    // This call is iOS 10+, can use 'setItems' depending on what versions you support
                    if let pasteboardItems = pasteboardItems {
                        UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                    }
                    UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
                } else {
                    // Handle older app versions or app not installed case
                }
            } else {
                // Instagram app is not installed or can't be opened, pop up an alert
            }
        }
    }
}
