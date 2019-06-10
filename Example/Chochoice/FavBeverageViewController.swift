//
//  FavBeveragesViewController.swift
//  MultipleChoice
//
//  Created by Fitsyu  on 10/06/19.
//  Copyright © 2019 Fitsyu . All rights reserved.
//

import UIKit
import Chochoice

// this is the example driving code

final class FavBeverageViewController: UIViewController {
    
    @IBOutlet weak var beveragesLabel: UILabel!
    @IBAction func pressEditButton(_ sender: UIButton) { openBeveragesEditor() }
    
    var beverages: [String] = [] {
        didSet {
            if beverages.isEmpty {
                beveragesLabel.text = "None"
            } else {
                let text = beverages.joined(separator: ", ")
                beveragesLabel.text = text
            }
        }
    }
    
    var choices: [(String,Bool)] = [
        ("Capucino", false),
        ("Latte", false),
        ("Espresso", false)
    ]
    
    func openBeveragesEditor() {
        
        // create list of choices
        let multipleChoice = try! MultipleChoice<String>(prefilledChoices: choices)
        
        
        // create its presenter
        let avc: DefaultMultipleChoicePresenter =  DefaultMultipleChoicePresenter.load()
        
        var presenter: MultipleChoicePresenter = avc
        
        // bind the two
        presenter.backingStore = multipleChoice
        
        // set presenters' delegate
        presenter.delegate = self
        
        // present the presenter
        self.present(avc, animated: true, completion: {
            presenter.presentChoices()
        })
    }
}


extension FavBeverageViewController: MultipleChoicePresenterDelegate {
    
    func didSelectChoices(_ choices: [(String, Bool)]) {
        self.choices = choices
        self.beverages.removeAll()
        for choice in choices {
            if choice.1 == true {
                beverages.append(choice.0)
            }
        }
    }
}

