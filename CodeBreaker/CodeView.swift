//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 29/12/2025.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code: Code
    
    // MARK: Data shared with me
    @Binding var selection: Int
    
    // MARK: - Body
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index])
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape
                            .foregroundStyle(Selection.selectionColor)
                    }
                }
                .overlay {
                    Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
    
    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let selectionColor: Color = Color.gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}
