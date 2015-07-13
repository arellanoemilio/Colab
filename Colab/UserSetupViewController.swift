//
//  UserSetupViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 13/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class UserSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var regionList: UITableView!
	@IBOutlet weak var industryList: UITableView!
	@IBOutlet weak var platformList: UITableView!
	
	var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
	
	var regions = [String]()
	var platforms = [String]()
	var industries = [String]()
	
	var listToDisplay = [String]()
	var selected: [Bool] = []
	
	var cellIdentifier = "Centered Text Cell"
	
	var user: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		user = PFUser.currentUser()
		
		switch self.restorationIdentifier! {
			case "RegionSetup":
				regionList.delegate = self
				regionList.dataSource = self
				populatedWith(fileName: "Regions", list: regionList)
			case "IndustrySetup":
				industryList.delegate = self
				industryList.dataSource = self
				populatedWith(fileName: "Industry", list: industryList)
			case "PlatformSetup":
				platformList.delegate = self
				platformList.dataSource = self
				populatedWith(fileName: "SocialPlatforms", list: platformList)
			default: break
			
		}
		
	}
	
	func populatedWith(fileName file: String, list: UITableView) {
		defaults = NSUserDefaults.standardUserDefaults()
		var fileContent =  NSBundle.mainBundle().pathForResource(file, ofType: "plist")
		listToDisplay = NSArray(contentsOfFile: fileContent!)! as! [String]
		list.reloadData()
		
		selected = [Bool](count: listToDisplay.count, repeatedValue: false)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listToDisplay.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
		
		let row = indexPath.row
		cell.textLabel?.text = listToDisplay[row]
		
		return cell
	}
	
	func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		let row = indexPath.row
		println(listToDisplay[row])
		
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		cell?.selectionStyle = UITableViewCellSelectionStyle.None
		
		if self.restorationIdentifier! == "RegionSetup" {
			for i in 0..<listToDisplay.count {
				if i != row {
					selected[i] = false
					let newIndexPath = NSIndexPath(forItem: i, inSection: 0)
					tableView.cellForRowAtIndexPath(newIndexPath)?.backgroundColor = UIColor.whiteColor()
				}
			}
		}
		
		if selected[row] {
			cell?.backgroundColor = UIColor.whiteColor()
		} else {
			cell?.backgroundColor = UIColor.blueColor()
		}
		selected[row] = !selected[row]
		
		
		for b in selected {
			println(b.description)
		}
	}
	
	@IBAction func nextPage(sender: UIButton) {
		println("continue puss")
		var cont = false
		for b in selected {
			if b { cont = true }
		}
		if cont {
			switch self.restorationIdentifier! {
			case "RegionSetup":
				setRegion()
				performSegueWithIdentifier("toIndustrySetup", sender: sender)
				break
			case "IndustrySetup":
				setIndustries()
				performSegueWithIdentifier("toPlatformSetup", sender: sender)
				break
			case "PlatformSetup":
				setPlatforms()
				performSegueWithIdentifier("toBioSetup", sender: sender)
				break
			default: break
			}
		} else {
			let alertController = UIAlertController(title: "Dude!", message:
				"You need to select at least one.", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Fine", style: UIAlertActionStyle.Default,handler: nil))
			
			self.presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	func setRegion() {
		var region = ""
		for i in 0..<listToDisplay.count {
			if selected[i] {
				region = listToDisplay[i]
				break
			}
		}
		user["region"] = region
		user.saveInBackground()
	}
	
	func setIndustries() {
		for i in 0..<listToDisplay.count {
			if selected[i] {
				industries.append(listToDisplay[i])
			}
		}
		user["industries"] = industries
		user.saveInBackground()
	}
	
	func setPlatforms() {
		for i in 0..<listToDisplay.count {
			if selected[i] {
				platforms.append(listToDisplay[i])
			}
		}
		user["platforms"] = platforms
		user.saveInBackground()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
		case "toIndustrySetup":
			let industrySetup: UserSetupViewController = segue.destinationViewController as! UserSetupViewController
		case "toPlatformSetup":
			let platformSetup: UserSetupViewController = segue.destinationViewController as! UserSetupViewController
		case "toBioSetup":
			let bioSetup: UIViewController = segue.destinationViewController as! UIViewController
		default:
			break
		}
	}

}
