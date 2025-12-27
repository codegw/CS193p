//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
            VStack {
                matchMarker(peg: 4)
                matchMarker(peg: 5)
            }
        }
    }
    
    @ViewBuilder
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }
        Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2).aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    VStack {
        HStack {
            Circle()
            Circle()
            Circle()
            Circle()
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
            
        }
        HStack {
            Circle()
            Circle()
            Circle()
            Circle()
            Circle()
            MatchMarkers(matches: [.inexact, .inexact, .nomatch, .exact])
        }
        HStack {
            Circle()
            Circle()
            Circle()
            Circle()
            Circle()
            MatchMarkers(matches: [.inexact, .inexact, .nomatch, .exact, .inexact, .exact])
        }
        HStack {
            Circle()
            Circle()
            Circle()
            Circle()
            MatchMarkers(matches: [.inexact, .inexact, .nomatch, .exact, .exact])
        }
    }
    .padding()
    
}
