//
//  Created by Guillem Solé Cubilo on 28/4/21.
//

import Foundation
import QuizEngine

class DataSourceSpy: QuizDataSource {
    var answerCompletions: [(String) -> Void] = []
    var questionsAsked: [String] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
}
