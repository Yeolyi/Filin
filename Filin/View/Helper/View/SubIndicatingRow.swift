//
//  SubIndicatingRow.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/07.
//

import SwiftUI

struct SubIndicatingRow: View {
    let label: String
    var body: some View {
        HStack {
            Spacer()
            Text(label)
                .subColor()
                .bodyText()
            Spacer()
        }
        .flatRowBackground()
    }
}

struct SubIndicatingRow_Previews: PreviewProvider {
    static var previews: some View {
        SubIndicatingRow(label: "Test")
    }
}
