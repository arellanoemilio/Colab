//
//  MatchesViewController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/13/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRegionLabel: UILabel!
    @IBOutlet weak var userIndustryLabel: UILabel!
    @IBOutlet weak var userMedia1Label: UILabel!
    @IBOutlet weak var userMedia2Label: UILabel!
    @IBOutlet weak var userMedia3Label: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
	
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
        query()
		
		userImageView.layer.cornerRadius = 20
		userImageView.layer.masksToBounds = true
		
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	@IBAction func like(sender: AnyObject) {
		var connection = PFObject(className: "Connection")
		connection["user1"] = PFUser.currentUser()
		connection["user2"] = matches[currentUserDisplayed]
        connection.saveInBackground()
        
        getNextMatch()
		
		// TODO: FETCH NEW USER
	}
	
    @IBAction func showProfile(sender: AnyObject) {
         println("a")
        if displayeduser != nil {
            println("b")
            performSegueWithIdentifier("MatchToProfile", sender: sender)
            println("c")
        }
    }
    
	@IBAction func dislike(sender: AnyObject) {
        getNextMatch()
	}
	
    @IBAction func unwindToMatchVC(segue: UIStoryboardSegue){
    if let source = segue.sourceViewController as? FilterViewController{
        println("populating arrays")
        regions = source.regions
        industries = source.industries
        platforms = source.platforms
    }
        println("\(regions) \n \(industries) \n \(platforms)")
        query()
    }
    
	func query(){
		var query1 = PFUser.query()!
		for region in regions{
			query1.whereKey("region", containsString: region)
		}
        for industry in industries{
            query1.whereKey("industry", containsString: industry)
        }
		if platforms.count > 0{query1.whereKey("platforms", containsAllObjectsInArray: platforms)}
		
		query1.whereKey("objectId" , notEqualTo: PFUser.currentUser()!.objectId!)
        
        query1.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			
			if error == nil {
				// The find succeeded.
				println("Successfully retrieved \(objects!.count) matches.")
				// Do something with the found objects
				if let objects = objects as? [PFUser] {
					self.matches = objects
					for match in self.matches{
						var name = match["name"] as! String
						println("\(name)")
					}
				}
			} else {
				// Log details of the failure
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
                    println("c")
                    if connection["user1"] as? PFUser == PFUser.currentUser() {
                         println("d")
                        self.collabs.append(connection["user2"] as! PFUser)
                    } else {
                         println("e")
                        if let collab = connection["user1"] as? PFUser{
                             println("f")
                            self.collabs.append(collab)
                        }
                        println("g")
                    }
                }
                self.useUserAtIndex(&self.currentUserDisplayed)
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
		//if matches != nil{ println(" matches = \(matches!.count)")}else{ println("matches = 0")}
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
        
    }
    
    func populateLayoutWithUser(opUser:PFUser?){
        println("9")
        if let user = opUser{
            println("10")
            userNameLabel.text = user["name"] as? String
            userRegionLabel.text = user["region"] as? String
            userIndustryLabel.text = user["industry"] as? String
            setPicture(user)
            setMedias(user)
        }else{
            println("11")
            userNameLabel.text = "No More Users"
            userRegionLabel.text = "The World"
            userIndustryLabel.text = "I Do Everything"
            userImageView.image = UIImage(named: "placeholder")
            userMedia1Label.text = ""
            userMedia2Label.text = ""
            userMedia3Label.text = ""
        }
        println("12")
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
	
	
    /*@IBAction func unwindToMatchesViewController(segue: UIStoryboardSegue) {
        if let filterViewController = segue
    }*/
	

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "MatchToProfile" {
            println("1")
            if let profileViewController = segue.destinationViewController as? ProfileViewController{
                println("2")
                profileViewController.user = displayeduser
            }
			
			//profileViewController.user = matches[currentUserDisplayed]

		}
    }


}
