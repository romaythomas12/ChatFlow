//
//  LocalChatRepositoryProtocol.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import Foundation
@preconcurrency import RealmSwift

// MARK: - LocalChatRepositoryProtocol

protocol LocalChatRepositoryProtocol: Sendable {
    associatedtype Model = [Message]
    func fetchMessages() async throws -> [Message]
    func store(_ messages: [Message]) async throws
    func store(_ message: Message) async throws
    func updateMessageStatus(id: ObjectId, status: MessageStatus) async throws
}

// MARK: - LocalChatRepository

final class LocalChatRepository: LocalChatRepositoryProtocol {
    private let realm: Realm
    
    init(realm: Realm? = nil, configuration: Realm.Configuration? = nil) {
        self.realm = realm ?? LocalChatRepository.createRealmInstance(with: configuration)
    }
    
    private static func createRealmInstance(with configuration: Realm.Configuration?) -> Realm {
        let config = configuration ?? Realm.Configuration(schemaVersion: 7, migrationBlock: { _, oldSchemaVersion in
            if oldSchemaVersion < 7 {
                // Handle migration if needed
            }
        })
        Realm.Configuration.defaultConfiguration = config
        
        do {
            return try Realm()
        } catch {
            // Handle error gracefully (e.g., logging) and return an in-memory Realm for error cases
            print("Failed to initialize Realm: \(error.localizedDescription)")
            return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "errorFallback"))
        }
    }
    
    @MainActor func fetchMessages() async throws -> [Message] {
        let results = realm.objects(Message.self).sorted(byKeyPath: "timestamp", ascending: true)
        return Array(results)
    }
    
    func store(_ messages: [Message]) async throws {
        try realm.write {
            realm.add(messages)
        }
    }
    
    @MainActor func store(_ message: Message) async throws {
        try realm.write {
            realm.add(message)
        }
    }
    
    @MainActor func updateMessageStatus(id: ObjectId, status: MessageStatus) async throws {
        if let message = realm.object(ofType: Message.self, forPrimaryKey: id) {
            try realm.write {
                message.status = status
            }
        } else {
            throw NSError(domain: "com.chatflow.local", code: 404, userInfo: [NSLocalizedDescriptionKey: "Message not found"])
        }
    }
}
