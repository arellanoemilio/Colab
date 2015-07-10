//
//  ViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 09/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
	
    var user = PFUser.currentUser()
    

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
		var gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]
		view.layer.insertSublayer(gradient, atIndex: 0)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch (identifier){
                case "HomeToProfile":
                    var profileViewController = segue.destinationViewController as! ProfileViewController
                    profileViewController.user = user
                case "HomeToCollabs":
                    var collabsViewController = segue.destinationViewController as! CollabsTableViewController
                    collabsViewController.user = user
                default: break
            }
        }

    }
    

    

}

