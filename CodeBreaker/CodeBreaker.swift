//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

//Quite literally an alias!
typealias Peg = String

struct CodeBreaker {
    var numOfPegs: Int
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = ["red", "green", "blue", "yellow"]) {
        self.numOfPegs = Int.random(in: 3...6)
        self.pegChoices = pegChoices
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
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    func isAttempted(_ guess: Code) -> Bool {
        attempts.contains { $0.pegs == guess.pegs }
    }
    
    var canSubmitGuess: Bool {
        !isAttempted(guess) && guess.isOnePegChosen()
    }
    
    mutating func reset() {
        numOfPegs = Int.random(in: 3...6)
        
        self.masterCode = Code(kind: .master, pegCount: numOfPegs)
        self.guess = Code(kind: .guess, pegCount: numOfPegs)
        
        masterCode.randomize(from: pegChoices)
        attempts.removeAll()
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    init(kind: Kind, pegCount: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: pegCount)
    }
    
    static let missing: Peg = "clear"
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt (let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
    
    func isOnePegChosen() -> Bool {
        pegs.contains { $0 != Code.missing }
    }
}
