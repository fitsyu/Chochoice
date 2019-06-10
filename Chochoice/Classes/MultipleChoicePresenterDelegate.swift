//
//  MultipleChoicePresenterDelegate.swift
//  MultipleChoice
//
//  Created by Fitsyu  on 10/06/19.
//  Copyright © 2019 Fitsyu . All rights reserved.
//

public protocol GenericMultipleChoicePresenterDelegate {
    
    associatedtype T: Hashable
    
    func didSelectChoices(_ choices: [(T,Bool)] )
}

public protocol MultipleChoicePresenterDelegate {
    
    func didSelectChoices(_ choices: [(String,Bool)] )
}
