//  ViewModel
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by codegw on 09/07/2024.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    @Published private var game: MemoryGame<String>
    
    static let themes: [MemoryGame<String>.Theme] = [
        MemoryGame<String>.Theme(id: "1", themeName: "Faces", emoji: ["😀", "😄", "😂", "😊", "😎", "😏", "🙂", "😔", "😜", "🤨", "😭", "🥶"], numOfPairs: 12, themeColor: "blue"),
        MemoryGame<String>.Theme(id: "2", themeName: "Animals", emoji: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮"], numOfPairs: 12, themeColor: "green"),
        MemoryGame<String>.Theme(id: "3", themeName: "Fruits", emoji: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍒", "🍑", "🥭"], numOfPairs: 12, themeColor: "red"),
        MemoryGame<String>.Theme(id: "4", themeName: "Vehicles", emoji: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🚚", "🚛"], numOfPairs: 12, themeColor: "yellow"),
        MemoryGame<String>.Theme(id: "5", themeName: "Sports", emoji: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🏒"], numOfPairs: 12, themeColor: "orange"),
        MemoryGame<String>.Theme(id: "6", themeName: "Music", emoji: ["🎹", "🥁", "🎸", "🎷", "🎺", "🎻", "🎼", "🎤", "🎧", "🎙️", "🎵", "🎶"], numOfPairs: 12, themeColor: "purple"),
        MemoryGame<String>.Theme(id: "7", themeName: "Nature", emoji: ["🌲", "🌳", "🌴", "🌵", "🌿", "☘️", "🍀", "🍃", "🍂", "🍁", "🍄", "🌾"], numOfPairs: 12, themeColor: "brown"),
        MemoryGame<String>.Theme(id: "8", themeName: "Flags", emoji: ["🇺🇸", "🇨🇦", "🇲🇽", "🇧🇷", "🇬🇧", "🇫🇷", "🇩🇪", "🇮🇹", "🇪🇸", "🇯🇵", "🇨🇳", "🇰🇷"], numOfPairs: 12, themeColor: "cyan"),
        MemoryGame<String>.Theme(id: "9", themeName: "Foods", emoji: ["🍔", "🍟", "🍕", "🌭", "🥪", "🌮", "🌯", "🥙", "🍣", "🍱", "🍤", "🍙"], numOfPairs: 12, themeColor: "pink"),
        MemoryGame<String>.Theme(id: "10", themeName: "Activities", emoji: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🏒"], numOfPairs: 12, themeColor: "gray")
        
    ]
    
    init() {
        let theme = EmojiMemoryGame.themes.randomElement()!
        game = MemoryGame(theme: theme) { pairIndex in
            theme.emoji[pairIndex]
        }
    }
    
    var cards: [Card] {
        game.cards
    }
    
    var score: Int {
        game.gameScore
    }
    
    var themeColor: Color {
        switch game.theme.themeColor {
            case "blue":
                return .blue
            case "green":
                return .green
            case "red":
                return .red
            case "yellow":
                return .yellow
            case "orange":
                return .orange
            case "purple":
                return .purple
            case "brown":
                return .brown
            case "cyan":
                return .cyan
            case "pink":
                return .pink
            case "gray":
                return .gray
            default:
                return .gray
            }
        }
    
    var themeName: String {
        game.theme.themeName
    }
    // MARK: - Intents
    
    func shuffle() {
        game.shuffle()
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func newGame() {
        let theme = EmojiMemoryGame.themes.randomElement()!
        game = MemoryGame(theme: theme) { pairIndex in
            theme.emoji[pairIndex]
        }
        game.shuffle()
    }
}
