//
//  PreviewSampleData.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/22/23.
//
// Abstract:
// The preview sample data actor which provides an in-memory model container.


import SwiftData
import SwiftUI

/**
 Preview sample data.
 */
actor PreviewSampleData {

    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Question.self, Answer.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Question.preview, Answer.preview
        ]
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}
