//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import UIKit
import QuizEngine

final class iOSUIKitViewControllerFactory: ViewControllerFactory {
    
    typealias Answers = [(question: Question<String>, answer: [String])]
    private let options: [Question<String>: [String]]
    private let correctAnswers: Answers

    private var questions: [Question<String>] {
        return correctAnswers.map { $0.question }
    }

    init(options: [Question<String>: [String]], correctAnswers: Answers) {
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
        case .multipleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
        }
    }
    
    private func questionViewController(for question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
    
    func resultViewController(for answers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        return ResultViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
    }
}
