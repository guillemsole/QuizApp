//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import Foundation
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {
    
    func test_questionViewController_createsController() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(for: Question.singleAnswer("Q1"), answerCallback: { _ in }) as! QuestionViewController
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_createsControllerWithOptions() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
        
        XCTAssertEqual(controller.options, options)
    }
}

