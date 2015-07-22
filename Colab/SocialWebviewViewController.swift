//
//  SocialWebviewViewController.swift
//  co.op
//
//  Created by Mikk Kärner on 20/07/15.
//  Copyright (c) 2015 Mikk Kärner and Emilio Arellano. All rights reserved.
//

import UIKit
import Parse

class SocialWebviewViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

	@IBOutlet weak var webview: UIWebView!
	@IBOutlet weak var urlField: UITextField!
	@IBOutlet weak var addButton: UIButton!
    
    var isMatches: Bool = false
	var user: PFUser!
	var urlString: String!
	var index: Int!
	
	var userMediaUrl: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		urlField.delegate = self
		
		if urlString == nil || urlString == "" {
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
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlField.text)!)
		webview.loadRequest(request)
		return true
	}
    
	@IBAction func add(sender: AnyObject) {
        if user == PFUser.currentUser(){
            var url = webview.request?.URL?.absoluteString
            var array: [String] = (user["platformUrl"] as! [String])
            if index < array.count && index > -1{
                array[index] = url!
            }
            
            user["platformUrl"] = array
            user.saveInBackground()
        }
        if isMatches{
            performSegueWithIdentifier("backToMatches", sender: sender)
        }else{
            performSegueWithIdentifier("backToProfile", sender: sender)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        urlField.text = webview.request?.URL?.absoluteString
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        urlString = urlField.text
    }

}
