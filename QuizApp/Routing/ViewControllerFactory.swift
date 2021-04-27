//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 5/4/21.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
