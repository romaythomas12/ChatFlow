//
//  MockChatRepository.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

@testable import ChatFlow
import Foundation
import RealmSwift

// MARK: - Mock Repository

final class MockChatRepository: ChatRepositoryProtocol {
    var mockMessages: [Message]
    let shouldFail: Bool
    let shouldFailOnUpdate: Bool
    
    init(mockMessages: [Message] = [], shouldFail: Bool = false, shouldFailOnUpdate: Bool = false) {
        self.mockMessages = mockMessages
        self.shouldFail = shouldFail
        self.shouldFailOnUpdate = shouldFailOnUpdate
    }
    
    func syncMessages() async throws -> [Message] {
        if shouldFail {
            throw NSError(domain: "TestError", code: 0, userInfo: nil)
        }
        return mockMessages
    }
    
    func updateMessages(_ message: Message) async throws {
        if shouldFailOnUpdate {
            throw NSError(domain: "TestError", code: 0, userInfo: nil)
        }
        mockMessages.append(message)
    }
    
    func updateMessageStatus(id: ObjectId, status: MessageStatus) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000) //
    }
}
