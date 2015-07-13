//
//  UserSetupViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 13/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
		
		switch self.restorationIdentifier! {
			case "RegionSetup":
				regionList.delegate = self
				regionList.dataSource = self
				populatedWith(fileName: "Regions", list: regionList)
			case "IndustrySetup":
				industryList.delegate = self
				industryList.dataSource = self
				populatedWith(fileName: "SocialPlatforms", list: industryList)
			case "PlatformSetup":
				platformList.delegate = self
				platformList.dataSource = self
				populatedWith(fileName: "Industry", list: platformList)
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
		
//		if self.restorationIdentifier! == "RegionSetup" {
//			for index in 0...listToDisplay.count-1 {
//				if index != row {
//					cell?.backgroundColor = UIColor.whiteColor()
//					selected[index] = false
//				}
//			}
//		}
		
		if selected[row] {
			cell?.backgroundColor = UIColor.whiteColor()
		} else {
			cell?.backgroundColor = UIColor.blueColor()
		}
		selected[row] = !selected[row]
		
	}
	

}
