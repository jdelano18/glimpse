//
//  ContentView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/22/23.
//
// TODO: answer view
// answer button
// notifications for answers

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var questions: [Question]
    
    @State private var showAddQuestion = false
    @State private var selection: Question?

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(questions) { question in
                    GlimpseListItem(question: question)
                        .swipeActions(edge: .trailing){
                            Button(role: .destructive){
                                deleteItem(question)
                            } label: {
                                Label("Delete", systemImage:"trash")
                            }
                        }
                }
                .onDelete(perform: deleteItems(at:))
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
            if let selection = selection {
                NavigationStack {
                    GlimpseDetailView(question: selection)
                }
            }
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

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(questions[index])
            }
        }
    }
    
    private func deleteItem(_ question: Question){
        if question.persistentModelID == selection?.persistentModelID {
            selection = nil
        }
        modelContext.delete(question)
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
