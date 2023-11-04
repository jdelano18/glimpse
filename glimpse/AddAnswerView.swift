//
//  AnswerPicker.swift
//  glimpse
//
//  Created by Jimmy DeLano on 11/3/23.
//

import SwiftUI
import SwiftData
// TODO: pick up here.
// view to display questions --> y/n pickers
// enter into modelContext save somehow
// add as button for now in Content View
// block if question has already been answered today
// --> add notificaitons to trigger this view to show up


struct AddAnswerView: View {
    var question: Question

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var response: Bool? // nil represents no selection, true for "Yes", false for "No"

    var body: some View {
        NavigationView {
            Form {
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
            .navigationTitle("Add Answer")
            .navigationBarItems(
                leading: Button("Dismiss") {
                    dismiss()
                },
                trailing: Button("Done") {
                    if let response = response {
                        addAnswer(response: response)
                        dismiss()
                    }
                }
            )
        }
    }

    private func addAnswer(response: Bool) {
        withAnimation {
            let intResponse = response ? 1 : 0
            let newAnswer = Answer(date: .now, response: intResponse, question: question)
            modelContext.insert(newAnswer)
        }
    }
}


#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        AddAnswerView(question: .preview)
    }
}

