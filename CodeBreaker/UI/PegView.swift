//
//  PegView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 29/12/2025.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        pegShape
            .foregroundStyle(.white)
            .overlay {
                switch peg {
                case .color(let color):
                    pegShape
                        .foregroundStyle(color)
                case .emoji(let emoji):
                    Text(emoji)
                        .font(.largeTitle)
                
                case .empty:
                    pegShape
                        .foregroundStyle(.clear)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PegView(peg: .color(.blue))
        .padding()
}
