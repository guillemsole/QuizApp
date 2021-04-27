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
    
    let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_routeToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_routeToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestions_routeToFirstCorrectQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routeToFirstCorrectQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routeToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doneNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(router.routedResult!.answers, [:])
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")


        XCTAssertEqual(router.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in return 10 })
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")


        XCTAssertEqual(router.routedResult!.score, 10)
    }
    
    func test_startAndAnswerFirstQuestionAndSecond_withTwoQuestions_scoresWithRightAnswer() {
        var receivedAnswers: [String: String] = [:]
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answers in
            receivedAnswers = answers
            return 20
        })
        
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")


        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers
    
    func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = { _ in return 0 }) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router, scoring: scoring)
    }
}
