//
//  BrowseViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 10/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//
//test addinf sdalfns

import UIKit
import Parse

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var list: UITableView!
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var regions = [String]()
    var platforms = [String]()
    var industries = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.delegate = self
        list.dataSource = self
        
        populateWith(fileName: "Regions")
    }

    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0: populateWith(fileName: "Regions")
            case 1: populateWith(fileName: "SocialPlatforms")
            case 2: populateWith(fileName: "Industry")
            default: break
        }
    }
    
    func populateWith(fileName file: String){
        defaults = NSUserDefaults.standardUserDefaults()
        var fileContent =  NSBundle.mainBundle().pathForResource(file, ofType: "plist")
        listToDisplay = NSArray(contentsOfFile: fileContent!)! as! [String]
        list.reloadData()
    }
    
    // Mark: UITableViewDataSouce methods
    
    var listToDisplay = [String]()
    var cellIdentifier = "Centered Text Cell"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
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
    
     // Mark: UITableViewDelegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let cell = selectedCell{
            if let content = cell.textLabel?.text{
                cell.backgroundColor = UIColor.blueColor()
                switch filterSelector.selectedSegmentIndex{
                case 0: regions.append(content)
                case 1: platforms.append(content)
                case 2: industries.append(content)
                default: break
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	

}
