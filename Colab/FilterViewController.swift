//
//  BrowseViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 10/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//


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
    
    
    /*@IBAction func search(sender: UIButton) {
        println("start search")
        performSegueWithIdentifier("search", sender: sender)
         println("end search")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         println("start prepareForSegue")
        if let identifier = segue.identifier{
            switch identifier{
            case "search":
                if let destination = segue.destinationViewController as? MatchesViewController{
                    destination.regions = regions
                    destination.platforms = platforms
                    destination.industries = industries
                }
            default: break
            }
        }
        println("end prepareForSegue")
    }*/

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
        
        updateSelectedCells(cell, value: listToDisplay[row])
        
        if cell.selected{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func updateSelectedCells(cell: UITableViewCell, value: String){
        switch filterSelector.selectedSegmentIndex{
        case 0:cell.selected = contains(regions, value)
        case 1:cell.selected = contains(platforms, value)
        case 2:cell.selected = contains(industries, value)
        default: break
        }
    }
    
     // Mark: UITableViewDelegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let cell = selectedCell{
            cell.selected = false
            if let content = cell.textLabel?.text{
                switch filterSelector.selectedSegmentIndex{
                case 0:
                    if contains(regions, content){
                        var counter = 0
                        for region in regions{
                            if region == content{
                                regions.removeAtIndex(counter)
                                cell.selected = false
                                cell.accessoryType = UITableViewCellAccessoryType.None
                                break
                            }else{
                                counter++
                            }
                        }
                    }else{
                        regions.append(content)
                        cell.selected = true
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                    
                case 1:
                    if contains(platforms, content){
                        var counter = 0
                        for platform in platforms{
                            if platform == content{
                                platforms.removeAtIndex(counter)
                                cell.selected = false
                                cell.accessoryType = UITableViewCellAccessoryType.None
                                break
                            }else{
                                counter++
                            }
                        }
                    }else{
                        platforms.append(content)
                        cell.selected = true
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                case 2:
                    if contains(industries, content){
                        var counter = 0
                        for industry in industries{
                            if industry == content{
                                industries.removeAtIndex(counter)
                                cell.selected = false
                                cell.accessoryType = UITableViewCellAccessoryType.None
                                break
                            }else{
                                counter++
                            }
                        }
                    }else{
                        industries.append(content)
                        cell.selected = true
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
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
