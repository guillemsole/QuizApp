//
//  QuestionPresenterTest.swift
//  QuizAppTests
//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class QuestionPresenterTest: XCTestCase {
    let question1 = Question.singleAnswer("Q1")
    let question2 = Question.multipleAnswer("Q2")
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)

        XCTAssertEqual(sut.title, "1 of 2")
    }
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        
        XCTAssertEqual(sut.title, "2 of 2")
    }
    
    func test_title_forUnexistingQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: question1)
        
        XCTAssertEqual(sut.title, "")
    }
}
