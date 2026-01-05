//
//  MemorizeApp.swift
//  Memorize
//
//  Created by codegw on 06/07/2024.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(memoryGame: game)
        }
    }
}
