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

class iOSSwiftUINavigationAdapterTest: XCTestCase {
    
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
    
    func test_resultsViewController_createsViewControllerWithTitle() throws {
        let (view, presenter) = try XCTUnwrap(makeResults())

        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_resultsViewController_createsViewControllerWithSummary() throws {
        let (view, presenter) = try XCTUnwrap(makeResults())

        XCTAssertEqual(view.summary, presenter.summary)
    }
    
    func test_resultsViewController_createsViewControllerWithPresentableAnswers() throws {
        let (view, presenter) = try XCTUnwrap(makeResults())

        XCTAssertEqual(view.answers, presenter.presentableAnswers)
    }
    
    func test_resultsViewController_createsViewControllerWithPlayAgainAction() throws {
        var playAgainCount = 0
        let (view, _) = try XCTUnwrap(makeResults(playAgain: { playAgainCount += 1}))

        XCTAssertEqual(playAgainCount, 0)
        
        view.playAgain()
        XCTAssertEqual(playAgainCount, 1)
        
        view.playAgain()
        XCTAssertEqual(playAgainCount, 2)
        
        view.playAgain()
        XCTAssertEqual(playAgainCount, 3)
    }
    
    func test_answerForQuestion_replacesCurrentView() {
        let (sut, navigation) = makeSUT()
        
        sut.answer(for: singleAnswerQuestion) { _ in }
        XCTAssertNotNil(navigation.singleCurrentView)

        sut.answer(for: multipleAnswerQuestion) { _ in }
        XCTAssertNotNil(navigation.multipleCurrentView)
    }
    
    func test_didCompleteQuiz_replacesCurrentView() {
        let (sut, navigation) = makeSUT()

        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertNotNil(navigation.resultCurrentView)

        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertNotNil(navigation.resultCurrentView)
    }

    func test_publishesNavigationChanges() {
        let (sut, navigation) = makeSUT()
        
        var navigationChangeCount = 0
        let cancellable = navigation.objectWillChange.sink { navigationChangeCount += 1 }
        
        XCTAssertEqual(navigationChangeCount, 0)
        
        sut.answer(for: singleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationChangeCount, 1)

        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertEqual(navigationChangeCount, 2)

        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertEqual(navigationChangeCount, 3)
        
        cancellable.cancel()
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
    
    func makeSUT(playAgain: @escaping () -> Void = {}) -> (iOSSwiftUINavigationAdapter, QuizNavigationStore) {
        let navigation = QuizNavigationStore()
        let sut = iOSSwiftUINavigationAdapter(navigation: navigation, options: options, correctAnswers: correctAnswers, playAgain: playAgain)
        return (sut, navigation)
    }
    
    func makeSingleAnswerQuestion(question: Question<String> = .singleAnswer("Q1"), answerCallback: @escaping ([String]) -> Void = { _ in } ) -> SingleAnswerQuestion? {
        let (sut, navigation) = makeSUT()
        sut.answer(for: singleAnswerQuestion, completion: answerCallback)
        return navigation.singleCurrentView
    }
    
    func makeMultipleAnswerViewcontroller(answerCallback: @escaping ([String]) -> Void = { _ in } ) -> MultipleAnswerQuestion? {
        let (sut, navigation) = makeSUT()
        sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
        return navigation.multipleCurrentView
    }
    
    func makeResults(playAgain: @escaping () -> Void = {}) -> (view: ResultView, presenter: ResultsPresenter)? {
        let (sut, navigation) = makeSUT(playAgain: playAgain)
        sut.didCompleteQuiz(withAnswers: correctAnswers)
        let view = navigation.resultCurrentView
        let presenter = ResultsPresenter(userAnswers: correctAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        return view.map { ($0, presenter) }
    }
}

private extension QuizNavigationStore {
    var singleCurrentView: SingleAnswerQuestion? {
        if case let .single(view) = currentView { return view }
        return nil
    }
    
    var multipleCurrentView: MultipleAnswerQuestion? {
        if case let .multiple(view) = currentView { return view }
        return nil
    }
    
    var resultCurrentView: ResultView? {
        if case let .result(view) = currentView { return view }
        return nil
    }
}
