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
                CodeView(code: game.masterCode)
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) {
                            guessButton
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index]) {
                            let showMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                            if showMarkers, let matches = game.attempts[index].matches {
                                MatchMarkers(matches: matches)
                            }
                        }
                        .transition(.attempt(game.isOver))
                    }
                }
                if !game.isOver  || restarting {
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        .transition(.pegChooser)
                }
            }
            .navigationTitle("CodeBreaker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    withAnimation(.restart) {
                        restarting = true
                    } completion: {
                        withAnimation(.restart) {
                            game.restart()
                            selection = 0
                            restarting = false
                        }
                    }
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
    
    var guessButton: some View {
        Button{
            withAnimation(.guess){
                game.attemptGuess()
                selection = 0
                hideMostRecentMarkers = true
            } completion: {
                withAnimation(.guess) {
                    hideMostRecentMarkers = false
                }
            }
        } label: {
            Text("Guess")
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
        .disabled(!game.canSubmitGuess)
    }
    
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let selectionColor: Color = Color.gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}

extension Animation {
    static let codeBreaker = Animation.easeInOut(duration: 0.5)
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y: 200)
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing))
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0 ,brightness: brightness)
    }
    
    static func toColor(_ name: String) -> Color {
        switch name {
        case "red":
            return Color.red
        case "orange":
            return Color.orange
        case "yellow":
            return Color.yellow
        case "cyan":
            return Color.cyan
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        case "purple":
            return Color.purple
        case "clear":
            return Color.clear
        default:
            return Color.blue
        }
    }
}

#Preview {
    CodeBreakerView()
}
