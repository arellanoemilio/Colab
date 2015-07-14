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

    var regions = [String]()
    var platforms = [String]()
    var industries = [String]()
    
    var matches: [PFUser]!
    
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
		if platforms.count > 0{query.whereKey("industries", containsAllObjectsInArray: platforms)}
		if industries.count > 0{query.whereKey("industries", containsAllObjectsInArray: industries)}
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
					
				}
			} else {
				// Log details of the failure
				println("Error: \(error!) \(error!.userInfo!)")
			}
		}
		
		//if matches != nil{ println(" matches = \(matches!.count)")}else{ println("matches = 0")}
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
