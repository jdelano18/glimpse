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
    var id: UUID
    @Attribute(.unique)
    var title: String
    var yesIsPositive: Bool
    var notificationTime: Date
    
    var answers: [Answer]?
    
    
    init(id:UUID = UUID(), title: String, answers: [Answer] = [], yesIsPositive: Bool, notificationTime: Date) {
        self.id = id
        self.title = title
        self.answers = answers
        self.yesIsPositive = yesIsPositive
        self.notificationTime = notificationTime
    }
}

extension Question {
    static var preview: Question {
        let sampleQuestion = Question(
            title: "If today was the last day of your life, would you want to do what you are about to do?",
            yesIsPositive: true,
            notificationTime: Date()
        )
        return sampleQuestion
    }
}
