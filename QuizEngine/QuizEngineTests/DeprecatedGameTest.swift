//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation
import XCTest
import QuizEngine // We don't make it teastable it means we are testing the public interface and as an integration test this is what we want
// Integration test
@available(*, deprecated)
class DeprecatedGameTest: XCTestCase {
    
    private let router = RouterSpy()
    private var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1","Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])

    }
    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        router.answerCompletion("wrong")
        router.answerCompletion("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        router.answerCompletion("A1")
        router.answerCompletion("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    
    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        router.answerCompletion("A1")
        router.answerCompletion("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
    
    private class RouterSpy: Router {
        var routedResult: Result<String, String>? = nil
        var routedQuestions: [String] = []
        
        var answerCompletion: (String) -> Void = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCompletion = answerCallback
        }
        
        func routeTo(result: Result<String, String>) {
            routedResult = result
        }
    }
}
