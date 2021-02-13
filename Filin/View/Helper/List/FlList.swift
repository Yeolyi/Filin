//
//  ContentView.swift
//  CustomList
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI

struct FlList<Value: Hashable, Content: View>: View {
    
    @ObservedObject var listData: FlListModel<Value>
    @Environment(\.colorScheme) var colorScheme
    let idToRow: (UUID) -> Content
    
    init(listData: FlListModel<Value>, view: @escaping (UUID) -> Content) {
        self.listData = listData
        self.idToRow = view
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    ForEach(listData.list, id: \.self) { listElement in
                        HStack(spacing: 0) {
                            idToRow(listElement.id)
                            Spacer()
                            IconButtonWithoutGesture(imageName: "pause") { }
                            .rotationEffect(.degrees(-90))
                            .highPriorityGesture(
                                listData.rowDragGesture(id: listElement.id)
                            )
                        }
                        .padding(.horizontal, 10)
                        .frame(height: listData.rowHeight)
                        .background(ThemeColor.inActive(colorScheme))
                        .cornerRadius(8)
                        .padding(.bottom, listData.padding)
                        .offset(y: listElement.position - geo.size.height / 2 + listData.rowHeight / 2)
                        .zIndex(listElement.isTapped ? 1 : 0)
                    }
                }
                .offset(y: listData.listContentOffset)
            }
            .padding(.top, 20)
            .frame(height: geo.size.height)
            .contentShape(Rectangle())
            .gesture(
                listData.rowScrollGesture(maxHeight: geo.size.height)
            )
            .clipped()
        }
    }
}

struct EditableListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlList(listData: FlListModel(values: ["1", "2", "3", "4", "5", "6", "7", "8"], save: {_ in})) { id in
                Text(id.uuidString)
            }.padding(.horizontal, 10)
            .frame(height: 400)
        }
    }
}
