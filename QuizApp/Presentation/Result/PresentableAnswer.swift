//
//  PresentableAnswer.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation

struct PresentableAnswer: Equatable {
    let question: String
    let answer: String
    let wrongAnswer: String?
}
