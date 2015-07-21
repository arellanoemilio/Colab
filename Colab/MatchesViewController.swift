//
//  MatchesViewController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/13/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class MatchesViewController: UIViewController,  MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRegionLabel: UILabel!
    @IBOutlet weak var userIndustryLabel: UILabel!
    @IBOutlet weak var userMedia1Label: UIButton!
    @IBOutlet weak var userMedia2Label: UIButton!
    @IBOutlet weak var userMedia3Label: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
	
	var regions = [String]()
    var platforms = [String]()
    var industries = [String]()
    
    var matches: [PFUser]!
	
	var i = 0
	
    var collabs = [PFUser]()
    var currentUserDisplayed = 0
    var displayeduser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        query()

        // Do any additional setup after loading the view.
		userImageView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        println(" hight  = \(clearButton.bounds.size.height / 2)")
        
        clearButton.layer.cornerRadius = clearButton.bounds.size.height / 2
        messageButton.layer.cornerRadius = messageButton.bounds.size.height / 2
        userImageView.layer.cornerRadius = userImageView.bounds.size.height / 2
    }
	
	@IBAction func like(sender: AnyObject) {
        
        if !Reachability.isConnectedToNetwork(){
            //TODO
        }
        
        var picker = MFMailComposeViewController()
		picker.mailComposeDelegate = self
		picker.setSubject("Let's collaborate")
		picker.setToRecipients([matches[currentUserDisplayed].email!])
		
		presentViewController(picker, animated: true, completion: {self.getNextMatch()})

        if displayeduser != nil{
        var connection = PFObject(className: "Connection")
            connection["user1"] = PFUser.currentUser()
            connection["user2"] = displayeduser
            connection["connected"] = true
            connection.saveInBackground()
        }
	}
	
    @IBAction func showProfile(sender: AnyObject) {
        if displayeduser != nil {
            performSegueWithIdentifier("MatchToProfile", sender: sender)
        }
    }
	
	func goToProfile() {
		if displayeduser != nil {
			performSegueWithIdentifier("MatchToProfile", sender: self)
		}
	}
	
	@IBAction func dislike(sender: AnyObject) {
        getNextMatch()
	}
	
    @IBAction func unwindToMatchVC(segue: UIStoryboardSegue){
    if let source = segue.sourceViewController as? FilterViewController{
        regions = source.regions
        industries = source.industries
        platforms = source.platforms
    }
        query()
    }
    
	func query(){
        
        if !Reachability.isConnectedToNetwork(){
            //TODO
        }
        
        currentUserDisplayed = 0
        var queries = [PFQuery]()
        var query1 = PFUser.query()!
        if regions.count > 0{query1.whereKey("region", containedIn: regions)}
        if industries.count > 0{query1.whereKey("industry", containedIn: industries)}
        if platforms.count > 0 {query1.whereKey("platforms", containedIn: platforms)}
        query1.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
        query1.whereKey("complete", equalTo: true)
        
        query1.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // Do something with the found objects
                if let objects = objects as? [PFUser] {
                    self.matches = objects
					self.i = objects.count
                    for match in self.matches{
                        var name = match["name"] as! String
                    }
                }
            } else {
            println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        var query3 = PFQuery(className: "Connection")
        query3.whereKey("user1", equalTo: PFUser.currentUser()!)
        
        var query2 = PFQuery(className: "Connection")
        query2.whereKey("user2", equalTo: PFUser.currentUser()!)
        
        var subQueries = [query3, query2]
        
        var mainQuery = PFQuery.orQueryWithSubqueries(subQueries)
        mainQuery.includeKey("user1")
        mainQuery.includeKey("user2")
        
        
    
        mainQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                for obj in objects! {
                    let connection: PFObject = obj as! PFObject
                    if connection["user1"] as? PFUser == PFUser.currentUser() {
                        if let collab = connection["user2"] as? PFUser{
                            self.collabs.append(collab)
                        }
                    } else {
                        if let collab = connection["user1"] as? PFUser{
                            self.collabs.append(collab)
                        }
                    }
                }
                self.useUserAtIndex(&self.currentUserDisplayed)
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
	}
	
    func getNextMatch(){
		if matches.count > 0 {
			let random = arc4random_uniform(UInt32(matches.count-1))
			currentUserDisplayed = Int(random)
            useUserAtIndex(&currentUserDisplayed)
//			populateLayoutWithUser(matches[currentUserDisplayed])
		} else {
			displayeduser = nil
			populateLayoutWithUser(displayeduser)
			checkUserForNil()
		}
    }
    
    func useUserAtIndex(inout index:Int){
        var displayUser: PFUser? = nil
        if matches.count > index {
            displayUser = matches[index]
            if displayUser != nil{
                while displayUser != nil && contains(collabs, displayUser!){
                    if index < matches.count - 1{
                        displayUser = matches[++index]
                    }else{
                        displayUser = nil
                    }
                }
            }
        }
        displayeduser = displayUser
        populateLayoutWithUser(displayeduser)
        checkUserForNil()
    }
    
    func populateLayoutWithUser(opUser:PFUser?){
        if let user = opUser{
            userNameLabel.text = user["name"] as? String
            userRegionLabel.text = user["region"] as? String
            userIndustryLabel.text = user["industry"] as? String
            setPicture(user)
            setMedias(user)
        }else{
            userNameLabel.text = "No More Matches"
            userRegionLabel.text = ""
            userIndustryLabel.text = ""
            userImageView.image = UIImage(named: "placeholder")
        }
		if matches.count > 0 {
			matches.removeAtIndex(currentUserDisplayed)
		}
    }
    
    func setMedias(user:PFUser){
        clearMedias()
        let media = (user["platforms"] as? [String])!
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
    
    func clearMedias(){
        userMedia1Label.setBackgroundImage(nil , forState: UIControlState.Normal)
        userMedia2Label.setBackgroundImage(nil , forState: UIControlState.Normal)
        userMedia3Label.setBackgroundImage(nil , forState: UIControlState.Normal)
    }
	
    func setPicture(user: PFUser){
        let urlString = user["pictureURL"] as! String
		
		let image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
		
		userImageView.image = image
		
    }
	
	// MFMailComposeViewControllerDelegate
	func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
    func checkUserForNil(){
        if displayeduser == nil{
            clearButton.hidden = true
            messageButton.hidden = true
            userMedia1Label.hidden = true
            userMedia2Label.hidden = true
            userMedia3Label.hidden = true
            infoButton.hidden = true
        }else{
            clearButton.hidden = false
            messageButton.hidden = false
            userMedia1Label.hidden = false
            userMedia2Label.hidden = false
            userMedia3Label.hidden = false
            infoButton.hidden = false
        }
    }
	
	func getURLAndIndexFromSender(sender: AnyObject?) -> (url:String,index:Int){
		var mediaURL = matches[currentUserDisplayed]["platformUrl"] as! [String]
		if let button = sender as? UIButton {
			switch button {
			case userMedia1Label:
				return (mediaURL.first!, 0)
			case userMedia2Label:
				return (mediaURL[1], 1)
			case userMedia3Label:
				return (mediaURL[2],2)
			default: break
			}
		}
		return ("",-1)
	}
	
	@IBAction func tosSocialWeb(sender: AnyObject) {
		performSegueWithIdentifier("tinderToWeb", sender: sender)
	}
	
    /*@IBAction func unwindToMatchesViewController(segue: UIStoryboardSegue) {
        if let filterViewController = segue
    }*/
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "MatchToProfile" {
            if let profileViewController = segue.destinationViewController as? ProfileViewController{
                profileViewController.user = displayeduser
            }
			
			//profileViewController.user = matches[currentUserDisplayed]

		}
		if segue.identifier == "tinderToWeb" {
			var destinationController = segue.destinationViewController as! SocialWebviewViewController
			destinationController.user = matches[currentUserDisplayed]
			let senderData = getURLAndIndexFromSender(sender)
			destinationController.urlString = senderData.url
			destinationController.index = senderData.index
		}
    }


}
