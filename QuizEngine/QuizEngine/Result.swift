//
//  Created by Guillem Solé Cubilo on 2/4/21.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
