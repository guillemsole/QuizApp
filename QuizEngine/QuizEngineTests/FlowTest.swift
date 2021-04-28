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
    let dataSource = DataSourceSpy()
    
    func test_start_withNoQuestions_doesNotDelegateToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(dataSource.questionsAsked.isEmpty)
    }
    
    func test_start_withOneQuestions_delegatesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(dataSource.questionsAsked, ["Q1"])
    }
    
    func test_start_withOneQuestions_delegatesAnotherCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(dataSource.questionsAsked, ["Q2"])
    }

    func test_start_withTwoQuestions_delegatesToFirstCorrectQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(dataSource.questionsAsked, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesToFirstCorrectQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(dataSource.questionsAsked, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")

        XCTAssertEqual(dataSource.questionsAsked, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doneNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")

        XCTAssertEqual(dataSource.questionsAsked, ["Q1"])
    }
    
    func test_start_withOneQuestion_doesNotCompleteQuiz() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestions_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)

    }
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startAndAnswerFirstAndSecondQuestionTwice_withTwoQuestion_completesQuizTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()

        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")
        
        dataSource.answerCompletions[0]("A1-1")
        dataSource.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }
    
    // MARK: Helpers
    
    func makeSUT(questions: [String]) -> Flow<DelegateSpy, DataSourceSpy> {
        return Flow(questions: questions, delegate: delegate, dataSource: dataSource)
    }
}
