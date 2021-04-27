//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Guillem Solé Cubilo on 31/3/21.
//

import Foundation
import XCTest
@testable import QuizEngine // Access to all internal types
class FlowTest: XCTestCase {
    
    let delegate = DelegateSpy()
    
    func test_start_withNoQuestions_doesNotDelegateToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_delegatesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_delegatesAnotherCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }

    func test_start_withTwoQuestions_delegatesToFirstCorrectQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesToFirstCorrectQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doneNotDelegateAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCompletion("A1")

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_delegatesResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.handledResult!.answers, [:])
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_delegatesResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")


        XCTAssertEqual(delegate.handledResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in return 10 })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")


        XCTAssertEqual(delegate.handledResult!.score, 10)
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_scoresWithRightAnswer() {
        var receivedAnswers: [String: String] = [:]
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answers in
            receivedAnswers = answers
            return 20
        })
        
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")


        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers
    
    func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = { _ in return 0 }) -> Flow<DelegateSpy> {
        return Flow(questions: questions, delegate: delegate, scoring: scoring)
    }
    
    class DelegateSpy: QuizDelegate {
        var handledResult: Result<String, String>? = nil

        var handledQuestions: [String] = []
        
        var answerCompletion: (String) -> Void = { _ in }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCompletion = completion
        }
    }
}
