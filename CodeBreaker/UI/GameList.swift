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
    
    @State private var showGameEditor: Bool = false
    @State private var gameToEdit: CodeBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // Editing a game
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
            addButton
            EditButton() // Editing list of games
        }
        .onAppear { addSampleGames() }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", numOfPegs: 4, pegChoices: [.red, .blue])
        }
        .onChange(of: gameToEdit) {
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: {
            gameToEdit = nil
        }) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, numOfPegs: gameToEdit.numOfPegs, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(gameToEdit, at: 0)
                }
            }
        }
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
