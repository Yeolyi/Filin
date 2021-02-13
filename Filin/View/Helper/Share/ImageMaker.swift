//
//  ImageMaker.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/04.
//

import SwiftUI

enum ImageSize {
    case fourThree
    case fourFive
    case free
    case square
    var sizeTuple: (width: CGFloat, height: CGFloat) {
        switch self {
        case .fourThree:
            return (400, 300)
        case .fourFive:
            return (400, 500)
        case .free:
            return (0, 0)
        case .square:
            return (400, 400)
        }
    }
    var localized: String {
        switch self {
        case .fourThree:
            return "4:3"
        case .fourFive:
            return "4:5"
        case .free:
            return "Free".localized
        case .square:
            return "Square".localized
        }
    }
    var paddingSize: (horizontal: CGFloat, vertical: CGFloat) {
        switch self {
        case .free, .square:
            return (20, 20)
        case .fourFive:
            return (20, 25)
        case .fourThree:
            return (20, 15)
        }
    }
}

struct ImageMaker<Content: View>: View {
    
    var content: Content
    let imageSize: ImageSize
    
    @Environment(\.colorScheme) var colorScheme
    
    init(imageSize: ImageSize, @ViewBuilder _ content: @escaping () -> Content) {
        self.imageSize = imageSize
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
            HStack(spacing: 4) {
                Spacer()
                Image("icon_border")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("FILIN")
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.trailing, 10)
        }
        .if(imageSize != .free) {
            $0.frame(width: imageSize.sizeTuple.width, height: imageSize.sizeTuple.height)
        }
        .if(imageSize == .free) {
            $0.frame(width: 400)
        }
        .padding(.horizontal, imageSize.paddingSize.horizontal)
        .padding(.vertical, imageSize.paddingSize.vertical)
    }
}

struct ImageMaker_Previews: PreviewProvider {
    static var previews: some View {
        ImageMaker(imageSize: .square) {
            Text("Hello")
        }
        .border(Color.black)
    }
}
