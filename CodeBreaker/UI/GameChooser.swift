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
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offset, destination in
                    games.move(fromOffsets: offset, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { pegs in
                PegChooser(choices: pegs)
            }
            .listStyle(.plain)
            .navigationTitle("CodeBreaker")
            .toolbar {
                EditButton()
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
