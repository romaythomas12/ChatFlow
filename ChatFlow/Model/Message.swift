//
//  Message.swift
//  ChatFlow
//
//  Created by Thomas Romay on 03/11/2024.
//

import RealmSwift

class Message: Object, Identifiable {
    enum MessageType {
        case text, timestamp
    }

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var text: String
    @Persisted var timestamp: Date
    @Persisted var isSentByUser: Bool
    @Persisted var statusRaw: String

    var status: MessageStatus {
        get {
            MessageStatus(rawValue: statusRaw) ?? .initial
        }
        set {
            self.statusRaw = newValue.rawValue
        }
    }

    var type: MessageType = .text // Default to regular text message
    var isEmojiOnly: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .unicodeScalars
            .allSatisfy { $0.properties.isEmoji }
    }

    convenience init(text: String, isSentByUser: Bool, status: MessageStatus = .initial, timestamp: Date =  Date()) {
        self.init()
        self.text = text
        self.timestamp = timestamp
        self.isSentByUser = isSentByUser
        self.status = status
    }

    convenience init(timestamp: Date) {
        self.init()
        self.text = DateFormatter.localizedString(from: timestamp, dateStyle: .medium, timeStyle: .short)
        self.timestamp = timestamp
        self.isSentByUser = false
        self.type = .timestamp
        self.status = .initial
    }
}
