
//
//  Created by Guillem Solé Cubilo on 28/4/21.
//

import Foundation
import XCTest

class ScoreTest: XCTestCase {
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }
    
    func test_oneNoMatchingAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["not a match"], comparingTo: ["an answer"]), 0)
    }
    
    func test_oneMatchingAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["an answer"], comparingTo: ["an answer"]), 1)
    }
    
    func test_oneMatchingAnswerOneNonMatching_scoresOne() {
        let score = BasicScore.score(for: ["an answer", "not a match"], comparingTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(for: ["an answer", "another answer"], comparingTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyAnswers_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(for: ["an answer", "another answer", "an extra answer"], comparingTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 2)
    }
    
    private class BasicScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            var score = 0
            for (index, answer) in answers.enumerated() {
                if index >= correctAnswers.count { return score }
                score += (correctAnswers[index] == answer) ? 1 : 0
            }
            return score
        }
    }
}
