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
    
    func query() {
        var query = PFUser.query()
		
        if regions.count > 0 {
			query?.whereKey("region", containsAllObjectsInArray: regions)
		}
        if platforms.count > 0 {
			query?.whereKey("platform", containsAllObjectsInArray: platforms)
		}
        if industries.count > 0 {
			query?.whereKey("industry", containsAllObjectsInArray: industries)
		}
		
		query?.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				self.matches = objects as! [PFUser]
			
				if objects?.count > 0 {
					println(" matches = \(self.matches!.count)")
				} else {
					println("matches = 0")
				}
				
				// DO VISUAL SETUP STUFF FROM HERE
			
			} else {
				println("Error: \(error!) \(error!.userInfo!)")
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
