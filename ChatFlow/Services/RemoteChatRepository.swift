//
//  RemoteChatRepositoryProtocol.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import Foundation

// MARK: - RemoteChatRepositoryProtocol

protocol RemoteChatRepositoryProtocol: Sendable {
    associatedtype Model = [Message]
    func fetchMessages() async throws -> [Message]
    func upload(_ message: Message) async throws
}

// MARK: - RemoteChatRepository

final class RemoteChatRepository: RemoteChatRepositoryProtocol {
    func fetchMessages() async throws -> Model {
        throw URLError(.unknown) // Simulate remote fetch failure
    }

    func upload(_ message: Message) async throws {
        throw URLError(.unknown) // Simulate remote upload failure
    }
}
