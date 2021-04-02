//
//  Question.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation

enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
