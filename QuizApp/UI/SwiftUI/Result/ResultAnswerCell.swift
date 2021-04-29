//
//  ResultAnswerCell.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 29/4/21.
//

import SwiftUI

struct ResultAnswerCell: View {
    let model: PresentableAnswer
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(model.question)
                .font(.title)
            Text(model.answer)
                .font(.subheadline)
                .foregroundColor(.green)
            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }.padding(.vertical)
    }
}

struct ResultAnswerCell_Previews: PreviewProvider {
    static var previews: some View {
        ResultAnswerCell(model: .init(question: "A question", answer: "An answer", wrongAnswer: "A wrong answer"))
            .previewLayout(.sizeThatFits)
        ResultAnswerCell(model: .init(question: "A question", answer: "An answer", wrongAnswer: nil))
            .previewLayout(.sizeThatFits)

    }
}
