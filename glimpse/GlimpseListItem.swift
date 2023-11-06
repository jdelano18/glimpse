//
//  GlimpseListItem.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/23/23.
//

import SwiftUI
import SwiftData

struct GlimpseListItem: View {
    @Environment(\.modelContext) private var modelContext
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
    
    var body: some View {
        NavigationLink(value: selectedQuestion) {
            VStack {
                Text(selectedQuestion.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if filteredAnswers.isEmpty {
                        VStack {
                            Image(systemName: "icloud.slash")
                                .imageScale(.large)
                                .foregroundColor(.secondary)
                            Text("No Answers Yet!")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        ForEach(Date.last7Days, id: \.self) { date in
                            if let answer = filteredAnswers.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                                VStack {
                                    Rectangle()
                                        .fill(answer.color)
                                        .frame(width: 30, height: 30)
                                    Text(answer.dayOfWeekShort)
                                        .font(.caption)
                                }
                            } else { // missing answer, gray box
                                VStack {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 30, height: 30)
                                    Text(getShortDayOfWeek(from: date))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func getShortDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        if let firstChar = formatter.string(from: date).first {
            return String(firstChar)
        }
        return ""
    }
}



extension Date {
    static var last7Days: [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        for daysAgo in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) {
                dates.append(date)
            }
        }
        return dates.reversed()
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer){
        List {
            GlimpseListItem(selectedQuestion: .preview)
        }
    }
}
