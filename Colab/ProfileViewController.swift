//
//  ProfileViewController.swift
//  Colab
//
//  Created by Emilio Arellano on 7/10/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    var user: PFUser!
	var media: [String]!
	var industry: String!
	var region: String!
	var name: String!
	var bioDescription = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var media1Label: UILabel!
    @IBOutlet weak var media2Label: UILabel!
    @IBOutlet weak var media3Label: UILabel!
    @IBOutlet weak var industry1Label: UILabel!
    @IBOutlet weak var bioDescriptionLabel: UITextView!
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var loadingPicture: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user != nil {
			name = user["name"] as! String
			region = user["region"] as! String
			media = user["platforms"] as! [String]
            industry = user["industry"] as! String
            let bioDescription: String = user["bio"] as! String
			
			nameLabel.text = name
			regionLabel.text = region
            bioDescriptionLabel.text = bioDescription
			industry1Label.text = industry
            //populateIndustry()
            populateMedia()
        }
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		profilePicture.layer.cornerRadius = 64
		profilePicture.layer.masksToBounds = true
		
		loadingPicture.stopAnimating()
		loadingPicture.hidden = true
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		getProfilePic()
	}
	
    func populateMedia(){
        var counter = 0
        while counter < 3 {
            switch counter{
            case 0: media1Label.text = media[counter++]
            case 1: media2Label.text = media[counter++]
            case 2: media3Label.text = media[counter++]
            default: break
            }
        }
    }
	
	func getProfilePic() {
		let urlString = user["pictureURL"] as! String
		
		loadingPicture.startAnimating()
		loadingPicture.hidden = false
		
		let image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
		
		loadingPicture.stopAnimating()
		loadingPicture.hidden = true
		
		profilePicture.image = image
		
	}

//    func populateIndustry(){
//        var counter = 0
//        while counter < industry.count{
//            switch counter{
//            case 0: industry1Label.text = industry[counter++]
//            default: break
//            }
//        }
//    }
	
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
