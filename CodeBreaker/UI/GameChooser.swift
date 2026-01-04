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
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    .contextMenu {
                        Button("Delete", systemImage: "minus.circle", role: .destructive) {
                            withAnimation {
                                games.removeAll { $0 == game }
                            }
                        }
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
            .navigationTitle("CodeBreaker")
            .toolbar {
                EditButton()
            }
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", numOfPegs: 4, pegChoices: [.color(.red), .color(.blue), .color(.green), .color(.yellow)]))
            games.append(CodeBreaker(name: "Earth Tones", numOfPegs: 4, pegChoices: [.color(.orange), .color(.brown), .color(.black), .color(.yellow)]))
            games.append(CodeBreaker(name: "Undersea", numOfPegs: 4, pegChoices: [.color(.blue), .color(.indigo), .color(.cyan)]))
            selection = games.first
        }
    }
}

#Preview {
    GameChooser()
}
