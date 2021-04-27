//
//  Game.swift
//  QuizEngine
//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}


@available(*, deprecated)
public class Game<Question, Answer, R: Router> {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router), scoring: { scoring($0, correctAnswer: correctAnswers) })
    flow.start()
    return  Game(flow: flow)
}

@available(*, deprecated)
func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswer: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    private let router: R

    init(_ router: R) {
        self.router = router
    }
    
    func handle(result: Result<R.Question, R.Answer>) {
        self.router.routeTo(result: result)
    }
    
    func handle(question: R.Question, answerCallback: @escaping (R.Answer) -> Void) {
        self.router.routeTo(question: question, answerCallback: answerCallback)
    }
}
