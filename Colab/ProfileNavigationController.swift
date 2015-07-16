//
//  ProfileNavigationController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/14/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class ProfileNavigationController: UINavigationController {

    var user: PFUser? = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user: PFUser? = PFUser.currentUser()
        if user == nil {
            println("user is nil")
        }else{
          println("user is not nil")
        }
        var profileViewCon = topViewController as! ProfileViewController
        profileViewCon.user = user
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
