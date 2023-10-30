//
//  GlimpseDetailView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/29/23.
// TODO: add title, streak, weekend positive % vs weekday positive %

import SwiftUI
import SwiftData

struct GlimpseDetailView: View {
    @Query private var answers: [Answer]
    var question: Question
    
    var lastSixMonthsAnswers: [Answer] {
        let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        return answers.filter { $0.date >= sixMonthsAgo }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        LongHistoryChartView(answers: lastSixMonthsAnswers, monthYearLabels: getLastSixMonthYearLabels())
    }
}


#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer){
        List {
            GlimpseDetailView(question: .preview)
        }
    }
}
