//
//  MessageStyle.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import SwiftUI

struct MessageStyle: ViewModifier {
    var isSentByUser: Bool
    var senderColor: Color
    var receiverColor: Color

    func body(content: Content) -> some View {
        content
            .padding(15)
            .padding(.trailing, 25)
            .font(.body)
            .background(isSentByUser ? senderColor : receiverColor)
            .foregroundColor(isSentByUser ? .white : .black.opacity(0.65))
            .clipShape(
                .rect(
                    topLeadingRadius: 15,
                    bottomLeadingRadius: isSentByUser ? 15 : 0,
                    bottomTrailingRadius: isSentByUser ? 0 : 15,
                    topTrailingRadius: 15
                )
            )
    }
}

extension View {
    func messageStyle(isSentByUser: Bool, senderColor: Color, receiverColor: Color) -> some View {
        self.modifier(MessageStyle(isSentByUser: isSentByUser, senderColor: senderColor, receiverColor: receiverColor))
    }
}
