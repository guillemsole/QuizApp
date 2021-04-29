//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 28/4/21.
//

import SwiftUI
import UIKit
import QuizEngine

final class iOSSwiftUIViewControllerFactory: ViewControllerFactory {
    
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
        let presenter = QuestionPresenter(questions: questions, question: question)

        switch question {
        case .singleAnswer(let value):
            return UIHostingController(
                rootView: SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { answerCallback([$0]) }
                )
            )
        case .multipleAnswer(let value):
            return UIHostingController(
                rootView: MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(options: options, handler: answerCallback)
                )
            )
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
