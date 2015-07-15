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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	var regions = [String]()
    var platforms = [String]()
    var industries = [String]()
    
    var matches: [PFUser]!
    var collabs = [PFUser]()
    var currentUserDisplayed = 0
    
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
		
		loadingIndicator.stopAnimating()
		loadingIndicator.hidden = true
	}
	
	@IBAction func like(sender: AnyObject) {
		var connection = PFObject(className: "Connection")
		connection["user1"] = PFUser.currentUser()
		connection["user2"] = matches[currentUserDisplayed]
		
			//useUserAtIndex(++currentUserDisplayed)
		connection.saveInBackground()
		
		// TODO: FETCH NEW USER
	}
	
	@IBAction func dislike(sender: AnyObject) {
		// TODO: FETCH NEW USER
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
                    self.useUserAtIndex(&self.currentUserDisplayed)
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
                //self.users = objects as! [PFUser]
                for obj in objects! {
                    let connection: PFObject = obj as! PFObject
                    if connection["user1"] as? PFUser == PFUser.currentUser() {
                        self.collabs.append(connection["user2"] as! PFUser)
                    } else {
                        self.collabs.append(connection["user1"] as! PFUser)
                    }
                }
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
    
        }
        
		
		
		//if matches != nil{ println(" matches = \(matches!.count)")}else{ println("matches = 0")}
	}
    
    func useUserAtIndex(inout index:Int){
        var displayUser = matches[index]
        
        while contains(collabs, displayUser){
            displayUser = matches[++index]
        }
        
        populateLayoutWithUser(displayUser)
    }
    
    func populateLayoutWithUser(user:PFUser){
        userNameLabel.text = user["name"] as? String
        userRegionLabel.text = user["region"] as? String
        userIndustryLabel.text = user["industry"] as? String
        setPicture(user)
        setMedias(user)
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
		
		loadingIndicator.hidden = false
		loadingIndicator.startAnimating()
		
		let image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
		
		loadingIndicator.stopAnimating()
		loadingIndicator.hidden = true
		
		userImageView.image = image
		
    }
	
	
    /*@IBAction func unwindToMatchesViewController(segue: UIStoryboardSegue) {
        if let filterViewController = segue
    }*/
	

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "MatchToProfile" {
            var profileViewController = segue.destinationViewController as! ProfileViewController
			profileViewController.user = matches[currentUserDisplayed]
			
			//profileViewController.user = matches[currentUserDisplayed]

		}
    }


}
