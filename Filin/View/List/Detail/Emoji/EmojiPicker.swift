//
//  EmojiPicker.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI
import CoreData

struct EmojiPicker: View {
    
    @ObservedObject var habit: FlHabit
    @ObservedObject var emojiManager: EmojiManager
    
    @Binding var selectedDate: Date
    @Binding var isEmojiView: Bool
    @Binding var activeSheet: DetailViewActiveSheet?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    
    var emoji: String? {
        habit.dailyEmoji[selectedDate.dictKey]
    }
    
    var body: some View {
        ZStack {
            HStack {
                if emoji != nil {
                    Text(emoji!)
                        .font(.system(size: 60))
                } else {
                    Circle()
                        .frame(width: 72, height: 72)
                        .inactiveColor()
                }
                Spacer()
            }
            .zIndex(1)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(emojiManager.emojiList, id: \.self) { emoji in
                        Button(action: {
                            withAnimation {
                                habit.dailyEmoji[selectedDate.dictKey] = emoji
                                isEmojiView = true
                            }
                            save()
                        }) {
                            Text(emoji)
                                .font(.system(size: FontSize.subHeadline.rawValue))
                                .opacity(habit.dailyEmoji[selectedDate.dictKey] == emoji ? 1 : 0.3)
                                .frame(width: 44, height: 30)
                        }
                    }
                    Button(action: {
                        withAnimation {
                            isEmojiView = true
                            habit.dailyEmoji[selectedDate.dictKey] = nil
                        }
                        save()
                    }) {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: FontSize.subHeadline.rawValue))
                            .subColor()
                            .frame(width: 44, height: 30)
                    }
                    Button(action: {
                        activeSheet = DetailViewActiveSheet.emoji
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: FontSize.subHeadline.rawValue))
                            .subColor()
                            .frame(width: 44, height: 30)
                    }
                }
                .frame(height: ButtonSize.large.rawValue)
                .padding(.horizontal, 10)
                .background(ThemeColor.inActive(colorScheme))
                .cornerRadius(8)
                .padding(.leading, 60)
            }
            .padding(.leading, 30)
        }
        .rowBackground()
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker(
            habit: FlHabit.sample(number: 0), emojiManager: EmojiManager(), selectedDate: .constant(Date()),
            isEmojiView: .constant(true), activeSheet: .constant(nil)
        )
    }
}
