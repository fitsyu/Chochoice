//
//  MultipleChoiceTests.swift
//  MultipleChoiceTests
//
//  Created by Fitsyu  on 08/06/19.
//  Copyright © 2019 Fitsyu . All rights reserved.
//

import XCTest
@testable import Chochoice

class MultipleChoiceTests: XCTestCase {
    
    func test_it_accepts_valid_choices() {
        
        // arrange
        let acceptedChoices = [ "a", "b", "c" ]
        
        // act
        // assert
        XCTAssertNoThrow(try MultipleChoice<String>.init(choices: acceptedChoices),
                         "Distinct choices with >=2 items should be accepted")
    }
    
    func test_it_rejects_similiar_choices() {
        
        // arrange
        let rejectedChoices = [ 1, 1, 2, 1 ] // contains similiar elements
        
        // act
        var isExpectedError: Bool = false
        do {
            _ = try MultipleChoice<Int>.init(choices: rejectedChoices)
        } catch MultipleChoiceInitError.NotDistinct {
            isExpectedError = true
        } catch {
            isExpectedError = false
        }
        
        // assert
        XCTAssertTrue(isExpectedError, "Non-distinct set of choices should be rejected")
    }
    
    func test_it_rejects_less_than_two_choices() {
        
        // arrange
        let singleChoice: [String] = [ "yes" ]
        
        // act
        var isExpectedError: Bool = false
        do {
            _ = try MultipleChoice<String>.init(choices: singleChoice)
        } catch MultipleChoiceInitError.LessThanTwo {
            isExpectedError = true
        } catch {
            isExpectedError = false
        }
        
        XCTAssertTrue(isExpectedError, "the LessThanTwo error should be thrown")
    }
    
    func test_it_can_accept_ordered_prefilled_choices() {
        
        let prefilled = [ (choice: "yes", state: false),
                          (choice: "no", state: false),
                          (choice: "default", state:true),
        ]
        
        var mc: MultipleChoice<String>?
        
        do {
            let _mc = try MultipleChoice<String>.init(prefilledChoices: prefilled)
            
            mc = _mc
        } catch {
            dump(error)
        }
        
        XCTAssertNotNil(mc, "Object should be able to be constructed this way")
        if let mc = mc {
            XCTAssertEqual(mc.availableChoices, [ "yes", "no", "default" ])
        }
    }
    
    func test_user_can_select_the_choices() {
        
        let choices = [1,2,3,4,5]
        
        let mc = try! MultipleChoice<Int>.init(choices: choices)
        
        try? mc.markSelected(3)
        try? mc.markSelected(4)
        
        XCTAssertEqual( mc.userChoices,
                        [1:false, 2:false, 3:true, 4:true, 5:false],
                        "the option '3' and '4' should be marked selected" )
    }
    
    func test_user_can_deselect_the_choices() {
        
        let choices = [1,2,3,4,5]
        
        let mc = try! MultipleChoice<Int>.init(choices: choices)
        
        try? mc.markSelected(4)
        try? mc.markSelected(2)
        try? mc.markUnselected(4)
        
        XCTAssertEqual( mc.userChoices,
                        [1:false, 2:true, 3:false, 4:false, 5:false],
                        "the option '4' should be marked unselected" )
    }
    
    func test_user_cannot_select_unavailable_choice() {
        
        let choices = [ "buy", "save", "add", "negotiate" ]
        
        let mc = try? MultipleChoice<String>.init(choices: choices)
        
        var isExpectedError: Bool = false
        do {
            try mc?.markSelected("steal")
        } catch MultipleChoiceOperationError.InvalidChoice {
            isExpectedError = true
        } catch {
            isExpectedError = false
        }
        
        XCTAssertTrue(isExpectedError,
                      "InvalidChoice Error should be thrown when trying to mark invalid choice")
    }
    
    func test_it_cannot_operate_if_it_is_not_ready() {
        
        // arrange
        // construct non-ready object
        let mc = MultipleChoice<String>()
        
        // act
        var isExpectedError: Bool = false
        do {
            try mc.markSelected("non-existing")
        } catch MultipleChoiceOperationError.NotReady {
            isExpectedError = true
        } catch {
            isExpectedError = false
        }
        
        // assert
        XCTAssertTrue(isExpectedError, "Non ready should not be usable and operates")
    }
    
    func test_user_can_reset_the_choices() {
        
        let choices = [1,2,3,4,5]
        
        let mc = try! MultipleChoice<Int>.init(choices: choices)
        
        try? mc.markSelected(3)
        try? mc.markSelected(5)
        try? mc.markSelected(2)
        
        // act
        mc.reset()
        
        // assert
        XCTAssertEqual(mc.userChoices, [1:false, 2:false, 3:false, 4:false, 5:false])
    }
    
    func test_it_can_give_specific_choice_state() {
        
        let prefilled = [
            (choice: "Cheap and Luxury", state: false),
            (choice: "Cheap and Comfy", state: true)
        ]
        
        let mc = try? MultipleChoice<String>.init(prefilledChoices: prefilled)
        
        // act
        let state = try? mc?.state(of: "Cheap and Luxury")
        
        XCTAssertNotNil(state)
        XCTAssertEqual(state!, false)
    }
    
    func test_it_gives_the_selected_choices_back_when_applied() {
        
        let choices = [ "IDR", "SGD", "MYR", "USD" ]
        
        let mc = try! MultipleChoice<String>(choices: choices)
        
        try? mc.markSelected("IDR")
        try? mc.markSelected("MYR")
        
        // act
        let applied: [(choice: String, state: Bool)] = mc.appliedUserChoice()
        
        
        // assert
        let expected: [(choice: String, state: Bool)]  =  [
            (choice: "IDR", state: true),
            (choice: "SGD", state: false),
            (choice: "MYR", state: true),
            (choice: "USD", state: false)
        ]
        
        // XCTAssertEqual(applied, expected) // it said to be ambigious? :(
        for i in 0..<applied.count {
            XCTAssertEqual(applied[i].state, expected[i].state)
        }
    }
    
}
