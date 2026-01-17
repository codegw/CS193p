//
//  SwiftDataPreview.swift
//  CodeBreaker
//
//  Created by codegw on 06/01/2026.
//

import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: CodeBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true) //Don't store in disk, store in memory
        )
        //Possibly load sample data into container.mainContext
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}
