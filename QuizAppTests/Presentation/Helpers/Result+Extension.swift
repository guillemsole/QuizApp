//
//  Result+Extension.swift
//  QuizAppTests
//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation

@testable import QuizEngine

extension Result {

    static func make(answers: [Question: Answer] = [:], score: Int = 1) -> Result<Question, Answer> {
        return Result(answers: answers, score: score)
    }
}

extension Result: Equatable where Answer: Equatable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score && lhs.answers == rhs.answers
    }
}

extension Result: Hashable where Answer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers)
        hasher.combine(score)
    }
}
