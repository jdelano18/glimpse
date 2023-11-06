//
//  GlimpseDetailView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/29/23.


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
        let otherFont = Font.body.lowercaseSmallCaps()
        Section {
            VStack{
                Text(selectedQuestion.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                HStack{
                    Text("🔥 \n \(streak) days")
                        .font(otherFont)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("Weekdays: \n \(Int(weekdayPositivePercentage))%")
                        .font(otherFont)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Text("Weekends: \n \(Int(weekendPositivePercentage))%")
                        .font(otherFont)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding()
        }
        Section{
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
        List {
            GlimpseDetailView(selectedQuestion: .preview)
        }
    }
}
