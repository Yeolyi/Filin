//
//  ContentView.swift
//  CustomList
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI

struct EditableListView<Value: Hashable, Content: View>: View {
    
    @ObservedObject var listData: EditableList<Value>
    @Environment(\.colorScheme) var colorScheme
    let idToRow: (UUID) -> Content
    
    init(listData: EditableList<Value>, view: @escaping (UUID) -> Content) {
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
                            Image(systemName: "pause")
                                .rotationEffect(.degrees(-90))
                                .subColor()
                                .font(.system(size: 18, weight: .semibold))
                                .gesture(
                                    listData.rowDragGesture(id: listElement.id)
                                )
                        }
                        .frame(height: listData.rowHeight)
                        .padding(.bottom, listData.padding)
                        .background(
                            Rectangle()
                                .foregroundColor(colorScheme == .light ? .white : .black)
                        )
                        .compositingGroup()
                        .shadow(radius: listElement.isTapped ? 2 : 0)
                        .offset(y: listElement.position - geo.size.height / 2 + listData.rowHeight / 2)
                        .zIndex(listElement.isTapped ? 1 : 0)
                    }
                }
                .gesture(
                    listData.rowScrollGesture(maxHeight: geo.size.height)
                )
                .offset(y: listData.listContentOffset)
                .zIndex(1)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .gesture(
                        listData.rowScrollGesture(maxHeight: geo.size.height)
                    )
                    .zIndex(0)
            }
        }
        .clipped()
    }
}
