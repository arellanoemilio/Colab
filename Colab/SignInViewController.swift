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

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoImage.image = UIImage(named: "Co.Op Logo")
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        facebookButton.layer.cornerRadius = 7
        facebookButton.layer.masksToBounds = true
		
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func signIn(sender: UIButton) {
        
        if !Reachability.isConnectedToNetwork(){
			Alert.getAlertController("Whoops!", text: "Please connect to the internet before continuing", button: "Ok")
			return
        }
        
		let permissions = ["public_profile"]
		PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
			(user: PFUser?, error: NSError?) -> Void in
			if let user = user {
				if user.isNew {
					user["complete"] = false
					user.saveInBackground()
					self.getDataFromFB()
					self.performSegueWithIdentifier("userSetup", sender: sender)
				} else {
					if user["bio"] != nil {
						self.performSegueWithIdentifier("User Profile", sender: sender)
					} else {
						self.performSegueWithIdentifier("userSetup", sender: sender)
					}
				}
			}
			if error != nil {
				println("Error: \(error)")
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "userSetup") {
			let userSetupVC: UIViewController = segue.destinationViewController as! UIViewController
		}
        if (segue.identifier == "User Profile"){
            if let nextTabBarController  = segue.destinationViewController as? UITabBarController{
                let navCons = nextTabBarController.viewControllers as! [UINavigationController]
                
                var selectedIndex = 0
                nextTabBarController.selectedIndex = selectedIndex
                
                if let collabsNavCon = navCons[1] as? CollabsNavigationController{
                    collabsNavCon.user = PFUser.currentUser()
                    if let collabsViewCon = collabsNavCon.topViewController as? CollabsTableViewController{
                        collabsViewCon.user = collabsNavCon.user
                    }
                }
                
                if let profileNavCon = navCons[2] as? ProfileNavigationController{
                    profileNavCon.user = PFUser.currentUser()
                    if let profileViewCon = profileNavCon.topViewController as? ProfileViewController{
                        profileViewCon.user = PFUser.currentUser()//profileNavCon.user
                        profileNavCon.user?.objectId
                    }
                }
            }
        }
	}
	
	func getDataFromFB() {
        
        if !Reachability.isConnectedToNetwork(){
			Alert.getAlertController("Whoops!", text: "Please connect to the internet before continuing", button: "Ok")
			return
        }

		if FBSDKAccessToken.currentAccessToken() != nil {
			var user = PFUser.currentUser()
			var name = ""
			var picURL = ""
			
			FBSDKGraphRequest(graphPath: "me?fields=name", parameters: nil)
			.startWithCompletionHandler {
				(connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
				if (error == nil) {
					name = result["name"] as! String
					user!["name"] = name
					user?.saveInBackground()
				}
			}
			FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
				.startWithCompletionHandler {
					(connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
					if (error == nil) {
						picURL = (result["data"] as! NSDictionary)["url"] as! String
						user!["pictureURL"] = picURL
						user?.saveInBackground()
                    }
            }
		}
	}
}
