//
//  Question.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/22/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model final class Question {
    var title: String
    var yesIsPositive: Bool
    var notificationTime: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Answer.question)
    var answers: [Answer] = []
    
    var streak: Int {
        var streakCount = 0
        let positiveResponse: Int = yesIsPositive ? 1 : 0
        
        for answer in answers.reversed() {
            if answer.response == positiveResponse {
                streakCount += 1
            } else {
                break
            }
        }
        return streakCount
    }
    
    init(title: String, answers: [Answer] = [], yesIsPositive: Bool, notificationTime: Date) {
        self.title = title
        self.answers = answers
        self.yesIsPositive = yesIsPositive
        self.notificationTime = notificationTime
    }
}

extension Question {
    static var preview: Question {
//        let sampleAnswer = Answer.preview
        let sampleQuestion = Question(
            title: "If today was the last day of your life, would you want to do what you are about to do?",
//            answers: [sampleAnswer], // Attach the sample answer here
            yesIsPositive: true,
            notificationTime: Date()
        )
//        sampleAnswer.question = sampleQuestion
        return sampleQuestion
    }
}


//extension Date {
//    static func lastWeekDates() -> [Date] {
//        var dates: [Date] = []
//        let today = Date()
//        let calendar = Calendar.current
//        
//        for dayIndex in 0..<7 {
//            if let date = calendar.date(byAdding: .day, value: -dayIndex, to: today) {
//                dates.append(date)
//            }
//        }
//        return dates.reversed()
//    }
//}
//
//extension Array where Element == Question {
//    func mergedWithLastWeek() -> [Question] {
//        let lastWeek = Date.lastWeekDates()
//        var mergedQuestions: [Question] = []
//        
//        for question in self {
//            var newAnswers: [Answer] = []
//            for date in lastWeek {
//                if let answerForDate = question.answers.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
//                    newAnswers.append(answerForDate)
//                } else {
//                    newAnswers.append(Answer(date: date, response: -1)) // Gray value
//                }
//            }
//            let newQuestion = Question(title: question.title, answers: newAnswers, yesIsPositive: question.yesIsPositive, notificationTime: question.notificationTime)
//            mergedQuestions.append(newQuestion)
//        }
//        return mergedQuestions
//    }
//}
