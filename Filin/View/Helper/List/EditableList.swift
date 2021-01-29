//
//  ListData.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

class EditableList<Value: Hashable>: ObservableObject {
    
    @Published var list: [RowData<Value>] = []
    @Published private var dragGestureLength: CGFloat = 0
    @Published private var unclippedContentPosition: CGFloat = 0
    
    let rowHeight: CGFloat = 50
    let padding: CGFloat = 5
    var totalHeight: CGFloat {
        CGFloat(list.count) * (padding + rowHeight)
    }
    
    var allValues: [Value] {
        list.sorted(by: {$0.yPosition < $1.yPosition}).map {$0.value}
    }
    
    var listContentOffset: CGFloat {
        unclippedContentPosition + dragGestureLength
    }
    
    func value(of id: UUID) -> Value {
        list.first(where: {$0.id == id})!.value
    }
    
    func append(_ value: Value) {
        let id = UUID()
        list.append(.init(id, value, CGFloat(list.count) * (rowHeight + padding)))
        previousList = list.map(\.id)
    }
    
    func remove(_ id: UUID) {
        let targetIndex = index(of: id)
        list.remove(at: index(of: id))
        for i in targetIndex..<list.count {
            list[i].yPosition = CGFloat(i) * (rowHeight + padding)
        }
        previousList = list.map(\.id)
    }
    
    func rowScrollGesture(maxHeight: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                self.dragGestureLength = value.translation.height / 2
            }
            .onEnded { _ in
                withAnimation {
                    self.unclippedContentPosition += self.dragGestureLength
                    self.dragGestureLength = 0
                    // 아래에 빈 공간이 있는 경우
                    if -self.unclippedContentPosition > self.totalHeight - maxHeight {
                        self.unclippedContentPosition = maxHeight - self.totalHeight
                    }
                    // 위에 빈 공간이 있는 경우
                    if self.unclippedContentPosition > 0 {
                        self.unclippedContentPosition = 0
                    }
                }
            }
    }
    
    func rowDragGesture(id: UUID) -> some Gesture {
        DragGesture()
            .onChanged { [self] dragData in
                // 진동을 울릴지 확인
                let supposeReordered = list.sorted(by: {$0.position < $1.position}).map(\.id)
                if previousList != supposeReordered {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                self.previousList = supposeReordered
                // 드래그되는 row 이동
                let targetRow = list[index(of: id)]
                targetRow.offset += dragData.translation.height
                targetRow.isTapped = true
                // 다른 row의 위치 수정
                changeOffsetWhileDrag(dragged: targetRow.id)
                objectWillChange.send()
            }
            .onEnded { [self] _ in
                self.list.sort(by: {$0.position < $1.position})
                for (index, rowData) in self.list.enumerated() {
                    rowData.offset = 0
                    rowData.yPosition = CGFloat(index) * (rowHeight + padding)
                    rowData.isTapped = false
                }
                save(allValues)
                objectWillChange.send()
            }
    }
    
    private func changeOffsetWhileDrag(dragged: UUID) {
        let supposeReordered = list.sorted(by: {$0.position < $1.position})
        for rowData in list where rowData.id != dragged {
            let newIndex = supposeReordered.firstIndex(where: {rowData.id == $0.id})!
            let currentIndex = index(of: rowData.id)
            if currentIndex < newIndex {
                rowData.offset = rowHeight + padding
            } else if currentIndex > newIndex {
                rowData.offset = -(rowHeight + padding)
            }
        }
    }
    
    private let save: ([Value]) -> Void
    private var previousList: [UUID] = []
    
    private func index(of id: UUID) -> Int {
        list.firstIndex(where: {$0.id == id})!
    }
    
    init(values: [Value], save: @escaping ([Value]) -> Void) {
        self.save = save
        list = values.enumerated().map { index, value in
            RowData(UUID(), value, CGFloat(index) * (rowHeight + padding))
        }
        previousList = list.map(\.id)
    }
    
}
