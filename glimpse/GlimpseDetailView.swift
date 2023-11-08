//
//  GlimpseDetailView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 11/6/23.
//

import SwiftUI
import SwiftData

struct GlimpseDetailView: View {
    var selectedQuestion: Question

    @Query(
        sort: [
            SortDescriptor(\Answer.date, order: .reverse)
        ]
    ) var answers: [Answer]
    
    private var filteredAnswers: [Answer] {
        return answers.compactMap { answer in
            guard let question = answer.question else {
                return nil
            }
            return question == selectedQuestion ? answer : nil
        }
    }
    
    var lastSixMonthsAnswers: [Answer] {
        let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        return filteredAnswers.filter { $0.date >= sixMonthsAgo }.sorted { $0.date < $1.date }
    }
    
    var streak: Int {
        guard let latestDate = filteredAnswers.last?.date else { return 0 }
        var currentStreak = 0
        var currentDate = Date()
        
        while currentDate >= latestDate {
            if filteredAnswers.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
                currentStreak += 1
            } else {
                break
            }
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return currentStreak
    }

    var weekdayPositivePercentage: Double {
        let weekdayAnswers = filteredAnswers.filter { $0.date.isWeekday }
        guard !weekdayAnswers.isEmpty else { return 0.0 }
        
        let positiveWeekdayAnswers = weekdayAnswers.filter { $0.response == (selectedQuestion.yesIsPositive ? 1 : 0) }
        return Double(positiveWeekdayAnswers.count) / Double(weekdayAnswers.count) * 100.0
    }

    var weekendPositivePercentage: Double {
        let weekendAnswers = filteredAnswers.filter { !$0.date.isWeekday }
        guard !weekendAnswers.isEmpty else { return 0.0 }
        
        let positiveWeekendAnswers = weekendAnswers.filter { $0.response == (selectedQuestion.yesIsPositive ? 1 : 0) }
        return Double(positiveWeekendAnswers.count) / Double(weekendAnswers.count) * 100.0
    }

    
    var body: some View {
        List {
            glimpseInfoView()
        }
        .navigationTitle(Text("Monthly Glimpse"))
    }
    
    @ViewBuilder
    private func glimpseInfoView() -> some View {
        let otherFont = Font.body.lowercaseSmallCaps()
        VStack(alignment: .leading) {
            Text(selectedQuestion.title)
                .font(.headline)
                .padding(.vertical)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("🔥")
                    if (streak == 1){
                        Text("\(streak) day")
                            .lineLimit(1)
                    } else {
                        Text("\(streak) days")
                            .lineLimit(1)
                    }
                }
                .font(otherFont)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .center) {
                    Text("Weekdays:")
                    Text("\(Int(weekdayPositivePercentage))%").lineLimit(1)
                }
                .font(otherFont)
                .frame(maxWidth: .infinity, alignment: .center)
                                    
                VStack(alignment: .trailing) {
                    Text("Weekends:")
                    Text("\(Int(weekendPositivePercentage))%").lineLimit(1)
                }
                .font(otherFont)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            LongHistoryChartView(answers: lastSixMonthsAnswers, monthYearLabels: getLastSixMonthYearLabels())
        }
    }
}

extension Date {
    var isWeekday: Bool {
        let weekday = Calendar.current.component(.weekday, from: self)
        return !(weekday == 1 || weekday == 7)  // 1 is Sunday and 7 is Saturday in Gregorian calendar
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer){
        GlimpseDetailView(selectedQuestion: .preview)
    }
}
