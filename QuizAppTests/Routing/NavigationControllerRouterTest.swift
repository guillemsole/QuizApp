//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {

    func test_answerForQuestion_showQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        factory.stub(question: singleAnswerQuestion, with: viewController)
        factory.stub(question: multipleAnswerQuestion, with: secondViewController)
        
        sut.answer(for: singleAnswerQuestion, completion: {_ in })
        sut.answer(for: multipleAnswerQuestion, completion: {_ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        var callbackWasFired = false
        sut.answer(for: singleAnswerQuestion, completion: { _ in callbackWasFired = true })
        factory.answerCallback[singleAnswerQuestion]!(["anything"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_singleAnswer_doesNotConfiguresViewcontrollerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        var callbackWasFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackWasFired = true })
        
        factory.answerCallback[multipleAnswerQuestion]!(["anything"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_answerForQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        
        factory.stub(question: multipleAnswerQuestion, with: viewController)

        sut.answer(for: multipleAnswerQuestion, completion: { _ in  })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        
        factory.stub(question: multipleAnswerQuestion, with: viewController)

        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)

        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        
        factory.stub(question: multipleAnswerQuestion, with: viewController)

        var callbackWasFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in  callbackWasFired = true })

        factory.answerCallback[multipleAnswerQuestion]!(["anything"])
        
        factory.answerCallback[multipleAnswerQuestion]!([])
        let button = viewController.navigationItem.rightBarButtonItem!
        
        button.simulateTap()
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_didCompleteQuiz_showsResultController() {
        let viewController = UIViewController()
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        
        let secondViewController = UIViewController()
        let secondUserAnswers = [(multipleAnswerQuestion, ["A1"])]
        
        factory.stub(resultForQuestions: [singleAnswerQuestion], with: viewController)
        factory.stub(resultForQuestions: [multipleAnswerQuestion], with: secondViewController)

        sut.didCompleteQuiz(withAnswers: userAnswers)
        sut.didCompleteQuiz(withAnswers: secondUserAnswers)

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK: - Helpers
    
    private let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    private let singleAnswerQuestion = Question.singleAnswer("Q1")

    private let navigationController = NonAnimatedNavigationController()
    private let factory = ViewControllerFactoryStub()
    private lazy var sut = {
        NavigationControllerRouter(navigationController, factory: factory)
    }()
    
    private class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }

    private class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = Dictionary<[Question<String>], UIViewController>()
        var answerCallback = [Question<String>: ([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(resultForQuestions questions: [Question<String>], with viewController: UIViewController) {
            stubbedResults[questions] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for answers: Answers) -> UIViewController {
            return stubbedResults[answers.map { $0.question }] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return UIViewController()
        }
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
