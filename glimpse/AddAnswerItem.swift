//
//  AddAnswerItem.swift
//  glimpse
//
//  Created by Jimmy DeLano on 11/5/23.
//

import SwiftUI
import SwiftData

struct AddAnswerItem: View {
    @Environment(\.modelContext) private var modelContext
    var question: Question
    @Binding var response: Bool? // nil represents no selection, true for "Yes", false for "No"

    var body: some View {
        HStack {
            Text(question.title)
            Spacer()
            // Checkmark for "Yes"
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(response == true ? .green : .gray)
                .onTapGesture {
                    response = true
                }
            // Xmark for "No"
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(response == false ? .red : .gray)
                .onTapGesture {
                    response = false
                }
        }
    }
}

// Define a Preview for AddAnswerItem
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        List {
            AddAnswerItem(question: .preview, response: .constant(true))
        }
    }
}
