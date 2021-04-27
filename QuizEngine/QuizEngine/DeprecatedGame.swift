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
public class Game<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer{
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router: router), scoring: { scoring($0, correctAnswer: correctAnswers) })
    flow.start()
    return  Game(flow: flow)
}

@available(*, deprecated)
private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswer: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}

struct QuizDelegateToRouterAdapter<R: Router>: QuizDelegate where R.Question == QuizDelegate.Question, R.Answer == QuizEngine.Answer {
    
    let router: Router

    init(router: Router) {
        self.router = router
    }
    
    
    func handle(result: Result<Question, Answer>) {
        self.router.routeTo(result: result)
    }
    
    func handle(question: Question, answerCallback: @escaping (Answer) -> Void) {
        self.router.routeTo(question: question, answerCallback: answerCallback)
    }
}
