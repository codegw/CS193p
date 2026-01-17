//
//  UIExtensions.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 02/01/2026.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.move(edge: .bottom)
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing))
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0 ,brightness: brightness)
    }
    
    static func toColor(_ name: String) -> Color {
        switch name {
        case "red":
            return Color.red
        case "orange":
            return Color.orange
        case "yellow":
            return Color.yellow
        case "cyan":
            return Color.cyan
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        case "purple":
            return Color.purple
        case "clear":
            return Color.clear
        default:
            return Color.clear
        }
    }
    
    static func toString(_ color: Color) -> String {
        switch color {
        case .red:
            return "red"
        case .orange:
            return "orange"
        case .yellow:
            return "yellow"
        case .cyan:
            return "cyan"
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .purple:
            return "purple"
        case .clear:
            return "clear"
        default:
            return "clear"
        }
    }
}

extension View {
    func flexibleSystemFont(minimum: CGFloat = 15, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: minimum))
            .minimumScaleFactor(minimum / maximum)
    }
}
