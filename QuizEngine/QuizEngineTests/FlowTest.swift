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
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_routeToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_routeToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }

    func test_start_withTwoQuestions_routeToFirstCorrectQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routeToFirstCorrectQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routeToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doneNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCallback("A1")

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.handledResult!.answers, [:])
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")


        XCTAssertEqual(delegate.handledResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in return 10 })
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")


        XCTAssertEqual(delegate.handledResult!.score, 10)
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_scoresWithRightAnswer() {
        var receivedAnswers: [String: String] = [:]
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answers in
            receivedAnswers = answers
            return 20
        })
        
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")


        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers
    
    func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = { _ in return 0 }) -> Flow<DelegateSpy> {
        return Flow(questions: questions, delegate: delegate, scoring: scoring)
    }
    
    class DelegateSpy: Router, QuizDelegate {
        var handledResult: Result<String, String>? = nil

        var handledQuestions: [String] = []
        
        var answerCallback: (String) -> Void = { _ in }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}
