//
//  Created by Guillem Solé Cubilo on 3/4/21.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    
    init(questions: [Question<String>], options: [Question<String>: [String]]) {
        self.questions = questions
        self.options = options
    }

    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, answerCallback: answerCallback)
        case .multipleAnswer(let value):
            let controller = questionViewController(for: question, value: value, options: options, answerCallback: answerCallback)
            _ = controller.view
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
    
    private func questionViewController(for question: Question<String>, value: String, options: [String], answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }

}
