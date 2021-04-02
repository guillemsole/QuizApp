//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import UIKit
import XCTest
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    
    func test_routeToQuestion_presentsQuestionController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)
        
        sut.routeTo(question: "Q1", answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    func test_routeToQuestionTwice_presentsQuestionController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)
        
        sut.routeTo(question: "Q1", answerCallback: {_ in })
        sut.routeTo(question: "Q2", answerCallback: {_ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }
}
