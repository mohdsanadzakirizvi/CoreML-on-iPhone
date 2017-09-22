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
    
    //MARK: Functionality code
    func tfidf(sms: String) -> MLMultiArray{
        //set path for files
        let wordsFile = "/Users/sanad/development/coreml test/coreml test/wordlist.txt"
        let smsFile = "/Users/sanad/development/coreml test/coreml test/SMSSpamCollection.txt"
        do {
            //read words file
            let wordsFileText = try String(contentsOfFile: wordsFile, encoding: String.Encoding.utf8)
            var wordsData = wordsFileText.components(separatedBy: .newlines)
            wordsData.removeLast() // Trailing newline.
            //read spam collection file
            let smsFileText = try String(contentsOfFile: smsFile, encoding: String.Encoding.utf8)
            var smsData = smsFileText.components(separatedBy: .newlines)
            smsData.removeLast() // Trailing newline.
            let wordsInMessage = sms.split(separator: " ")
            //create a multi-dimensional array
            let vectorized = try MLMultiArray(shape: [NSNumber(integerLiteral: wordsData.count)], dataType: MLMultiArrayDataType.double)
            for i in 0..<wordsData.count{
                let word = wordsData[i]
                if sms.contains(word){
                    var wordCount = 0
                    for substr in wordsInMessage{
                        if substr.elementsEqual(word){
                            wordCount += 1
                        }
                    }
                    let tf = Double(wordCount) / Double(wordsInMessage.count)
                    var docCount = 0
                    for sms in smsData{
                        if sms.contains(word) {
                            docCount += 1
                        }
                    }
                    let idf = log(Double(smsData.count) / Double(docCount))
                    vectorized[i] = NSNumber(value: tf * idf)
                } else {
                    vectorized[i] = 0.0
                }
            }
            return vectorized
        } catch {
            return MLMultiArray()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Actions
    @IBAction func predictSpam(_ sender: UIButton) {
        let enteredMessage =  messageTextField.text!
        if (enteredMessage != ""){
            spamLabel.text = ""
        }
        let vec = tfidf(sms: enteredMessage)
        do {
            let prediction = try SpamMessageClassifier().prediction(message: vec).spam_or_not
            print (prediction)
            if (prediction == "spam"){
                spamLabel.text = "SPAM!"
            }
            else if(prediction == "ham"){
                spamLabel.text = "NOT SPAM"
            }
        }
        catch{
            spamLabel.text = "No Prediction"
        }
    }
}

