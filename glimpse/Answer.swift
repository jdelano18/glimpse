//
//  Answer.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/22/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model final class Answer: Identifiable {
    var id = UUID()
    var date: Date
    var response: Int   // 1: yes, 0: no, -1: missing
    
    var color: Color {
        switch response {
        case 1:
            return Color.green
        case 0:
            return Color.red
        default:
            return Color.gray
        }
    }
    
    var dayOfWeekShort: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // This will give full form e.g., "Monday"
        if let firstChar = formatter.string(from: date).first {
            return String(firstChar) // Just the first character, e.g., "M"
        }
        return ""
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Question.answers)
    var question: Question?

    init(id: UUID = UUID(), date: Date, response: Int, question: Question? = nil) {
        self.id = id
        self.date = date
        self.response = response
        self.question = question
    }
}

extension Answer {
    static var preview: Answer {
        let answer = Answer(date: .now, response: 1)
        answer.question = .preview
        return answer
    }
}

//extension Answer {
//    static var sampleAnswers: [Answer] {
//        var samples: [Answer] = []
//        
//        for dayOffset in 0..<10 {
//            let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date())!
//            let randomResponse = Int.random(in: -1...1) // generate random response for diversity
//            let sampleAnswer = Answer(date: date, response: randomResponse)
//            
//            samples.append(sampleAnswer)
//        }
//        
//        return samples
//    }
//}

