//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

enum Peg: Hashable, Equatable {
    case color(Color)
    case emoji(String)
    case empty
}

@Observable class CodeBreaker {
    var name: String
    var numOfPegs: Int
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]
    
    var startTime: Date = Date.now
    var endTime: Date?
    
    let pegLibrary: [[Peg]] = [
        [.color(.red), .color(.green), .color(.blue), .color(.yellow)],
        [.emoji("😀"), .emoji("😊"), .emoji("🥰"), .emoji("😭")],
        [.emoji("🍎"), .emoji("🥑"), .emoji("🍍"), .emoji("🍓")]
    ]
    
    init(name: String = "Code Breaker", numOfPegs: Int, pegChoices: [Peg]) {
        self.name = name
        self.numOfPegs = numOfPegs
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master(isHidden: true), pegCount: numOfPegs)
        self.guess = Code(kind: .guess, pegCount: numOfPegs)

        masterCode.randomize(from: pegChoices)
    }
    
    static func randomGame() -> CodeBreaker {
        let pegLibrary: [[Peg]] = [
            [.color(.red), .color(.green), .color(.blue), .color(.yellow)],
            [.emoji("😀"), .emoji("😊"), .emoji("🥰"), .emoji("😭")],
            [.emoji("🍎"), .emoji("🥑"), .emoji("🍍"), .emoji("🍓")]
        ]

        let choices = pegLibrary.randomElement()!
        let count = Int.random(in: 3...6)
        return CodeBreaker(numOfPegs: count, pegChoices: choices)
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func attemptGuess() {
        guard !isAttempted(guess) else { return }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset(masterCode.pegs.count)
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
    
    func isAttempted(_ guess: Code) -> Bool {
        attempts.contains { $0.pegs == guess.pegs }
    }
    
    var canSubmitGuess: Bool {
        !isAttempted(guess) && guess.isOnePegChosen()
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset(masterCode.pegs.count)
        attempts.removeAll()
        startTime = .now
        endTime = nil
    }
}

extension CodeBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
