//
//  EmojiListEdit.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct EmojiListEdit: View {
    
    @StateObject var listData: FlListModel<String> = FlListModel(values: [], save: {_ in})
    @State var newEmoji = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var emojiManager: EmojiManager
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Edit emoji".localized)
                    .foregroundColor(ThemeColor.brand)
                    .bodyText()
                    .frame(maxWidth: .infinity)
                Spacer()
                TextButton(content: {
                    Text("Save".localized)
                }) {
                    emojiManager.emojiList = listData.allValues
                    self.presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 20)
            HStack {
                TextFieldWithEndButton("Enter an emoji to add".localized, text: $newEmoji)
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
            .flatRowBackground()
            .padding(.top, 10)
            FlList(listData: listData) { emoji in
                HStack(spacing: 5) {
                    IconButton(imageName: "minus.circle") {
                        withAnimation {
                            listData.remove(emoji)
                        }
                    }
                    Text(listData.value(of: emoji))
                        .headline()
                }
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            for a in emojiManager.emojiList {
                self.listData.append(a)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    
}

struct EmojiListEdit_Previews: PreviewProvider {
    static var previews: some View {
        EmojiListEdit()
            .environmentObject(EmojiManager())
    }
}
