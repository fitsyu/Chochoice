//
//  MultipleChoice.swift
//  MultipleChoice
//
//  Created by Fitsyu  on 09/06/19.
//  Copyright © 2019 Fitsyu . All rights reserved.
//

// Give me a list of choice for user to select from
// I will return the user's choices back to you

// presentation option: CLI | GUI | NUI

/*
 choice : T
 where T is
 - comparable    -> so we can check the uniqueness
 - iterable      -> so we can select by their name or index
 - displayable   -> so we can present it to user
 
 choices must be distinct amongs itself
 choices must be more than 1
 choices cannot be zero
 
 // set the choices
 MultipleChoice.init([opt1, opt2, opt3])
 MultipleChoice.init(opt1, opt2, opt3)
 
 MultipleChoice() // tolerant construction but the object shouldn't be usable before
 // choices are set
 try? MultipleChoice.setChoices = [ opt1, opt2, opt3 ]
 
 // it's helpful to use a Class Service to see if a choices set is okay or not
 // before using to construct a MultipleChoice object
 MultipleChoice::SensibilityCheck(on: choices) -> Bool
 
 // selecting a choice
 try? MultipleChoice.markSelected( opt1 )
 try? MultipleChoice.markSelected( 0 )
 
 // deselecting a choice
 try? MultipleChoice.markUnselected( opt3 )
 try? MultipleChoice.markUnselected( 2 )
 
 // convenience method to deselect all choices
 MultipleChoice.reset()
 
 
 // get the user selected choices
 let userChoices: [ Choice:Bool ] = MultipcleChoice.userChoices()
 
 
 // Set the UI
 MultipleChoice.ui: MultipleChoiceUI = CLIMultipleChoice()
 MultipleChoice.ui.present()
 
 
 // the presenter
 protocol MultipleChoiceUI {
 
 func present()
 
 func dismiss()
 }
 
 */



enum MultipleChoiceInitError: Error {
    
    case LessThanTwo
    case NotDistinct
}

enum MultipleChoiceOperationError: Error {
    
    case NotReady
    case InvalidChoice
    case Unknown
}


/**
 MultipleChoice
 
 give it set of available choice e.g [ "mac", "macbook", "watch", "tv" ]
 during its initialization
 
 ```
 MultipleChoice<String>([ "mac", "macbook", "watch", "tv" ])
 ```
 
 it is a generic object so we need to supply the type it will work on.
 
 the type is required to be hashable.
 
 then we can mark one or more choice to select by calling `markSelected` function like this
 
 ```
 try? mc.markSelected("watch")
 try? mc.markSelected("mac")
 ```
 
 if we try to select invalid choice, be prepared to get `InvalidChoice` error
 to unmark a choice call
 
 ```
 try? mc.markUnselected("watch")
 ```
 
 then get the status of every choice like this
 
 ```
 mc.appliedUserChoices()
 ```
 
 that would return the choices as ordered list along with its selection state.
 
 if we like to get the raw data, the dictionary is available as `userChoices` property.
 
*/
open class MultipleChoice<T: Hashable>  {
    
    public typealias PresetChoice = (choice: T, state: Bool)
    
    public let availableChoices: [T]
    public var userChoices: [T:Bool]
    
    private var isUsable: Bool = false
    
    // MARK: Initializers
    public init() {
        availableChoices = []
        userChoices = [:]
        isUsable = false
    }
    
    init(availableChoices: [T], prefilledChoices: [T:Bool]) {
        
        self.availableChoices = availableChoices
        self.userChoices = prefilledChoices
        
        isUsable = true
    }
    
    public convenience init(choices: [T]) throws {
        
        do {
            try MultipleChoice.SensibleCheck(on: choices)
        } catch {
            throw error
        }
        
        var dict: [T:Bool] = [:]
        choices.forEach { dict[$0] = false }
        
        self.init(availableChoices: choices, prefilledChoices: dict)
    }
    
    public convenience init(prefilledChoices: [PresetChoice]) throws {
        
        let _choices = prefilledChoices.map { $0.choice }
        
        do {
            try MultipleChoice.SensibleCheck(on: _choices)
        } catch {
            throw error
        }
        
        var dict: [T:Bool] = [:]
        _choices.forEach { dict[$0] = false }
        prefilledChoices.forEach { dict[$0.choice] = $0.state }
        
        self.init(availableChoices: _choices, prefilledChoices: dict )
    }
    
    
    // MARK: Useful functions
    public func markSelected(_ item: T) throws {
        
        guard isUsable else {
            throw MultipleChoiceOperationError.NotReady
        }
        
        guard ( userChoices.contains { $0.key == item } ) else {
            throw MultipleChoiceOperationError.InvalidChoice
        }
        
        userChoices[item] = true
    }
    
    public func markUnselected(_ item: T) throws {
        
        guard isUsable else {
            throw MultipleChoiceOperationError.NotReady
        }
        
        guard ( userChoices.contains { $0.key == item } ) else {
            throw MultipleChoiceOperationError.InvalidChoice
        }
        
        userChoices[item] = false
    }
    
    public func reset() {
        
        for choice in userChoices {
            userChoices[choice.key] = false
        }
    }
    
    public func state(of choice: T) throws -> Bool {
        
        guard isUsable else {
            throw MultipleChoiceOperationError.NotReady
        }
        
        guard availableChoices.contains(choice) else {
            throw MultipleChoiceOperationError.InvalidChoice
        }
        
        guard let state = userChoices[choice] else {
            throw MultipleChoiceOperationError.Unknown
        }
        
        return state
    }
    
    public func appliedUserChoice() -> [(choice: T, state: Bool)] {
        
        var applied: [PresetChoice] = []
        for choice in availableChoices {
            let statedChoice = (choice: choice, state: userChoices[choice] ?? false)
            applied.append( statedChoice )
        }
        
        return applied
    }
    
    // MARK: Class Utitilies
    private class func SensibleCheck<T>(on choicesCandidate: [T]) throws where T: Hashable {
        
        guard choicesCandidate.count >= 2 else {
            throw MultipleChoiceInitError.LessThanTwo
        }
        
        // try to convert the array which is ordered but might contains similiar element
        // to set which is unordered but guaranteed to have unique element
        let set = Set(choicesCandidate)
        
        guard set.count == choicesCandidate.count else {
            throw MultipleChoiceInitError.NotDistinct
        }
    }
    
}
