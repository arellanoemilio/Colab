//
//  SignInViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 10/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//		var fbLoginButton = FBSDKLoginButton()
//		fbLoginButton.center = self.view.center
//		self.view.addSubview(fbLoginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func signIn(sender: UIButton) {
		let permissions = ["public_profile"]
		PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
			(user: PFUser?, error: NSError?) -> Void in
			if let user = user {
				if user.isNew {
					println("User signed up and logged in through Facebook!")
					self.performSegueWithIdentifier("userSetup", sender: sender)
				} else {
					println("User logged in through Facebook!")
					self.performSegueWithIdentifier("User Profile", sender: sender)
				}
			} else {
				println("Uh oh. The user cancelled the Facebook login.")
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "userSetup") {
			let userSetupVC: UIViewController = segue.destinationViewController as! UIViewController
		}
	}
}
