//
//  ChatFlowApp.swift
//  ChatFlow
//
//  Created by Thomas Romay on 03/11/2024.
//

import SwiftUI

@main
struct ChatFlowApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ChatView()
            } .navigationViewStyle(.stack)
        }
    }
}
