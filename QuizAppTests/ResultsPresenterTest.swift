//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import Foundation
import XCTest
@testable import QuizEngine
@testable import QuizApp

class ResultsPResenterTest: XCTestCase {
    
    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let answers = [
            Question.singleAnswer("Q1"): ["A1"],
            Question.multipleAnswer("Q2"): ["A2", "A3"]
        ]
        
        let result = Result(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result, correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let answers = Dictionary<Question<String>, [String]>()
        
        let result = Result(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result, correctAnswers: [:])

        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let answers = [Question.singleAnswer("Q1"): ["A1"]]
        let correctAnswers = [Question.singleAnswer("Q1"): ["A2"]]
        let result = Result(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let answers = [Question.singleAnswer("Q1"): ["A1", "A4"]]
        let correctAnswers = [Question.singleAnswer("Q1"): ["A2", "A3"]]
        let result = Result(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withCorrectSingleAnswer_mapsAnswer() {
        let answers = [Question.singleAnswer("Q1"): ["A1"]]
        let correctAnswers = [Question.singleAnswer("Q1"): ["A1"]]
        let result = Result(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
    
    func test_presentableAnswers_withCorrectMultipleAnswer_mapsAnswer() {
        let answers = [Question.singleAnswer("Q1"): ["A1", "A4"]]
        let correctAnswers = [Question.singleAnswer("Q1"): ["A1", "A4"]]
        let result = Result(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
}
