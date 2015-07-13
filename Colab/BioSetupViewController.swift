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
	
	var user: PFUser!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		user = PFUser.currentUser()

    }
	
	@IBAction func done(sender: UIButton) {
		var bio = bioField.text
		if count(bio) > 255 {
			let alertController = UIAlertController(title: "Dude!", message:
				"Your bio is to long!", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
			return
		}
		if count(bio) > 0 {
			user["bio"] = bio
			user.saveInBackground()
			performSegueWithIdentifier("toHome", sender: sender)
		} else {
			let alertController = UIAlertController(title: "Dude!", message:
				"Add something to your bio!", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Fine", style: UIAlertActionStyle.Default,handler: nil))
		}
	}
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		view.endEditing(true)
		super.touchesBegan(touches, withEvent: event)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toHome" {
			let homeVC: HomeViewController = segue.destinationViewController as! HomeViewController
		}
	}
	
}
