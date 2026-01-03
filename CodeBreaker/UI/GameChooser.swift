//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 03/01/2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(games, id: \.pegChoices) { game in
            VStack (alignment: .leading){
                Text(game.name)
                    .font(.headline)
                PegChooser(choices: game.pegChoices)
                    .frame(maxHeight: 50)
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", numOfPegs: 4, pegChoices: [.color(.red), .color(.blue), .color(.green), .color(.yellow)]))
            games.append(CodeBreaker(name: "Earth Tones", numOfPegs: 4, pegChoices: [.color(.orange), .color(.brown), .color(.black), .color(.yellow)]))
            games.append(CodeBreaker(name: "Undersea", numOfPegs: 4, pegChoices: [.color(.blue), .color(.indigo), .color(.cyan)]))
        }
    }
}

#Preview {
    GameChooser()
}
