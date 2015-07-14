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
    var currentUserDisplayed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        query()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		var query = PFUser.query()!
		for region in regions{
			query.whereKey("region", containsString: region)
		}
        for industry in industries{
            query.whereKey("industry", containsString: industry)
        }
		if platforms.count > 0{query.whereKey("platforms", containsAllObjectsInArray: platforms)}
		
		query.whereKey("objectId" , notEqualTo: PFUser.currentUser()!.objectId!)
		query.findObjectsInBackgroundWithBlock {
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
                    self.useUserAtIndex(self.currentUserDisplayed)
				}
			} else {
				// Log details of the failure
				println("Error: \(error!) \(error!.userInfo!)")
			}
		}
		
		//if matches != nil{ println(" matches = \(matches!.count)")}else{ println("matches = 0")}
	}
    
    func useUserAtIndex(index:Int){
        var displayUser = matches[index]
        populateLayoutWithUser(displayUser)
    }
    
    func populateLayoutWithUser(user:PFUser){
        userNameLabel.text = user["name"] as? String
        userRegionLabel.text = user["region"] as? String
        userIndustryLabel.text = user["industry"] as? String
        //setPicture(user)
        setMedias(user)
    }
    
    func setMedias(user: PFUser){
        let medias = user["platforms"] as? [String]
        var i = 0
        for media in platforms{
            if medias != nil{
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
        }
    
    }
	
    /*@IBAction func unwindToMatchesViewController(segue: UIStoryboardSegue) {
        if let filterViewController = segue
    }*/
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
