//
//  PegView.swift
//  CodeBreaker
//
//  Created by codegw on 29/12/2025.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Diamond()
    
    var body: some View {
        pegShape
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(Color(hex: peg) ?? .clear)
    }
}

#Preview {
    PegView(peg: "blue")
        .padding()
}
