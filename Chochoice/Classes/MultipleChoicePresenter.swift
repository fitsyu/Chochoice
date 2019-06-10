//
//  MultipleChoicePresenter.swift
//  MultipleChoice
//
//  Created by Fitsyu  on 10/06/19.
//  Copyright © 2019 Fitsyu . All rights reserved.
//

public protocol GenericMultipleChoicePresenter {
    
    associatedtype T: Hashable
    
    var backingStore: MultipleChoice<T> { get set }
    
    func presentChoices()
    
    var delegate: MultipleChoicePresenterDelegate? { get set }
}

// had to do this :(
// because run into that 'protocol can only used as generic constraint..."
public protocol MultipleChoicePresenter {
    
    var backingStore: MultipleChoice<String> { get set }
    
    func presentChoices()
    
    var delegate: MultipleChoicePresenterDelegate? { get set }
}
