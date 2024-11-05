//
//  MessageGrouperTests.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

@testable import ChatFlow
import Foundation
import Testing

struct MessageGrouperTests {
    // MARK: - Helper Method

    private func makeSUT() -> MessageGrouper {
        return MessageGrouper()
    }
    
    @Test
    func testGroupingMessagesWithTimestamps() {
        // Given
        let now = Date()
        let messages = [
            Message(text: "First message", isSentByUser: true, timestamp: now.addingTimeInterval(-3600)), // 1 hour ago
            Message(text: "Second message", isSentByUser: false, timestamp: now.addingTimeInterval(-3000)), // 50 minutes ago
            Message(text: "Third message", isSentByUser: true, timestamp: now.addingTimeInterval(-1800)), // 30 minutes ago
            Message(text: "Fourth message", isSentByUser: false, timestamp: now.addingTimeInterval(-100)), // 1 minute ago
            Message(text: "Fifth message", isSentByUser: true, timestamp: now) // Now
        ]
        
        let messageGrouper = makeSUT()
        
        // When
        let groupedMessages = messageGrouper.groupMessagesWithTimestamps(messages)
        
        // Then
        #expect(groupedMessages.count == 6)
        
        #expect(groupedMessages[1].message.text == "First message")
        #expect(groupedMessages[1].spacing == 12)
        
        #expect(groupedMessages[2].message.text == "Second message")
        #expect(groupedMessages[2].spacing == 12)
        
        #expect(groupedMessages[4].message.text == "Fourth message")
        #expect(groupedMessages[4].spacing == 12)
    }
    
    @Test
    func testGroupingMessagesWithSingleTimestamp() {
        // Given
        let now = Date()
        let messages = [
            Message(text: "Single message", isSentByUser: true, timestamp: now)
        ]
        
        let messageGrouper = makeSUT()
        
        // When
        let groupedMessages = messageGrouper.groupMessagesWithTimestamps(messages)
        
        // Then
        #expect(groupedMessages.count == 2)
        #expect(groupedMessages[1].message.text == "Single message")
        #expect(groupedMessages[1].spacing == 12)
    }
    
    @Test
    func testGroupingMessagesWithNoMessages() {
        // Given
        let messages: [Message] = []
        
        let messageGrouper = makeSUT()
        
        // When
        let groupedMessages = messageGrouper.groupMessagesWithTimestamps(messages)
        
        // Then
        #expect(groupedMessages.isEmpty == true)
    }
}
