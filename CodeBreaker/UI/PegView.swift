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
    
    let pegShape = Diamond()
    
    var body: some View {
        pegShape
            .foregroundStyle(.white)
            .overlay {
                pegShape
                    .foregroundStyle(Color(hex: peg) ?? .clear)
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PegView(peg: "blue")
        .padding()
}
