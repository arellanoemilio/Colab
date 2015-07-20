//
//  SocialWebviewViewController.swift
//  co.op
//
//  Created by Mikk Kärner on 20/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class SocialWebviewViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

	@IBOutlet weak var webview: UIWebView!
	@IBOutlet weak var urlField: UITextField!
	@IBOutlet weak var addButton: UIButton!
	
	var user: PFUser!
	var urlString: String!
	var index: Int!
	
	var userMediaUrl: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		urlField.delegate = self
		
		if urlString == nil {
			urlString = "http://www.google.com"
		}
		
		if PFUser.currentUser() != user {
			addButton.setTitle("Done", forState: UIControlState.Normal)
		} else {
			addButton.setTitle("Add this link", forState: UIControlState.Normal)
		}
		
		var request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		webview.loadRequest(request)
		urlField.text = request.URL?.absoluteString
		
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		println(webview.request?.URL?.absoluteString)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlField.text)!)
		webview.loadRequest(request)
		return true
	}
    
	@IBAction func add(sender: AnyObject) {
		var url = webview.request?.URL?.absoluteString
		
		var array: [String] = (user["platformUrl"] as! [String])
		println("count \(array.count)")
		println("index \(index)")
		if index < array.count && index > -1{
			array[index] = url!
		}
	
		user["platformUrl"] = array
		user.saveInBackground()
		
		
		
	}

	

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        urlString = urlField.text
    }

}
