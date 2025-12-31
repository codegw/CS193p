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

struct CodeBreaker {
    var numOfPegs: Int
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]
    
    let pegLibrary: [[Peg]] = [
        [.color(.red), .color(.green), .color(.blue), .color(.yellow)],
        [.emoji("😀"), .emoji("😊"), .emoji("🥰"), .emoji("😭")],
        [.emoji("🍎"), .emoji("🥑"), .emoji("🍍"), .emoji("🍓")]
    ]
    
    init() {
        let choices = pegLibrary.randomElement() ?? [.color(.red), .color(.green), .color(.blue), .color(.yellow)]
        
        self.numOfPegs = Int.random(in: 3...6)
        self.pegChoices = choices
        self.masterCode = Code(kind: .master(isHidden: true), pegCount: numOfPegs)
        self.guess = Code(kind: .guess, pegCount: numOfPegs)
        
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func changeGuessPeg(at index: Int) {
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
    
    mutating func reset() {
        self = CodeBreaker()
        attempts.removeAll()
    }
}


