//
//  HeaderButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct BasicImage: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .subColor()
            .font(.system(size: 24, weight: .semibold))
    }
}

struct BasicButton: View {
    let action: () -> Void
    let imageName: String
    
    init(_ imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .subColor()
                .font(.system(size: 24, weight: .semibold))
        }
        .frame(width: 44, height: 35)
    }
}

struct BasicTextButton: View {
    let action: () -> Void
    let text: String
    @Environment(\.colorScheme) var colorScheme
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .subColor()
                .font(.system(size: 18, weight: .semibold))
        }
    }
}

struct HeaderButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void
    let imageName: String
    
    init(_ imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 18, weight: .semibold))
                .mainColor()
        }
        .frame(width: 44, height: 35)
    }
}

struct HeaderText: View {
    
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void
    let text: String
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .mainColor()
        }
        .frame(width: 44, height: 35)
    }
}
