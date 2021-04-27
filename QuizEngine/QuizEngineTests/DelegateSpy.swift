//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation
@testable import QuizEngine

class DelegateSpy: QuizDelegate {
    var handledQuestions: [String] = []
    var handledResult: Result<String, String>? = nil
    
    var answerCallback: (String) -> Void = { _ in }
    
    func handle(question: String, answerCallback: @escaping (String) -> Void) {
        handledQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func handle(result: Result<String, String>) {
        handledResult = result
    }
}
