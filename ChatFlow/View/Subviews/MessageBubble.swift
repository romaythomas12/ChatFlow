//
//  MessageBubble.swift
//  ChatFlow
//
//  Created by Thomas Romay on 03/11/2024.
//

import Foundation
import SwiftUI

struct MessageBubble: View {
    var message: Message
    let senderMessageColor = Color.lightPink
    let receiverMessageColor = Color.smokeWhite
    var body: some View {
        HStack {
            if message.isSentByUser { Spacer() }

            if message.isEmojiOnly {
                EmojiTextView(message: message.text)
            } else {
                Text(message.text)
                    .messageStyle(
                        isSentByUser: message.isSentByUser,
                        senderColor: senderMessageColor,
                        receiverColor: receiverMessageColor
                    )
                    .frame(maxWidth: .infinity, alignment: message.isSentByUser ? .trailing : .leading)
                    .padding(message.isSentByUser ? .leading : .trailing, 40)
                    .overlay(
                        StatusView(status: message.status)
                            .padding(.bottom, 5)
                            .padding(.trailing, 5),
                        alignment: .bottomTrailing
                    )
            }
            if !message.isSentByUser { Spacer() }
        }
        .padding(message.isSentByUser ? .leading : .trailing, 50)
    }
}

#Preview {
    MessageBubble(message: .init(text: "Hello", isSentByUser: true, status: .delivered))
}

// MARK: - Subviews

struct EmojiTextView: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.largeTitle)
            .padding(4)
    }
}

struct StatusView: View {
    var status: MessageStatus

    var body: some View {
        HStack(spacing: -8) {
            if status == .sent || status == .delivered || status == .read {
                Image(systemName: "checkmark")
                    .foregroundColor(.white.opacity(0.7))
            }
            if status == .delivered || status == .read {
                Image(systemName: "checkmark")
                    .foregroundColor(.white.opacity(0.7))
            }
            if status == .read {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
            }
        }
        .font(.caption)
    }
}
