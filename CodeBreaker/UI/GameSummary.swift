//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 03/01/2026.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var body: some View {
        VStack (alignment: .leading){
            Text(game.name)
                .font(.headline)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummary(game: CodeBreaker(name: "Preview", numOfPegs: 4, pegChoices: [.red, .yellow, .blue]))
    }
    List {
        GameSummary(game: CodeBreaker(name: "Preview", numOfPegs: 4, pegChoices: [.red, .yellow, .blue]))
    }
    .listStyle(.plain)
}
