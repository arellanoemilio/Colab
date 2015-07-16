//
//  EmailViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 16/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var subjectField: UITextField!
	@IBOutlet weak var bodyField: UITextView!
	
	var name: String!
	var email: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = name
		
		subjectField.delegate = self
		bodyField.delegate = self
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		bodyField.layer.cornerRadius = 10
		bodyField.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
	}
    
	@IBAction func send(sender: AnyObject) {
		var subject = subjectField.text
		var body = bodyField.text
		
		if count(body) < 1 {
			makeAlert("Body", text: "Type a message to send", button: "Ok")
			return
		}
		if count(subject) < 1 {
			makeAlert("Subject", text: "Please enter a subject", button: "Ok")
			return
		}
		
		var picker = MFMailComposeViewController()
		picker.mailComposeDelegate = self
		picker.setSubject(subject)
		picker.setToRecipients([email])
		picker.setMessageBody(body, isHTML: true)
		
		presentViewController(picker, animated: true, completion: nil)
	}
	
	// MFMailComposeViewControllerDelegate
	func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// UITextFieldDelegat
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
	
	// UITextViewDelegate
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		bodyField.text = textView.text
		
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		
		return true
	}
	
	func makeAlert(title: String, text: String, button: String) {
		let alertController = UIAlertController(title: title, message:
			text, preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.Default,handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}

}
