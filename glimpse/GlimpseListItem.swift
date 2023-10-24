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
        NavigationLink(value: question){
            VStack(alignment: .leading) {
                Text(question.title)
                    .font(.headline)
                HStack {
                    Text("sup")
//                    ForEach(question.answers) { answer in
//                        Text("Answer is \(answer.response)")
//                    }
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
