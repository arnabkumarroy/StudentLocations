//
//  OnTheMapWebViewController.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit
import WebKit

class OnTheMapWebViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString = "https://www.udacity.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView(urlString)
    }
    
    func loadWebView (_ url: String) {
        let request = URLRequest(url: URL(string: url)!)
        self.view.addSubview(webView)
        webView.load(request)
    }
    
    
}

