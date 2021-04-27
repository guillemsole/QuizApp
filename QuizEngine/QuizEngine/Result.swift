//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
    internal init(answers: [Question: Answer], score: Int) {
        self.answers = answers
        self.score = score
    }
}
