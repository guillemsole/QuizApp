//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation
import XCTest
import QuizEngine // We don't make it teastable it means we are testing the public interface and as an integration test this is what we want
// Integration test
class GameTest: XCTestCase {
    
    let delegate = DelegateSpy()
    var game: Game<String, String, DelegateSpy>!
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1","Q2"], delegate: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])

    }
    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    
    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
}
