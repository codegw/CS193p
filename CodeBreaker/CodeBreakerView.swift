//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker()
    @State private var selection: Int = 0
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                view(for: game.masterCode)
                ScrollView {
                    if !game.isOver {
                        view(for: game.guess)
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        view(for: game.attempts[index])
                    }
                }
                PegChooser(choices: game.pegChoices) { peg in
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.masterCode.pegs.count
                }
            }
            .navigationTitle("CodeBreaker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    withAnimation {
                        game.reset()
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                }
            }
            .padding()
        }
    }
    
    var guessButton: some View {
        Button{
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        } label: {
            Text("Guess")
                
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
        .disabled(!game.canSubmitGuess)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, selection: $selection)
            
            Rectangle().foregroundStyle(Color.clear).aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkers(matches: matches)
                    } else {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
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
