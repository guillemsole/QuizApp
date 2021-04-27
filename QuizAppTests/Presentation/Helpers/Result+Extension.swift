//
//  Result+Extension.swift
//  QuizAppTests
//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation

@testable import QuizEngine

extension Result: Hashable {

    static func make(answers: [Question: Answer] = [:], score: Int = 1) -> Result<Question, Answer> {
        return Result(answers: answers, score: score)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(score)
    }
    
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
