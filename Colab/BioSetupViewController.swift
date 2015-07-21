//
//  BioSetupViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 13/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class BioSetupViewController: UIViewController {

	@IBOutlet weak var bioField: UITextView!
	@IBOutlet weak var emailField: UITextField!
	
	var user: PFUser!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		user = PFUser.currentUser()
		
		navigationItem.title = "Bio setup (4/4)"

    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		bioField.layer.cornerRadius = 10
		bioField.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
	}
	
	func makeAlert(title: String, text: String, button: String) {
		let alertController = UIAlertController(title: title, message:
			text, preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.Default,handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	@IBAction func done(sender: UIButton) {
        
        if !Reachability.isConnectedToNetwork(){
            //TODO
        }
        
		var bio = bioField.text
		var email = emailField.text
		user.email = email
		user.saveInBackgroundWithBlock {
			(success: Bool, error: NSError?) -> Void in
			if (error != nil && error?.code == 125) || count(email) < 1 {
				self.makeAlert("Dude!", text: "Enter a valid email!", button: "Ok")
				return
			} else {
				
				if count(bio) < 1 {
					self.makeAlert("Dude!", text: "Add something to your bio!", button: "Ok")
					return
				}
				if count(bio) > 500 {
					self.makeAlert("Dude!", text: "Your bio is too long!", button: "Ok")
					return
				}
				
				self.user["bio"] = bio
				//user.email = email
				self.user["complete"] = true
                self.user["platformUrl"] = ["","",""]
				self.user.saveInBackground()
				self.performSegueWithIdentifier("toHome", sender: sender)
			}
		}
	}
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		view.endEditing(true)
		super.touchesBegan(touches, withEvent: event)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toHome" {
            if let nextTabBarController  = segue.destinationViewController as? UITabBarController{
                let navCons = nextTabBarController.viewControllers as! [UINavigationController]
                
                var selectedIndex = 2
                nextTabBarController.selectedIndex = selectedIndex
                
                var collabsNavCon = navCons[1] as! CollabsNavigationController
                collabsNavCon.user = PFUser.currentUser()
                var collabsViewCon = collabsNavCon.topViewController as! CollabsTableViewController
                collabsViewCon.user = collabsNavCon.user
                
                var profileNavCon = navCons[2] as! ProfileNavigationController
                profileNavCon.user = PFUser.currentUser()
                var profileViewCon = profileNavCon.topViewController as! ProfileViewController
                profileViewCon.user = profileNavCon.user
            }
        }	}
	
}
