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
    var answers: [Answer] = [Answer]()
    
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
    @Transient
    var displayName: String {
        title.isEmpty ? "Sample Question" : title
    }
    
    static var preview: Question {
        Question(title: "If today was the last day of your life, would you want to do what you are about to do?", yesIsPositive: true, notificationTime: .now)
    }
}
