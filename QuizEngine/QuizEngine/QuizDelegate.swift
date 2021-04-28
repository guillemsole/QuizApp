//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question
    associatedtype Answer

    public func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
