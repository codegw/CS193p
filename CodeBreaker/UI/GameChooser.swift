//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 03/01/2026.
//

import SwiftUI

struct GameChooser: View {
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
                .navigationTitle("CodeBreaker")
                .navigationBarTitleDisplayMode(.inline)
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
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
