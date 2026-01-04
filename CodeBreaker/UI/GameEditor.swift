//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 04/01/2026.
//

import SwiftUI

struct GameEditor: View {
    @Bindable var game: CodeBreaker
    
    var body: some View {
        Form {
            TextField("Name", text: $game.name)
        }
    }
}

#Preview {
    let game = CodeBreaker(name: "Preview", numOfPegs: 4, pegChoices: [.color(.red), .color(.orange)])
    GameEditor(game: game)
        .onChange(of: game.name) {
            print("name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("pegs changed to \(game.pegChoices)")
        }
}
