//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import Foundation
import QuizEngine

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String {
        guard let questionIndex = questions.firstIndex(of: question) else { return "" }
        return "\(questionIndex + 1) of \(questions.count)"
    }
}
