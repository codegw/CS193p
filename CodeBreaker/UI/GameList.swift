//
//  GameList.swift
//  CodeBreaker
//
//  Created by codegw on 04/01/2026.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]
    
    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game.isOver) &&
            (search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch))
        }
        
        switch sortBy {
        case.name: _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case.recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case.name: "Name"
            case.recent: "Recent"
            case.completed: "Completed"
            }
        }
    }
    
    var summarySize: GameSummary.Size {
        staticSummarySize * dynamicSummarySizeMagnication
    }
    
    @State private var staticSummarySize: GameSummary.Size = .large
    @State private var dynamicSummarySizeMagnication: CGFloat = 1.0
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game, size: summarySize)
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
        .highPriorityGesture(summarySizeMagnifier)
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
        .task { await addSampleGames() }
    }
    
    var summarySizeMagnifier: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                dynamicSummarySizeMagnication = value.magnification
            }
            .onEnded { value in
                staticSummarySize = staticSummarySize * value.magnification
                dynamicSummarySizeMagnication = 1.0
            }
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
    
    func addSampleGames() async {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        
        let results = try? modelContext.fetchCount(fetchDescriptor)
        if results == 0 {
            for url in sampleGameURLS {
                do {
                    let (json, _) = try await URLSession.shared.data(from: url)
                    let game = try JSONDecoder().decode(CodeBreaker.self, from: json)
                    modelContext.insert(game)
                    print("Loaded sample game from \(url)")
                } catch {
                    print("Couldn't load sample game from JSON file at \(url): \(error.localizedDescription)")
                }
            }
        }
    }
    
    var sampleGameURLS: [URL] {
        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
            .map { URL(fileURLWithPath: $0 )}
    }
}

extension GameSummary.Size {
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        switch rhs {
        case 2.0...: lhs.larger.larger
        case 1.5...: lhs.larger
        case ...0.35: lhs.smaller.smaller
        case ...0.5: lhs.smaller
        default: lhs
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
