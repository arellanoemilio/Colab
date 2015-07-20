//
//  ProfileViewController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/10/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var user: PFUser!
	var email: String!
	var media: [String]!
	var industry: String!
	var region: String!
	var name: String!
	var bioDescription = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var industry1Label: UILabel!
    @IBOutlet weak var bioDescriptionLabel: UITextView!
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var contactButton: UIBarButtonItem!
    
    @IBOutlet weak var userMedia1Label: UIButton!
    @IBOutlet weak var userMedia2Label: UIButton!
    @IBOutlet weak var userMedia3Label: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		var  boarderColor = UIColor.grayColor()
		bioDescriptionLabel.layer.borderColor = boarderColor.CGColor
		bioDescriptionLabel.layer.borderWidth = 1.0
		bioDescriptionLabel.layer.cornerRadius = 5
		bioDescriptionLabel.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
		
		
        if user != nil {
			name = user["name"] as! String
			email = user.email
            industry = user["industry"] as! String
			region = user["region"] as! String
            media = user["platforms"] as! [String]
            let bioDescription: String = user["bio"] as! String
            
			nameLabel.text = name
			emailLabel.text = email
			regionLabel.text = region
            bioDescriptionLabel.text = bioDescription
			industry1Label.text = industry
            populateMedia()
			
			if (user == PFUser.currentUser()) {
				contactButton.enabled = false
				contactButton.tintColor = UIColor.clearColor()
			} else {
				contactButton.enabled = true
				contactButton.tintColor = self.view.tintColor
			}
        }
		
		//subject.delegate = self
		//body.delegate = self
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		profilePicture.layer.cornerRadius = 110
		profilePicture.layer.masksToBounds = true
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		getProfilePic()
	}
	
	
    func populateMedia(){
        var counter = 0
        if media.count >= 3{
            while counter < 3 && counter < media.count{
                switch counter{
                case 0: userMedia1Label.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                case 1:userMedia2Label.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                case 2: userMedia3Label.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                default: break
                }
            
            }
        }else if media.count == 2{
            while counter < 2 && counter < media.count{
                switch counter{
                case 0: userMedia1Label.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                case 1:userMedia3Label.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                default: break
                }
            }
        }else if media.count == 1{
            while counter < 1 && counter < media.count{
                switch counter{
                case 0: userMedia2Label.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                default: break
                }
            }
        }

    }
	
	func getProfilePic() {
		let urlString = user["pictureURL"] as! String
		
		let image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
				
		profilePicture.image = image
		
	}
	
	@IBAction func sendEmail(sender: AnyObject) {
		var picker = MFMailComposeViewController()
		picker.mailComposeDelegate = self
		picker.setSubject("Let's collaborate")
		picker.setToRecipients([email])
		
		presentViewController(picker, animated: true, completion: nil)
	}
	
	// MFMailComposeViewControllerDelegate
	func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func unwindToProfile(segue: UIStoryboardSegue) {}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
