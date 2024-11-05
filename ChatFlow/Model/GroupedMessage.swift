//
//  GroupedMessage.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import Foundation

// MARK: - GroupedMessage Struct

struct GroupedMessage: Identifiable, Hashable {
    let id = UUID()
    let message: Message
    let spacing: CGFloat
}
