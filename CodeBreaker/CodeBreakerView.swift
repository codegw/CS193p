//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker()
    
    var body: some View {
        NavigationStack {
            VStack {
                view(for: game.masterCode)
                ScrollView {
                    view(for: game.guess)
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        view(for: game.attempts[index])
                    }
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
            }
        } label: {
            Text("Guess")
                .font(.title)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .disabled(!game.canSubmitGuess)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .overlay {
                        switch code.pegs[index] {
                        case .color(let color):
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(color)

                        case .emoji(let emoji):
                            Text(emoji)
                                .font(.largeTitle)
                                

                        case .empty:
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}

public func toColor(_ name: String) -> Color {
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



#Preview {
    CodeBreakerView()
}
