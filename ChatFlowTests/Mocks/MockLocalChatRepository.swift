//
//  Mock.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//
@testable import ChatFlow
import RealmSwift
import Testing

final class MockLocalChatRepository: LocalChatRepositoryProtocol {
    let fetchMessagesResult: Result<[Message], Error>
    let storeResult: Result<Void, Error>
    let updateMessageStatusResult: Result<Void, Error>
    
    init(fetchMessagesResult: Result<[Message], Error> = .success([Message(text: "Hello",
                                                                           isSentByUser: true)]),
    storeResult: Result<Void, Error> = .success(()),
    updateMessageStatusResult: Result<Void, Error> = .success(())) {
        self.fetchMessagesResult = fetchMessagesResult
        self.storeResult = storeResult
        self.updateMessageStatusResult = updateMessageStatusResult
    }
    
    func fetchMessages() async throws -> [Message] {
        try fetchMessagesResult.get()
    }
    
    func store(_ messages: [Message]) async throws {
        try storeResult.get()
    }
    
    func store(_ message: Message) async throws {
        try storeResult.get()
    }
    
    func updateMessageStatus(id: ObjectId, status: MessageStatus) async throws {
        try updateMessageStatusResult.get()
    }
}
