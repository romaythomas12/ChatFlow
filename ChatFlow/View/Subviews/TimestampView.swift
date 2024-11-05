//
//  TimestampView.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import SwiftUI

struct TimestampView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(5)
            .frame(maxWidth: .infinity)
    }
}
