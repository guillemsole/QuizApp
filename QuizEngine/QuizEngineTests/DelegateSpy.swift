//
//  DelegateSpy.swift
//  QuizEngineTests
//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var completedQuizzes: [[(String, String)]] = []
    
    var answerCompletions: [(String) -> Void] = []
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
}
