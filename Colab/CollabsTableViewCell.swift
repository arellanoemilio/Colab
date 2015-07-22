//
//  CollabsTableViewCell.swift
//  Colab
//
//  Created by Mikk Kärner on 14/07/15.
//  Copyright (c) 2015 Mikk Kärner and Emilio Arellano. All rights reserved.
//

import UIKit
import Parse

class CollabsTableViewCell: UITableViewCell {

	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var industryLabel: UILabel!
	@IBOutlet weak var regionLabel: UILabel!
	
	var user: PFUser! {
		didSet {
			setup()
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setup() {
		let urlString = user["pictureURL"] as! String
		let name = user["name"] as! String
		let region = user["region"] as! String
		let industry = user["industry"] as! String
		
		nameLabel.text = name
		regionLabel.text = region
		industryLabel.text = industry
		
		let image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
		
		profilePicture.image = image
		profilePicture.layer.cornerRadius = 28
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		profilePicture.clipsToBounds = true
		
	}
	
}
