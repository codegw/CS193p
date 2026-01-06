//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

struct CodeBreakerView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.sceneFrame) var sceneFrame
    
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
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
                            Button("Guess", action: guess).flexibleSystemFont()
                                .disabled(!game.canSubmitGuess)
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts, id: \.pegs) { attempt in
                        CodeView(code: attempt) {
                            let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                            if showMarkers, let matches = attempt.matches {
                                MatchMarkers(matches: matches)
                            }
                        }
                        .transition(.attempt(game.isOver))
                    }
                }
                GeometryReader { geometry in
                    if !game.isOver {
                        let offset = sceneFrame.maxY - geometry.frame(in: .global).minY
                        PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                            .transition(.offset(x: 0, y: offset))
                            .frame(maxHeight: Selection.pegChooserHeight)
                    }
                }
                .frame(maxHeight: 90, alignment: .center)
                .aspectRatio(CGFloat(game.pegChoices.count), contentMode: .fit)
            }
            .gesture(pegChoosingDial)
            .trackElapsedTime(in: game)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        restart()
                    } label: {
                        Image(systemName: "arrow.trianglehead.counterclockwise")
                    }
                }
                ToolbarItem {
                    ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                        .monospaced()
                        .lineLimit(1)
                }
            }
            .padding()
        }
    }
    
    var pegChoosingDial: some Gesture {
        RotateGesture()
            .onChanged { value in
                let pegChoiceIndex = Int(abs(value.rotation.degrees) / 90) % game.pegChoices.count
                game.guess.pegs[selection] = game.pegChoices[pegChoiceIndex]
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
        static let pegChooserHeight: CGFloat = 100
    }
}

extension CodeBreaker {
    convenience init(name: String = "Code Breaker", pegChoices: [Color]) {
        self.init(name: name, numOfPegs: 4, pegChoices: pegChoices.map(\.hex))
    }
    var pegColorChoices: [Color] {
        get { pegChoices.map { Color(hex: $0) ?? .clear }}
        set { pegChoices = newValue.map(\.hex) }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: [.red, .orange, .yellow, .cyan])
    CodeBreakerView(game: game)
}

