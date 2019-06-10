//
//  ViewController.swift
//  MultipleChoice
//
//  Created by Fitsyu  on 08/06/19.
//  Copyright © 2019 Fitsyu . All rights reserved.
//

import UIKit


public class DefaultMultipleChoicePresenter: UIViewController, MultipleChoicePresenter {

    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        dump(nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var delegate: MultipleChoicePresenterDelegate?
    
    public var backingStore: MultipleChoice<String> = MultipleChoice<String>.init()
    
    public func presentChoices() {
        
        tableView.reloadData()
    }
    
    func reflect() {
        
        if let rows = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: rows, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }
    
    func reset() {
        
        backingStore.reset()
        reflect()
    }
    
    func apply() {
        
        let userChoices = backingStore.appliedUserChoice()
        
        delegate?.didSelectChoices(userChoices)
        
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Actions
    @IBAction func cancelButtonPress(_ sender: UIButton) {
        self.cancel()
    }
    
    @IBAction func resetButtonPress(_ sender: UIButton) {
        self.reset()
    }
    
    @IBAction func applyButtonPress(_ sender: UIButton) {
        self.apply()
    }
}


extension DefaultMultipleChoicePresenter: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backingStore.availableChoices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceCell", for: indexPath)
        
        let choice = backingStore.availableChoices[indexPath.row]
        cell.textLabel?.text = choice
        
        if let state = try? backingStore.state(of: choice) {
            cell.accessoryType = state ? .checkmark : .none
        }
        cell.accessibilityIdentifier = "checkmark"
        
        return cell
    }
}


extension DefaultMultipleChoicePresenter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get the choice
        let choice = backingStore.availableChoices[indexPath.row]
        
        // get it's state
        let state = try? backingStore.state(of: choice)
        
        // toggle
        guard state != nil else { return }
        
        if state == true {
            try? backingStore.markUnselected(choice)
        } else {
            try? backingStore.markSelected(choice)
        }
        
        // reflect only this cell
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
}


// MARK: Services
extension DefaultMultipleChoicePresenter {
    
    public static func load() -> DefaultMultipleChoicePresenter {
        
        let podBndl = Bundle(for: DefaultMultipleChoicePresenter.classForCoder())
        
        let url = podBndl.url(forResource: "Chochoice", withExtension: "bundle")!
        
        let bundle = Bundle(url: url)!
        
        let _self = UIStoryboard(name: "Chochoice", bundle: bundle)
            .instantiateInitialViewController() as! DefaultMultipleChoicePresenter
        
        
        
        return _self
    }
}
