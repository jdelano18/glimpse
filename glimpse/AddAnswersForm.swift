//
//  AnswerPicker.swift
//  glimpse
//
//  Created by Jimmy DeLano on 11/3/23.
//

import SwiftUI
import SwiftData
// add as button for now in Content View
// block if question has already been answered today
// --> add notificaitons to trigger this view to show up


struct AddAnswersForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var questions: [Question]

    // This dictionary will store the responses for each question
    @State private var responses = [Question: Bool]()
    
    // We'll filter our questions to only include ones that haven't been answered today
    private var unansweredQuestions: [Question] {
        questions.filter { question in
            !(question.answers?.contains { Calendar.current.isDate($0.date, inSameDayAs: Date()) } ?? false)
        }
    }

    var body: some View {
        List {
            if unansweredQuestions.isEmpty {
                Text("You've already answered all your questions for today.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(unansweredQuestions) { question in
                    AddAnswerItem(question: question, response: $responses[question])
                }
            }
        }
        .navigationTitle("Add Answers")
        .navigationBarItems(
            leading: Button("Dismiss") {
                dismiss()
            },
            trailing: Button("Done") {
                saveAllAnswers()
                dismiss()
            }.disabled(unansweredQuestions.isEmpty)
        )
    }

    private func saveAllAnswers() {
        for (question, response) in responses {
            let intResponse = response ? 1 : 0
            let newAnswer = Answer(date: .now, response: intResponse, question: question)
            modelContext.insert(newAnswer)
        }
    }
}


#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        AddAnswersForm(questions: [.preview])
    }
}
