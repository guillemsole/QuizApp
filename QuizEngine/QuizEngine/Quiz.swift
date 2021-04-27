//
//  Created by Guillem Solé Cubilo on 27/4/21.
//

import Foundation


public final class Quiz {
    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }

    public static func start<Delegate: QuizDelegate>(
        questions: [Delegate.Question],
        delegate: Delegate
    ) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(
            questions: questions,
            delegate: delegate
        )
        flow.start()
        return  Quiz(flow: flow)
    }
}

func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswer: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}
