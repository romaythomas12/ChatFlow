//
//  MockChatServiceProtocol.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//
import Foundation
import RealmSwift

// MARK: - ChatService Protocol

protocol MockChatServiceProtocol {
    func simulateAutoReply(to text: String) async -> Message
    func simulateMessageStatusUpdate(for messageId: ObjectId, status: MessageStatus) async
}

class MockChatService: MockChatServiceProtocol {
    func simulateAutoReply(to text: String) async -> Message {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000) // Simulate a 3-second delay
        return Message(text: "Auto-reply to: \(text)", isSentByUser: false)
    }

    func simulateMessageStatusUpdate(for messageId: ObjectId, status: MessageStatus) async {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // Simulate a 1-second delay for status update
    }
}
