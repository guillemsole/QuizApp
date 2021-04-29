//
//  MultipleSelectionStoreTest.swift
//  QuizAppTests
//
//  Created by Guillem Solé Cubilo on 29/4/21.
//

import XCTest

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    var canSubmit: Bool {
        !options.filter(\.isSelected).isEmpty
    }
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
    func test_selectOption_toggles_state() {
        var sut = MultipleSelectionStore(options: ["o1", "o2"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = MultipleSelectionStore(options: ["o1", "o2"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[1].select()
        XCTAssertTrue(sut.canSubmit)
    }
}
