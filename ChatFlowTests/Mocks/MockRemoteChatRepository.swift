//
//  MockRemoteChatRepository.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

@testable import ChatFlow
import Foundation

// MARK: - Mock Implementations

final class MockRemoteChatRepository: RemoteChatRepositoryProtocol {
    let fetchMessagesResult: Result<[Message], Error> //
    let uploadResult: Result<Void, Error> //
    init(fetchMessagesResult: Result<[Message], Error> = .success([Message(text: "Hello", isSentByUser: true)]), uploadResult: Result<Void, Error> = .success(()))
    {
        self.fetchMessagesResult = fetchMessagesResult
        self.uploadResult = uploadResult
    }

    func fetchMessages() async throws -> [Message] {
        try fetchMessagesResult.get()
    }

    func upload(_ message: Message) async throws {
        try uploadResult.get()
    }
}
