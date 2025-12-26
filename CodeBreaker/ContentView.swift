//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .green, .blue, .yellow])
            pegs(colors: [.red, .green, .blue, .yellow])
            pegs(colors: [.red, .green, .blue, .yellow])
            pegs(colors: [.red, .green, .blue, .yellow])
        }
        .padding()
    }
    
    func pegs(colors: Array<Color>) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}


#Preview {
    ContentView()
}
