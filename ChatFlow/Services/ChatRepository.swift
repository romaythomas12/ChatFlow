//
//  ChatRepositoryProtocol.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import Foundation
import RealmSwift

// MARK: - ChatRepositoryProtocol

protocol ChatRepositoryProtocol: Sendable {
    func syncMessages() async throws -> [Message]
    func updateMessages(_ message: Message) async throws
    func updateMessageStatus(id: ObjectId, status: MessageStatus) async throws
}

// MARK: - ChatRepository

struct ChatRepository<RemoteAPI: RemoteChatRepositoryProtocol & Sendable, LocalAPI: LocalChatRepositoryProtocol & Sendable>: ChatRepositoryProtocol
    where RemoteAPI.Model == LocalAPI.Model {
    private let remoteService: RemoteAPI
    private let localService: LocalAPI

    init(remoteService: RemoteAPI = RemoteChatRepository(), localService: LocalAPI = LocalChatRepository()) {
        self.remoteService = remoteService
        self.localService = localService
    }

    func syncMessages() async throws -> [Message] {
        do {
            let messages = try await remoteService.fetchMessages()
            try await localService.store(messages)
            return messages
        } catch {
            print("Remote fetch failed: \(error.localizedDescription). Using local messages as fallback.")
            return try await localService.fetchMessages()
        }
    }

    func updateMessages(_ message: Message) async throws {
        do {
            try await remoteService.upload(message)
            try await localService.store(message)
        } catch {
            print("Remote upload failed: \(error.localizedDescription). Saving message locally.")
            try await localService.store(message)
        }
    }

    @MainActor
    func updateMessageStatus(id: ObjectId, status: MessageStatus) async throws {
        try await localService.updateMessageStatus(id: id, status: status)
    }
}
