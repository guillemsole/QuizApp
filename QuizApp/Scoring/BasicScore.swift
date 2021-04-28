//
//  Created by Guillem Solé Cubilo on 28/4/21.
//

import Foundation

final class BasicScore {
    static func score<T: Equatable>(for answers: [T], comparingTo correctAnswers: [T]) -> Int {
        return zip(answers, correctAnswers).reduce(0) { score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
