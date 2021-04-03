//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import Foundation

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String {
        guard let questionIndex = questions.firstIndex(of: question) else { return "" }
        return "Question #\(questionIndex + 1)"
    }
}
