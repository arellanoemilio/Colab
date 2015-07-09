//
//  ViewController.swift
//  Colab
//
//  Created by Mikk Kärner on 09/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var red: CGFloat!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		//red = ((baseColor1 & 0xFF0000) >> 16) / 255.0f
		
		var gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]
		view.layer.insertSublayer(gradient, atIndex: 0)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

