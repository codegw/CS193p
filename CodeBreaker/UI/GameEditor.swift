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
            Section("Name") {
                TextField("Name", text: $game.name)
            }
            Section("Pegs") {
                List {
                    ForEach(game.pegChoices.indices, id: \.self) { index in
                        ColorPicker(selection: $game.pegChoices[index],
                                    supportsOpacity: false) {
                            Text("Peg Choice \(index + 1)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", numOfPegs: 4, pegChoices: [.red, .orange])
    GameEditor(game: game)
        .onChange(of: game.name) {
            print("name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("pegs changed to \(game.pegChoices)")
        }
}
