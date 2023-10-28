//
//  GlimpseListItem.swift
//  glimpse
//
//  Created by Jimmy DeLano on 10/23/23.
//

import SwiftUI

struct GlimpseListItem: View {
    var question: Question
    
    var body: some View {
        NavigationLink(value: question) {
            VStack {
                Text(question.title)
                    .font(.headline)
                HStack {
                    Text("Number of answers: \(question.answers.count)")

                    ForEach(question.answers) { answer in
                        Text("sup")
                        Text("Answer is \(answer.response)")
                    }
                }
            }
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer){
        List {
            GlimpseListItem(question: .preview)
        }
    }
}
