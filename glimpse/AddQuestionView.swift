//
//  AddQuestionView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/23/23.
//

import SwiftUI
import WidgetKit

struct AddQuestionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.calendar) private var calendar
    @Environment(\.dismiss) private var dismiss
    @Environment(\.timeZone) private var timeZone
    @State private var title: String = ""
    @State private var yesIsPositive: Bool = true
    @State private var notificationTime = Date()
    
    
    var body: some View {
        Form {
            Section(header: Text("Ask yourself")) {
                TextField("Enter your question here...", text: $title, axis: .vertical)
                    .padding()
            }
            
            Section(header: Text("About this question")) {
                Toggle("'Yes' is a positive answer", isOn: $yesIsPositive)
            }
            
            Section(header: Text("When to answer")) {
                DatePicker(selection: $notificationTime,
                               displayedComponents: .hourAndMinute) {
                        Label("Reminder time", systemImage: "clock.badge")
                    }
            }
        }
        .frame(idealWidth: 400.0,
               idealHeight: 500.0)
        .navigationTitle("Add Question")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    addQuestion()
//                    WidgetCenter.shared.reloadTimelines(ofKind: "TripsWidget")
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }

    private func addQuestion() {
        withAnimation {
            let newQ = Question(title: title, yesIsPositive: yesIsPositive, notificationTime: notificationTime)
            modelContext.insert(newQ)
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        AddQuestionView()
    }
}
