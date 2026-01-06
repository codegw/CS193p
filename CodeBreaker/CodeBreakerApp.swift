//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 26/12/2025.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                GameChooser()
                    .modelContainer(for: CodeBreaker.self)
                    .environment(\.sceneFrame, geometry.frame(in: .global))
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

// MARK: Deprecation
// main was deprecated in iOS 26.0, and had issues regarding iPadOS window sizes
// Code here is to maintain lecture material
extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = UIScreen.main.bounds
}
