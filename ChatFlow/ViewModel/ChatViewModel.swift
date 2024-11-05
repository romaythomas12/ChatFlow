//
//  ChatViewModel.swift
//  ChatFlow
//
//  Created by Thomas Romay on 03/11/2024.
//

import RealmSwift
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    enum State: Equatable {
        case initial
        case loading
        case loaded
        case error(String)
    }
    
    static let sampleUser = "Jane" // Mock sender name, this sould be replaced with the API data
    
    @Published var groupedMessages: [GroupedMessage] = []
    @Published var inputText = ""
    @Published var scrollAnchor: UnitPoint = .bottom
    @Published var messageBeingSent: Message? = nil
    @Published var state: State = .initial
    
    private let chatRepository: any ChatRepositoryProtocol
    private let chatService: any MockChatServiceProtocol
    private let messageGrouper: MessageGrouper
    
    var isTextFieldNotEmpty: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(chatRepository: any ChatRepositoryProtocol = ChatRepository(),
         chatService: any MockChatServiceProtocol = MockChatService(),
         messageGrouper: MessageGrouper = MessageGrouper()) {
        self.chatRepository = chatRepository
        self.chatService = chatService
        self.messageGrouper = messageGrouper
        Task {
            await loadMessages()
        }
    }
    
    // MARK: - Message Loading
    
    func loadMessages() async {
        state = .loading
    
        do {
            let messages = try await chatRepository.syncMessages()
            groupedMessages = messageGrouper.groupMessagesWithTimestamps(messages) // Use MessageGrouper
            state = .loaded
        } catch {
            state = .error("Failed to load messages")
        }
    }
    
    func prepareMessage() {
        let newMessage = Message(text: inputText, isSentByUser: true, status: .sent)
        messageBeingSent = newMessage
    }
    
    func clearMessage() {
        messageBeingSent = nil
        inputText = "" // Reset input field
    }
    
    // MARK: - Sending and Receiving Messages
    
    func sendMessage() async {
        guard isTextFieldNotEmpty, let messageBeingSent else { return }
        
        do {
            try await chatRepository.updateMessages(messageBeingSent)
            updateGroupedMessages()
            clearMessage() // Clear input after sending

            // Handle server response
            await handleServerResponse(for: messageBeingSent)
        } catch {
            state = .error("Failed to send message")
        }
    }
    
    func handleServerResponse(for message: Message) async {
        do {
            // Simulate status update and receive response
            await chatService.simulateMessageStatusUpdate(for: message.id, status: .delivered)
            await updateMessageStatus(messageID: message.id, status: .delivered)
            
            // Receive auto-reply
            let responseMessage = await chatService.simulateAutoReply(to: message.text)
            try await chatRepository.updateMessages(responseMessage)
            updateGroupedMessages()
        } catch {
            state = .error("Failed to handle server response")
        }
    }
    
    // MARK: - Grouped Messages Management
    
    private func updateGroupedMessages() {
        Task {
            do {
                let messages = try await chatRepository.syncMessages()
                groupedMessages = messageGrouper.groupMessagesWithTimestamps(messages) // Use MessageGrouper
            } catch {
                state = .error("Failed to update grouped messages")
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func updateMessageStatus(messageID: ObjectId, status: MessageStatus) async {
        try? await chatRepository.updateMessageStatus(id: messageID, status: status)
        updateGroupedMessages()
    }
}
