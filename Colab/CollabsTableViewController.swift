//
//  TableViewController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/10/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class CollabsTableViewController: UITableViewController {

    var user: PFUser?
	var users = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // we want it here so that the connections refresh every time a user cliks on the 
        // collabs tab
        getCollabs()
    }
	
	func getCollabs() {
        users.removeAll(keepCapacity: false)
		var query1 = PFQuery(className: "Connection")
		query1.whereKey("user1", equalTo: PFUser.currentUser()!)
		
		var query2 = PFQuery(className: "Connection")
		query2.whereKey("user2", equalTo: PFUser.currentUser()!)
		
		var subQueries = [query1, query2]
		
		var mainQuery = PFQuery.orQueryWithSubqueries(subQueries)
		mainQuery.whereKey("connected", equalTo: true)
        mainQuery.includeKey("user1")
		mainQuery.includeKey("user2")
		
		mainQuery.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				//self.users = objects as! [PFUser]
				for obj in objects! {
					let connection: PFObject = obj as! PFObject
					if connection["user1"] as? PFUser == PFUser.currentUser() {
						self.users.append(connection["user2"] as! PFUser)
					} else {
						self.users.append(connection["user1"] as! PFUser)
					}
				}
				self.tableView.reloadData()
			} else {
				println("Error: \(error!) \(error!.userInfo!)")
			}
		}
		
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collabsListCell", forIndexPath: indexPath) as! CollabsTableViewCell

        // Configure the cell...
		cell.user = users[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < users.count{
            performSegueWithIdentifier("CollabsToProfile", sender: users[indexPath.row])
        }
    }
	
    func queryForConnectionWithUser(user: PFUser) -> [PFObject]{
        var conncetions = [PFObject]()
        var query1 = PFQuery(className: "Connection")
        query1.whereKey("user1", equalTo: user)
        
        var query2 = PFQuery(className: "Connection")
        query2.whereKey("user2", equalTo: user)
        
        var subQueries = [query1, query2]
        
        var mainQuery = PFQuery.orQueryWithSubqueries(subQueries)
        mainQuery.whereKey("connected", equalTo: true)
        mainQuery.includeKey("user1")
        mainQuery.includeKey("user2")
        
        mainQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                conncetions = objects as! [PFObject]
                    
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        return conncetions
    }
    
    //Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
            var connectionsToDelete = queryForConnectionWithUser(users[indexPath.row])
            for connection in connectionsToDelete{
                connection["connected"] = false
                connection.saveInBackground()
            }
            getCollabs()
            
            tableView.reloadData()
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let user = sender as? PFUser{
            if segue.identifier == "CollabsToProfile" {
                var profileViewController = segue.destinationViewController as! ProfileViewController
                profileViewController.user = user
            }
            
        }
    }


}
