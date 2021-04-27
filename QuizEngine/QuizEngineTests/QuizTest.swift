//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {

    private var quiz: Quiz!
    
    func test_startQuiz_answerAllQuestions_completesWithAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)

        delegate.answersCompletion[0]("A1")
        delegate.answersCompletion[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startQuiz_answerAllQuestions_completesWithNewAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(questions: ["Q1","Q2"], delegate: delegate)

        delegate.answersCompletion[0]("A1")
        delegate.answersCompletion[1]("A2")

        delegate.answersCompletion[0]("A1-1")
        delegate.answersCompletion[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }
    
    private class DelegateSpy: QuizDelegate {
        var completedQuizzes: [[(String, String)]] = []
        
        var answersCompletion: [(String) -> Void] = []
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answersCompletion.append(completion)
        }
    }
}
