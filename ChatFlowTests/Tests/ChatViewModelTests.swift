//
//  ChatViewModelTests.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

@testable import ChatFlow
import Foundation
import Testing

class ChatViewModelTests {
    // MARK: - Helper Method

    @MainActor private func makeSUT(
        mockMessages: [Message] = [],
        shouldFail: Bool = false,
        shouldFailOnUpdate: Bool = false
    ) -> ChatViewModel {
        let chatRepository = MockChatRepository(
            mockMessages: mockMessages,
            shouldFail: shouldFail,
            shouldFailOnUpdate: shouldFailOnUpdate
        )
        let mockChatService = MockChatService()
        return ChatViewModel(chatRepository: chatRepository, chatService: mockChatService)
    }

    // MARK: - Tests

    @MainActor
    @Test func testLoadMessagesSuccess() async {
        // Given
        let messages = [
            Message(text: "Hello!", isSentByUser: true, status: .sent),
            Message(text: "Hi there!", isSentByUser: false, status: .sent)
        ]
        let viewModel = makeSUT(mockMessages: messages)
        
        // When
       
        await viewModel.loadMessages()
        
        // Then
        #expect(viewModel.groupedMessages.count == 3) // 2 messages + 1 timestamp
        #expect(viewModel.state == .loaded)
    }
    
    @MainActor
    @Test func testLoadMessagesFailure() async {
        // Given
        let viewModel = makeSUT(shouldFail: true)
        
        // When
        await viewModel.loadMessages()
        
        // Then
        #expect(viewModel.state == .error("Failed to load messages"))
        #expect(viewModel.groupedMessages.isEmpty == true)
    }
    
    @MainActor
    @Test func testSendMessageSuccess() async {
        // Given
        let viewModel = makeSUT()
        viewModel.inputText = "Test message"
        viewModel.prepareMessage()
        
        // When
   
        await viewModel.loadMessages()
        await viewModel.sendMessage()
        
        // Then
        #expect(viewModel.state == .loaded)
        #expect(viewModel.groupedMessages.count == 2)
        #expect(viewModel.groupedMessages.last?.message.text == "Test message")
    }
    
    @MainActor
    @Test func testSendMessageFailure() async {
        // Given
        let viewModel = makeSUT(shouldFailOnUpdate: true)
        viewModel.inputText = "Test message"
        viewModel.prepareMessage()
        
        // When
        await viewModel.sendMessage()
        
        // Then
        #expect(viewModel.state == .error("Failed to send message"))
        #expect(viewModel.groupedMessages.isEmpty == true) // No messages should be sent
    }
    
    @MainActor
    @Test func testClearMessage() async {
        // Given
        let viewModel = makeSUT()
        viewModel.inputText = "Message to clear"
        
        // When
        viewModel.clearMessage()
        
        // Then
        #expect(viewModel.inputText.isEmpty == true)
        #expect(viewModel.messageBeingSent == nil)
    }
}
