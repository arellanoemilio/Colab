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
    @IBOutlet weak var userMedia1Label: UILabel!
    @IBOutlet weak var userMedia2Label: UILabel!
    @IBOutlet weak var userMedia3Label: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var messageButton: UIButton!
	
	var regions = [String]()
    var platforms = [String]()
    var industries = [String]()
    
    var matches: [PFUser]!
    var collabs = [PFUser]()
    var currentUserDisplayed = 0
    var displayeduser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
		userImageView.layer.cornerRadius = 20
		userImageView.layer.masksToBounds = true
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		clearButton.layer.cornerRadius = 30
		messageButton.layer.cornerRadius = 30
		
        query()

	}
	
	@IBAction func like(sender: AnyObject) {
        if displayeduser != nil{
        var connection = PFObject(className: "Connection")
            connection["user1"] = PFUser.currentUser()
            connection["user2"] = displayeduser
            connection.saveInBackground()
        }
		
		var picker = MFMailComposeViewController()
		picker.mailComposeDelegate = self
		picker.setSubject("Let's collaborate")
		picker.setToRecipients([matches[currentUserDisplayed].email!])
		
		presentViewController(picker, animated: true, completion: nil)
		
		//goToProfile()
		
        getNextMatch()
		
		// TODO: FETCH NEW USER
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
        currentUserDisplayed = 0
        var queries = [PFQuery]()
        var query1 = PFUser.query()!
        if regions.count > 0{query1.whereKey("region", containedIn: regions)}
        if industries.count > 0{query1.whereKey("industry", containedIn: industries)}
        if platforms.count > 0 {query1.whereKey("platforms", containedIn: platforms)}
        query1.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
        
        query1.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // Do something with the found objects
                if let objects = objects as? [PFUser] {
                    self.matches = objects
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
        ++currentUserDisplayed
        useUserAtIndex(&currentUserDisplayed)
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
            userNameLabel.text = "No More Users"
            userRegionLabel.text = "The World"
            userIndustryLabel.text = "I Do Everything"
            userImageView.image = UIImage(named: "placeholder")
            userMedia1Label.text = ""
            userMedia2Label.text = ""
            userMedia3Label.text = ""
        }
    }
    
    func setMedias(user: PFUser){
        let medias = user["platforms"] as? [String]
        var i = 0
        if medias != nil{
            for media in platforms{
                    if contains(medias!, media){
                    switch i{
                    case 0: userMedia1Label.text = media
                    case 1: userMedia2Label.text = media
                    case 2: userMedia3Label.text = media
                    default: break
                    }
                    i++
                }
            }
            while i < 2{
                for j in 0..<medias!.count {
                    if !contains(platforms, medias![j]){
                        switch i{
                        case 0: userMedia1Label.text = medias![j]
                        case 1: userMedia2Label.text = medias![j]
                        case 2: userMedia3Label.text = medias![j]
                        default: break
                        }
                        i++
                    }else{i++}
                }
            }
        }
    
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
        }else{
            clearButton.hidden = false
            messageButton.hidden = false
        }
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
    }


}
