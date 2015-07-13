//
//  DisplayListTableViewController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/13/15.E
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit

class DisplayListTableView: UITableView{
    var listToDisplay = [String]()
    var cellIdentifier = "Centered Text Cell"
    
    override func numberOfSections() -> Int {
        return 1
    }
    override func numberOfRowsInSection(section: Int) -> Int {
        return self.listToDisplay.count
    }
}
