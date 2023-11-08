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
    
    func getAnswer(for index: Int) -> Answer {
        let calendar = Calendar.current
        let endDate = Date() // The end date is today
        let dateForIndex = calendar.date(byAdding: .day, value: -index, to: endDate)!

        if let answerIndex = answers.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: dateForIndex) }) {
            return answers[answerIndex]
        }
        return Answer(date: dateForIndex, response: -1)  // Default answer
    }
    
    func calculateAverage(for dayIndex: Int) -> String {
        let weekdayIndex = (Calendar.current.component(.weekday, from: Date()) - dayIndex + 7) % 7
        let filteredAnswers = answers.filter {
            Calendar.current.component(.weekday, from: $0.date) == (weekdayIndex == 0 ? 7 : weekdayIndex)
        }
        
        let totalPositiveResponses = filteredAnswers.reduce(0) { $0 + ($1.response == 1 ? 1 : 0) }
        
        if filteredAnswers.isEmpty {
            return "--" // No data
        } else {
            let average = Double(totalPositiveResponses) / Double(filteredAnswers.count)
            let percent = Int(average * 100)
            return "\(percent)%" // Percentage without decimal places
        }
    }
    
    var body: some View {
        HStack {
            // Month Labels
            VStack(alignment: .leading, spacing: 20 * 4) {
                ForEach(monthYearLabels, id: \.self) { monthYear in
                    Text(monthYear)
                }
            }
            
            VStack(spacing: 10) {
                // Days of the Week Labels
                HStack {
                    ForEach(Array(stride(from: 6, through: 0, by: -1)), id: \.self) { dayIndex in
                        VStack {
                            Text(getWeekdaysOrderedByCurrentDay()[dayIndex])
                                .frame(width: 20)
                            Text(calculateAverage(for: dayIndex))
                                .font(.caption)
                                .frame(width: 20)
                        }
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

