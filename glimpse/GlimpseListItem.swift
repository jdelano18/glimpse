//
//  GlimpseListItem.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/23/23.
//

import SwiftUI
import SwiftData

struct GlimpseListItem: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var answers: [Answer]
    
    var question: Question

    
    var body: some View {
        NavigationLink(value: question) {
            VStack {
                Text(question.title)
                    .font(.headline)
                HStack {
                    if answers.isEmpty {
                        ContentUnavailableView("No Answers Yet!", systemImage: "icloud.slash")
                    } else {
                        ForEach(Date.last7Days, id: \.self) { date in
                            if let answer = answers.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                                VStack {
                                    Rectangle()
                                        .fill(answer.color)
                                        .frame(width: 30, height: 30)
                                    Text(answer.dayOfWeekShort)
                                        .font(.caption)
                                }
                            } else {
                                VStack {
                                    Rectangle()
                                        .fill(Color.gray) // default color for missing data
                                        .frame(width: 30, height: 30)
                                    Text(getShortDayOfWeek(from: date))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
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
            GlimpseListItem(question: .preview)
        }
    }
}
