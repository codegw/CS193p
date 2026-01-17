//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by codegw on 04/01/2026.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices: [Color]
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(
                    selection: $pegChoices[index],
                    supportsOpacity: false
                ) {
                    button("Peg Choice \(index + 1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            button("Add Peg", systemImage: "plus.circle", color: .green) {
                withAnimation {
                    pegChoices.append(.green)
                }
            }
        }
    }
    
    func button (
        _ title: String,
        systemImage: String,
        color: Color? = nil,
            action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Color] = [.red, .yellow, .blue]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices = \(pegChoices)")
        }
}
