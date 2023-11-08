//
//  LongHistoryChartView.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/20/23.
//

import SwiftUI
import SwiftData

struct LongHistoryChartView: View {
    let answers: [Answer]
    let monthYearLabels: [String]
    
    var body: some View {
        HStack {
            // Month Labels
            VStack(alignment: .leading, spacing: 20 * 4) {
                ForEach(monthYearLabels, id: \.self) { monthYear in
                    Text(monthYear)
                }
            }
            
            VStack(spacing: 5) {
                // Days of the Week Labels
                HStack {
                    ForEach(getWeekdaysOrderedByCurrentDay(), id: \.self) { day in
                        Text(day)
                            .frame(width: 20)
                    }
                }
                
                // Answers Data
                ForEach(0..<24) { weekIndex in
                    HStack {
                        ForEach(Array(stride(from: 6, through: 0, by: -1)), id: \.self) { dayIndex in
                            let answer = getAnswer(for: weekIndex * 7 + dayIndex)
                            Rectangle()
                                .fill(answer.color)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
        .padding()
    }
    func getAnswer(for index: Int) -> Answer {
        let calendar = Calendar.current
        let endDate = Date() // The end date is today
        let dateForIndex = calendar.date(byAdding: .day, value: -index, to: endDate)!

        if let answerIndex = answers.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: dateForIndex) }) {
            return answers[answerIndex]
        }
        return Answer(date: dateForIndex, response: -1)  // Default answer
    }

//    func getAnswer(for index: Int) -> Answer {
//        let weeklyIndex = index / 7 * 7
//        let dayIndex = index % 7
//        let adjustedIndex = weeklyIndex + (6 - dayIndex)
//
//        if adjustedIndex < answers.count {
//            return answers[answers.count - 1 - adjustedIndex]
//        }
//        return Answer(date: Date(), response: -1)  // Default answer
//    }
}

func getLastSixMonthYearLabels() -> [String] {
    let calendar = Calendar.current
    var currentDate = Date()
    var monthYearLabels: [String] = []
    let dateFormatter = DateFormatter()
    
    for _ in 0..<6 {
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate) % 100 // To get the last two digits of the year
        if let monthName = dateFormatter.shortMonthSymbols?[month - 1] {
            monthYearLabels.insert("\(monthName) '\(String(format: "%02d", year))", at: 0)
        }
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }
    return monthYearLabels.reversed()
}

func getWeekdaysOrderedByCurrentDay() -> [String] {
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let currentIndex = Calendar.current.component(.weekday, from: Date()) % 7 // Get current weekday
    return Array(daysOfWeek[currentIndex...] + daysOfWeek[..<currentIndex])
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        let sampleAnswers: [Answer] = {
            var answers: [Answer] = []
            let calendar = Calendar.current
            for day in 0..<180 { // Last 6 months
                if let date = calendar.date(byAdding: .day, value: -day, to: Date()) {
                    answers.append(Answer(date: date, response: [1, 0, -1].randomElement()!))
                }
            }
            return answers
        }()
        
        LongHistoryChartView(answers: sampleAnswers,
                        monthYearLabels: getLastSixMonthYearLabels())
    }
}

