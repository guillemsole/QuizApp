//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation


public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
//    
//    func answer(for question: Question, completion: @escaping (Answer) -> Void) // asks
//    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) // tells
}
