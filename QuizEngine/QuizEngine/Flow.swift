//
//  Created by Guillem Solé Cubilo on 31/3/21.
//

import Foundation

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router: R // Type we are gonna communicate depending on the communication platform that we are running. It's a contract.
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            
            let nextQuestionIndex = currentQuestionIndex+1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(from: questions[nextQuestionIndex]))
            } else {
                router.routeTo(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
