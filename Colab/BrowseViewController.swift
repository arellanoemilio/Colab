//
//  BrowseViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 10/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class BrowseViewController: UIViewController {

    typealias PropertyList = AnyObject
    var filters: PropertyList{
        get{
            var list = [Array<String>]()
            list.append(regions)
            list.append(platforms)
            list.append(industries)
            return list
        }
        set{
            if let list = newValue as? [Array<String>]{
                if list.count == 3{
                    regions  = list[0]
                    platforms = list[1]
                    industries = list[2]
                }
            }
        }
    }
    
    var regions = [String]()
    var platforms = [String]()
    var industries = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
	
	@IBAction func unwindToBrowseViewController(sender: UIStoryboardSegue) {}

}
