//
//  Diamond.swift
//  CodeBreaker
//
//  Created by codegw on 06/01/2026.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.closeSubpath()
        }
    }
}

#Preview {
    Diamond()
        .aspectRatio(1, contentMode: .fit)
}
