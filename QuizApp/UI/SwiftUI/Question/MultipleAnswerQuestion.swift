//
//  MultipleAnswerQuestion.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 29/4/21.
//

import SwiftUI

struct MultipleAnswerQuestion: View {
    let title: String
    let question: String
    @State var store: MultipleSelectionStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HeaderView(title: title, subtitle: question)
            ForEach(store.options.indices) { i in
                MultipleTextSelectionCell(option: $store.options[i])
            }
            Spacer()
            
            RoundedButton(title: "Submit", isEnabled: store.canSubmit, action: store.submit)
            .padding()
        }
    }
}

struct MultipleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultipleAnswerQuestionTestView()
            
            MultipleAnswerQuestionTestView()
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .extraExtraLarge)
        }
    }
    
    struct MultipleAnswerQuestionTestView: View {
        @State var selection: [String] = ["none"]
        var body: some View {
            VStack {
                MultipleAnswerQuestion(
                    title: "1 of 2",
                    question: "What's Mike's nationality",
                    store: .init(options: [
                        "Portuguese",
                        "American",
                        "Greek",
                        "Canadian"],
                    handler: { selection = $0 })
                )
                Text("Last submission " + selection.joined(separator: ","))
            }
        }
    }
}
