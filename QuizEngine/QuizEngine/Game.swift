//
//  Game.swift
//  QuizEngine
//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation

public class Game<Question, Answer, Delegate: QuizDelegate> where Delegate.Question == Question, Delegate.Answer == Answer{
    let flow: Flow<Delegate>
    
    init(flow: Flow<Delegate>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer: Equatable, Delegate: QuizDelegate>(questions: [Question], delegate: Delegate, correctAnswers: [Question: Answer]) -> Game<Question, Answer, Delegate> {
    let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring($0, correctAnswer: correctAnswers) })
    flow.start()
    return  Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswer: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}
