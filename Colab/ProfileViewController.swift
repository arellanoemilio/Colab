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
	var mediaURL: [String]!
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
    @IBOutlet weak var indicationsLabel: UILabel!
    
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var userMedia1Button: UIButton!
    @IBOutlet weak var userMedia2Button: UIButton!
    @IBOutlet weak var userMedia3Button: UIButton!
		
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Reachability.isConnectedToNetwork(){
            Alert.getAlertController("Whoops!", text: "Please connect to the internet before continuing", button: "Ok")
			return
        }
		        
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
            mediaURL = user["platformUrl"] as! [String]
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
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        if user != PFUser.currentUser(){
            indicationsLabel.bounds.size.height = 0
            indicationsLabel.setNeedsDisplay()
            indicationsLabel.hidden = true
        }
		profilePicture.layer.masksToBounds = true
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.size.height / 2
		getProfilePic()
	}
	
    func populateMedia(){
        var counter = 0
        if media.count >= 3{
            while counter < 3 && counter < media.count{
                switch counter{
                case 0: userMedia1Button.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                case 1:userMedia2Button.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                case 2: userMedia3Button.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                default: break
                }
            
            }
        }else if media.count == 2{
            while counter < 2 && counter < media.count{
                switch counter{
                case 0: userMedia1Button.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                case 1:userMedia3Button.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
                default: break
                }
            }
        }else if media.count == 1{
            while counter < 1 && counter < media.count{
                switch counter{
                case 0: userMedia2Button.setBackgroundImage(UIImage(named: media[counter++]), forState: UIControlState.Normal)
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
	@IBAction func toSocialWeb(sender: AnyObject) {
		performSegueWithIdentifier("profileToWeb", sender: sender)
	}
    
    func getURLAndIndexFromSender(sender: AnyObject?) -> (url:String,index:Int){
        if let button = sender as? UIButton {
            switch button {
            case userMedia1Button:
                return (mediaURL.first!, 0)
            case userMedia2Button:
                return (mediaURL[1], 1)
            case userMedia3Button:
                return (mediaURL[2],2)
            case tempButton:
                return ("http://www.facebook.com", -1)
            default: break
            }
        }
        return ("",-1)
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
	
	@IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        if let previousViewController = segue.sourceViewController as? SocialWebviewViewController{
            if previousViewController.user == PFUser.currentUser() && previousViewController.index >= 0 && previousViewController.index <= 2{
                mediaURL[previousViewController.index] = previousViewController.urlString
                user["platformUrl"] = mediaURL
                user.saveInBackground()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "profileToWeb" {
			var destinationController = segue.destinationViewController as! SocialWebviewViewController
			destinationController.user = user
            let senderData = getURLAndIndexFromSender(sender)
            destinationController.urlString = senderData.url
            destinationController.index = senderData.index
		}
    }

}
