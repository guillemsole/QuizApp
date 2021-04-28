//
//  QuizDataSource.swift
//  QuizEngine
//
//  Created by Guillem Solé Cubilo on 28/4/21.
//

import Foundation

public protocol QuizDataSource {
    associatedtype Question
    associatedtype Answer
    
    public func answer(for question: Question, completion: @escaping (Answer) -> Void)
}
