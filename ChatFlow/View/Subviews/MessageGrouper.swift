//
//  MessageGrouper.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import Foundation
import SwiftUI

class MessageGrouper {
    func groupMessagesWithTimestamps(_ messages: [Message]) -> [GroupedMessage] {
        var result: [GroupedMessage] = []
        var previousMessage: Message?

        for message in messages {
            // Add timestamp at start or if more than an hour since the previous message
            if result.isEmpty || Calendar.current.dateComponents([.hour], from: previousMessage?.timestamp ?? Date(), to: message.timestamp).hour ?? 0 >= 1 {
                let timestampMessage = Message(timestamp: message.timestamp)
                result.append(GroupedMessage(message: timestampMessage, spacing: 20))
            }

            // Adjust spacing for messages within 20 seconds
            let spacing: CGFloat = (previousMessage != nil && message.timestamp.timeIntervalSince(previousMessage!.timestamp) < 20) ? 4 : 12
            result.append(GroupedMessage(message: message, spacing: spacing))
            previousMessage = message
        }

        return result
    }
}
