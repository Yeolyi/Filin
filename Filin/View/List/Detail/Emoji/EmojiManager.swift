//
//  EmojiManager.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

class EmojiManager: ObservableObject {
    @AutoSave("emojiList", defaultValue: ["😍", "😭", "😆", "🥲", "🥳"])
    var emojiList: [String] {
        didSet {
            objectWillChange.send()
        }
    }
}
