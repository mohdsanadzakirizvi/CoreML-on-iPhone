//
//  ViewController.swift
//  coreml test
//
//  Created by Sanad on 21/09/17.
//  Copyright © 2017 analytics vidhya. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var spamLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Actions
    @IBAction func predictSpam(_ sender: UIButton) {
        spamLabel.text = messageTextField.text;
    }
}

