//
//  EmojiListEdit.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct EmojiListEdit: View {
    
    @State var listData: EditableList<String> = EditableList(values: [], save: {_ in})
    @State var newEmoji = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Edit emoji".localized)
                        .headline()
                    Spacer()
                    Button(action: {
                        emojiManager.emojiList = listData.allValues
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save".localized)
                            .mainColor()
                    }
                }
                .padding(.horizontal, 20)
                Divider()
            }
            .padding(.top, 20)
            HStack {
                TextFieldWithEndButton("Enter a emoji to add".localized, text: $newEmoji)
                    .frame(height: 30)
                Button(action: {
                    if let emoji = newEmoji.first?.description {
                        listData.append(emoji)
                        newEmoji = ""
                    }
                    UIApplication.shared.endEditing()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .mainColor()
                        .padding(.trailing, 10)
                }
            }
            .rowBackground()
            EditableListView(listData: listData) { emoji in
                HStack(spacing: 10) {
                    Button(action: {
                        listData.remove(emoji)
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 20))
                            .mainColor()
                    }
                    Text(listData.value(of: emoji))
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            self.listData = EditableList(values: emojiManager.emojiList, save: { _ in
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
         }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var emojiManager: EmojiManager
    
}

struct EmojiListEdit_Previews: PreviewProvider {
    static var previews: some View {
        EmojiListEdit()
            .environmentObject(EmojiManager())
    }
}
