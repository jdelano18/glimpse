//
//  ContentView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var questions: [Question]
    
    @State private var showAddQuestion = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(questions) { question in
                    NavigationLink {
                        Text("Question at \(question.notificationTime, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(question.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .overlay {
                if questions.isEmpty {
                    ContentUnavailableView {
                         Label("No Questions", systemImage: "plus.circle")
                    } description: {
                         Text("New questions you create will appear here.")
                    }
                }
            }
            .navigationTitle("Weekly Glimpse")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(questions.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddQuestion = true
                    } label: {
                        Label("Add Item", systemImage: "plus.circle")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $showAddQuestion) {
            NavigationStack {
                AddQuestionView()
            }
            .presentationDetents([.medium, .large])
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Question(title: "Test", yesIsPositive: true, notificationTime: .now)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(questions[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
