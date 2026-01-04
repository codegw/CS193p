//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

typealias Peg = Color

@Observable class CodeBreaker {
    var name: String
    var numOfPegs: Int
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Color]
    
    var startTime: Date?
    var endTime: Date?
    
    var elapsedTime: TimeInterval = 0
    
    init(name: String = "Code Breaker", numOfPegs: Int, pegChoices: [Color]) {
        self.name = name
        self.numOfPegs = numOfPegs
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master(isHidden: true), pegCount: numOfPegs)
        self.guess = Code(kind: .guess, pegCount: numOfPegs)

        masterCode.randomize(from: pegChoices)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    static func randomGame() -> CodeBreaker {
        let pegLibrary: [[Color]] = [
            [.red, .yellow, .orange, .cyan]
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
            pauseTimer()
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
        elapsedTime = 0
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
