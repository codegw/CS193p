//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 04/01/2026.
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data Shared with Me
    @Bindable var game: CodeBreaker
    
    @State private var showInvalidGameAlert = false
    
    // MARK: Action Function
    let onChoose: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                        .autocapitalization(.words)
                        .autocorrectionDisabled()
                        
                }
                Section("Pegs") {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if game.isValid {
                            onChoose()
                            dismiss()
                        } else {
                            showInvalidGameAlert = true
                        }
                    }
                    .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                        Button("OK") {
                            showInvalidGameAlert = false
                        }
                    } message: {
                        Text("A game must have a name and unique peg choices")
                    }
                }
            }
        }
    }
}

extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", numOfPegs: 4, pegChoices: [.red, .orange])
    GameEditor(game: game) {
        print("name changed to \(game.name)")
        print("pegs changed to \(game.pegChoices)")
    }
}
