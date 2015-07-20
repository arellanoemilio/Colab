//
//  SocialWebviewViewController.swift
//  co.op
//
//  Created by Mikk Kärner on 20/07/15.
//  Copyright (c) 2015 mikkkarner. All rights reserved.
//

import UIKit

class SocialWebviewViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webview: UIWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		var request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
		webview.loadRequest(request)
		//println(webview.request?.URL?.absoluteString)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		println(webview.request?.URL?.absoluteString)
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
