//
//  MultipleSelectionStoreTest.swift
//  QuizAppTests
//
//  Created by Guillem Solé Cubilo on 29/4/21.
//

import XCTest

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    
    internal init(options: [String]) {
        self.options = options.map { MultipleSelectionOption(text: $0)}
    }

}

struct MultipleSelectionOption {
    let text: String
    var isSelected: Bool = false

    mutating func select() {
        isSelected.toggle()
    }
}


class MultipleSelectionStoreTest: XCTestCase {
    func test() {
        var sut = MultipleSelectionStore(options: ["o1", "o2"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
}
