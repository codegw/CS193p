//
//  GameList.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 04/01/2026.
//

import SwiftUI

struct GameList: View {
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    deleteButton(for: game)
                }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { offset, destination in
                games.move(fromOffsets: offset, toOffset: destination)
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            Button("Add Game", systemImage: "plus") {
                withAnimation {
                    let newgame = CodeBreaker(name: "Untitled", numOfPegs: 4, pegChoices: [.red, .blue])
                    games.append(newgame)
                }
            }
            EditButton()
        }
        .onAppear { addSampleGames() }
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", numOfPegs: 4, pegChoices: [.red, .yellow, .blue, .green]))
            games.append(CodeBreaker(name: "Earth Tones", numOfPegs: 4, pegChoices: [.orange, .brown, .black, .yellow]))
            games.append(CodeBreaker(name: "Undersea", numOfPegs: 4, pegChoices: [.blue, .indigo, .cyan]))
            selection = games.first
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
