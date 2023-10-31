//
//  GlimpseDetailView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/29/23.


import SwiftUI
import SwiftData

struct GlimpseDetailView: View {
    @Query private var answers: [Answer]
    var question: Question
    
    var lastSixMonthsAnswers: [Answer] {
        let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        return answers.filter { $0.date >= sixMonthsAgo }.sorted { $0.date < $1.date }
    }
    
    var streak: Int {
        guard let latestDate = answers.last?.date else { return 0 }
        var currentStreak = 0
        var currentDate = Date()
        
        while currentDate >= latestDate {
            if answers.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
                currentStreak += 1
            } else {
                break
            }
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return currentStreak
    }

    var weekdayPositivePercentage: Double {
        let weekdayAnswers = answers.filter { $0.date.isWeekday }
        guard !weekdayAnswers.isEmpty else { return 0.0 }
        
        let positiveWeekdayAnswers = weekdayAnswers.filter { $0.response == (question.yesIsPositive ? 1 : 0) }
        return Double(positiveWeekdayAnswers.count) / Double(weekdayAnswers.count) * 100.0
    }

    var weekendPositivePercentage: Double {
        let weekendAnswers = answers.filter { !$0.date.isWeekday }
        guard !weekendAnswers.isEmpty else { return 0.0 }
        
        let positiveWeekendAnswers = weekendAnswers.filter { $0.response == (question.yesIsPositive ? 1 : 0) }
        return Double(positiveWeekendAnswers.count) / Double(weekendAnswers.count) * 100.0
    }

    
    var body: some View {
        let otherFont = Font.body.lowercaseSmallCaps()
        Section {
            VStack{
                Text(question.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack{
                    Text("🔥 \n \(streak) days")
                        .font(otherFont)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Weekdays: \n \(Int(weekdayPositivePercentage))%")
                        .font(otherFont)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Weekends: \n \(Int(weekendPositivePercentage))%")
                        .font(otherFont)
                        .multilineTextAlignment(.center)
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
            GlimpseDetailView(question: .preview)
        }
    }
}
