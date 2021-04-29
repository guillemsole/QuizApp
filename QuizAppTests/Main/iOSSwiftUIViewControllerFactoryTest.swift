//
//  iOSSwiftUIViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Guillem Solé Cubilo on 28/4/21.
//

import SwiftUI
import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class iOSSwiftUIViewControllerFactoryTest: XCTestCase {
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsController() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())

        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())

        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() throws {
        var answers = [[String]]()
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0)}))

        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        let view = try XCTUnwrap(makeMultipleAnswerViewcontroller())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsController() throws{
        let view = try XCTUnwrap(makeMultipleAnswerViewcontroller())

        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() throws {
        let view = try XCTUnwrap(makeMultipleAnswerViewcontroller())

        XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
    }
    
    func test_resultsViewController_createsViewControllerWithSummary() {
        let results = makeResultsController()
        
        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func test_resultsViewController_createsViewControllerWithPresentableAnswers() {
        let results = makeResultsController()

        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
    
    // MARK: - Helpers
    
    var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q1") }

    var options: [Question<String>: [String]] {
        [singleAnswerQuestion: ["A2", "A3", "A4"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
    }
    
    var correctAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A2", "A3", "A4"]), (multipleAnswerQuestion, ["A4", "A5", "A6"])]
    }
    
    func makeSUT() -> iOSSwiftUIViewControllerFactory {
        return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    func makeSingleAnswerQuestion(question: Question<String> = .singleAnswer("Q1"), answerCallback: @escaping ([String]) -> Void = { _ in } ) -> SingleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestion>
        return controller?.rootView
    }
    
    func makeMultipleAnswerViewcontroller(answerCallback: @escaping ([String]) -> Void = { _ in } ) -> MultipleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: multipleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<MultipleAnswerQuestion>
        return controller?.rootView
    }
    
    func makeResultsController() -> (controller: ResultViewController, presenter: ResultsPresenter) {
        let sut = makeSUT()
        let controller = sut.resultViewController(for: correctAnswers) as! ResultViewController
        let presenter = ResultsPresenter(userAnswers: correctAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        return (controller, presenter)
    }
}
