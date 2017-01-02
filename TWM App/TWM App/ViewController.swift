//
//  ViewController.swift
//  TWM App
//
//  Created by Hatim Rehman on 2016-06-04.
//  Copyright © 2016 Hatim Rehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://chatbottttt.mybluemix.net/#/chatting")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    }


}

