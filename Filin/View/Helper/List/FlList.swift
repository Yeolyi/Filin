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
                            Image(systemName: "pause")
                                .rotationEffect(.degrees(-90))
                                .subColor()
                                .font(.system(size: 24, weight: .semibold))
                                .frame(width: 44, height: 40)
                                .gesture(
                                    listData.rowDragGesture(id: listElement.id)
                                )
                        }
                        .padding(.horizontal, 15)
                        .frame(height: listData.rowHeight)
                        .compositingGroup()
                        .background(
                            Rectangle()
                                .foregroundColor(
                                    colorScheme == .light ?
                                    (listElement.isTapped ? Color(hex: "#D0D0D0") : Color(hex: "#F0F0F0")) :
                                        (listElement.isTapped ? Color(hex: "#1F1F1F") : Color(hex: "#0F0F0F"))
                                )
                                .cornerRadius(5)
                        )
                        .padding(.bottom, listData.padding)
                        .offset(y: listElement.position - geo.size.height / 2 + listData.rowHeight / 2)
                        .zIndex(listElement.isTapped ? 1 : 0)
                    }
                }
                .gesture(
                    listData.rowScrollGesture(maxHeight: geo.size.height)
                )
                .zIndex(1)
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        listData.rowScrollGesture(maxHeight: geo.size.height)
                    )
                    .zIndex(0)
            }
            .offset(y: listData.listContentOffset)
        }
        .padding(.top, 20)
        .clipped()
    }
}

struct EditableListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlList(listData: FlListModel(values: ["1", "2", "3"], save: {_ in})) { _ in
                Text("1")
            }.padding(.horizontal, 10)
        }
        .environment(\.colorScheme, .dark)
    }
}
