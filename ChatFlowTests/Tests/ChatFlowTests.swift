//
//  ChatFlowTests.swift
//  ChatFlowTests
//
//  Created by Thomas Romay on 03/11/2024.
//

@testable import ChatFlow
import Foundation
import RealmSwift
import Testing

struct ChatRepositoryTests {
    // MARK: - Tests

    @MainActor
    @Test func testSyncMessages_RemoteSuccess() async throws {
        // Setup
        let remote = MockRemoteChatRepository(fetchMessagesResult: .success([Message(text: "Hello", isSentByUser: true)]))
        let local = MockLocalChatRepository()
        let repository = ChatRepository(remoteService: remote, localService: local)
        
        // Test
        let messages = try await repository.syncMessages()
        
        #expect(messages.count == 1)
        #expect(messages.first?.text == "Hello")
    }
    
    @MainActor
    @Test func testSyncMessages_RemoteFailure_FallbackToLocal() async throws {
        // Setup
        let remote = MockRemoteChatRepository(fetchMessagesResult: .failure(URLError(.unknown)))
        let local = MockLocalChatRepository(fetchMessagesResult: .success([Message(text: "Local Message", isSentByUser: true)]))
        let repository = ChatRepository(remoteService: remote, localService: local)
        
        // Test
        let messages = try await repository.syncMessages()
        
        #expect(messages.count == 1)
        #expect(messages.first?.text == "Local Message")
    }
    
    @MainActor
    @Test func testUpdateMessageStatus() async throws {
        // Setup
        let local = MockLocalChatRepository(updateMessageStatusResult: .success(()))
        let repository = ChatRepository(remoteService: MockRemoteChatRepository(), localService: local)
        
        let messageId = ObjectId()
        try await repository.updateMessageStatus(id: messageId, status: .read)
        
        #expect(local.updateMessageStatusResult.isSuccess == true)
    }
}

extension Result {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
}
