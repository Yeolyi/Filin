//
//  FlTabView.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/12.
//

import SwiftUI


struct FlTabView<Content: View>: View {
    
    let content: () -> Content
    let viewWidth: CGFloat
    let viewNum: Int
    let padding: CGFloat = 20
    
    var lock: Bool
    
    @State var scrollOffset: CGFloat = 0
    
    @Binding var index: Int
    
    var totalWidth: CGFloat {
        viewWidth * CGFloat(viewNum) + padding * (CGFloat(viewNum) - 1)
    }
    
    var calOffset: CGFloat {
        if viewNum == 1 {
            return scrollOffset
        }
        let origin = totalWidth / 2 - viewWidth / 2
        return origin - CGFloat(index) * (viewWidth + padding) + scrollOffset
    }
    
    func getOffset(of index: Int) -> CGFloat {
        let origin = totalWidth / 2 - (viewWidth + padding) / 2
        return origin - CGFloat(index) * (viewWidth + padding)
    }
    
    init(
        index: Binding<Int>, viewWidth: CGFloat,
        viewNum: Int, lock: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._index = index
        self.lock = lock
        self.viewWidth = viewWidth
        self.viewNum = viewNum
        self.content = content
    }
    
    var body: some View {
        LazyHStack(spacing: padding) {
            content()
        }
        .animation(Animation.spring().speed(1.5))
        .gesture(
            DragGesture()
                .onChanged { value in
                    if (lock && scrollOffset < 0) || (index == 0 && scrollOffset > 0)
                        || (index == viewNum - 1 && scrollOffset < 0) {
                        scrollOffset += value.translation.width / 300
                        return
                    }
                    scrollOffset += value.translation.width
                }
                .onEnded { _ in
                    guard !(lock && scrollOffset < 0) else {
                        scrollOffset = 0
                        return
                    }
                    withAnimation {
                        if calOffset - getOffset(of: index) > 30 {
                            index = max(0, self.index - 1)
                        } else if calOffset - getOffset(of: index) < -30 {
                            index = min(viewNum - 1, self.index + 1)
                        }
                        scrollOffset = 0
                    }
                }
        )
        .offset(x: calOffset)
    }
}

struct FlTabView_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var index = 0
        var body: some View {
            VStack(spacing: 40) {
                FlTabView(index: $index, viewWidth: 350, viewNum: 2, lock: false) {
                    Group {
                        Text("A")
                        Text("B")
                    }
                    .frame(width: 330, height: 300)
                    .rowBackground()
                    .frame(width: 350)
                }
                Button(action: {
                    withAnimation { index -= 1 }
                }) {
                    Image(systemName: "minus")
                        .headline()
                }
                Button(action: {
                    withAnimation { index += 1 }
                }) {
                    Image(systemName: "plus")
                        .headline()
                }
            }
        }
    }
    
    static var previews: some View {
      StateWrapper()
    }
}
