//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

enum Peg: Equatable {
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
        self.masterCode = Code(kind: .master, pegCount: numOfPegs)
        self.guess = Code(kind: .guess, pegCount: numOfPegs)
        
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
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

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    init(kind: Kind, pegCount: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missingPeg, count: pegCount)
    }
    
    static let missingPeg: Peg = .empty
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt (let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact,  let matchIndex = pegsToMatch.firstIndex(of: pegs[index]){
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
    
    func isOnePegChosen() -> Bool {
        pegs.contains { $0 != Code.missingPeg }
    }
}
