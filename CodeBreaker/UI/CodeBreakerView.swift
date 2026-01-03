//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker.randomGame()
    
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode) {
                    ElapsedTime(startTime: game.startTime, endTime: game.endTime)
                        .flexibleSystemFont()
                        .monospaced()
                        .lineLimit(1)
                }
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess).flexibleSystemFont()
                                .disabled(!game.canSubmitGuess)
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts.reversed(), id: \.self) { attempt in
                        CodeView(code: attempt) {
                            let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.last?.pegs
                            if showMarkers, let matches = attempt.matches {
                                MatchMarkers(matches: matches)
                            }
                        }
                        .transition(.attempt(game.isOver))
                    }
                }
                if !game.isOver {
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        .transition(.pegChooser)
                }
            }
            .navigationTitle("CodeBreaker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    restart()
                } label: {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                }
            }
            .padding()
        }
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func guess() {
        withAnimation(.guess){
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
    
    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let selectionColor: Color = Color.gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}

#Preview {
    CodeBreakerView()
}
