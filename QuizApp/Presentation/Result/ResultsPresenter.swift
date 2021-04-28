//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import Foundation
import QuizEngine

final class ResultsPresenter {
    typealias Answers = [(question: Question<String>, answers: [String])]
    typealias Scorer = ([[String]], [[String]]) -> Int
    
    private let userAnswers: Answers
    private let correctAnswers: Answers
    private let scorer: Scorer
    
    init(result: Result<Question<String>, [String]>, questions: [Question<String>], correctAnswers: [Question<String>: [String]]) {
        self.userAnswers = questions.map { question in
            (question, result.answers[question]!)
        }
        self.correctAnswers = questions.map { question in
            (question, correctAnswers[question]!)
        }
        self.scorer = { _, _ in result.score}
    }
    var summary: String {
        return "You got \(score)/\(userAnswers.count) correct"
    }
    
    private var score: Int {
        return scorer(userAnswers.map { $0.answers }, correctAnswers.map { $0.answers })
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return zip(userAnswers, correctAnswers).map { userAnswer, correctAnswer in
            return presentableAnswer(userAnswer.question, userAnswer.answers, correctAnswer.answers)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ userAnswer: [String], _ correctAnswer: [String]) -> PresentableAnswer {
        
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer))
        }
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ userAnswers: [String], _ correctAnswer: [String]) -> String? {
        return correctAnswer == userAnswers ? nil : formattedAnswer(userAnswers)
    }
}
