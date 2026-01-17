//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import Foundation
import SwiftData

typealias Peg = String

@Model final class CodeBreaker {
    var name: String = ""
    var numOfPegs: Int = 4
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade, inverse: \Code.game) var _attempts: [Code] = []
    
    var pegChoices: [Peg] = []
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timeStamp > $1.timeStamp }}
        set { _attempts = newValue }
    }
    
    init() { }
    
    init(name: String = "Code Breaker", numOfPegs: Int, pegChoices: [Peg]) {
        self.name = name
        self.numOfPegs = numOfPegs 
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    func attemptGuess() {
        guard !isAttempted(guess) else { return }
        let attempt = Code(kind: .attempt(guess.match(against: masterCode)), pegs: guess.pegs)
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
        guess.reset(masterCode.pegs.count)
        if attempts.first?.pegs == masterCode.pegs {
            isOver = true
            endTime = .now
            masterCode.kind = .master(isHidden: false)
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
        isOver = false
    }
}
