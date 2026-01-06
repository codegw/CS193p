//
//  GameList.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 04/01/2026.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker]
    
    // MARK: Data Owned by Me
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
                .swipeActions (edge: .leading){
                    editButton(for: game).tint(.accentColor)
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
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
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .yellow, .blue])
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, numOfPegs: gameToEdit.numOfPegs, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool> {
            gameToEdit != nil
        } set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        }

    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        
        let results = try? modelContext.fetch(fetchDescriptor)
        if results?.count == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .yellow, .blue, .green]))
            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow]))
            modelContext.insert(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
