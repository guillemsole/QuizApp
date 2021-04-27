//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import UIKit
import XCTest
@testable import QuizApp
@testable import QuizEngine

class iOSViewControllerFactoryTest: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")

    let options = ["A1", "A2"]
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsController() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsController() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController().allowsMultipleSelection)
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
    
    func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
    }
    
    func makeResultsController() -> (controller: ResultViewController, presenter: ResultsPresenter) {
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        
        let result = Result(answers: userAnswers, score: 2)

        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let sut = makeSUT(correctAnswers: correctAnswers)
        
        let controller = sut.resultViewController(for: result) as! ResultViewController

        return (controller: controller, presenter: presenter)
    }
}

