//
//  ViewController.swift
//  ReSwiftSample
//
//  Created by Hank.Lee on 28/06/2019.
//  Copyright © 2019 hyeongkyu. All rights reserved.
//

import UIKit
import ReSwift

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var increasingButton: UIButton!
    @IBOutlet weak var decreasingButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var newValueTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppState.store.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppState.store.unsubscribe(self)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        switch sender as! UIButton {
        case increasingButton:
            AppState.store.dispatch(AppState.CounterActionIncrease())
        case decreasingButton:
            AppState.store.dispatch(AppState.CounterActionDecrease())
        case settingButton:
            guard let text = newValueTextField.text, let newCount = Int(text) else { return }
            AppState.store.dispatch(AppState.CounterActionSet(newCount: newCount))
        default:
            break
        }
    }
}

extension ViewController: StoreSubscriber {
    func newState(state: AppState) {
        textField.text = "\(state.count)"
    }
}
