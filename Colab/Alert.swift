//
//  Alert.swift
//  co.op
//
//  Created by Mikk Kärner on 21/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit

class Alert: NSObject {
	
	static func getAlertController(title: String, text: String, button: String) -> UIAlertController {
		
		let alertController = UIAlertController(title: title, message:
			text, preferredStyle: UIAlertControllerStyle.Alert)
		
		alertController.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.Default,handler: nil))
				
		return alertController
	}
	
	
}
