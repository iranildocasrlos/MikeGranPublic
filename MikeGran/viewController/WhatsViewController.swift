//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WhatsViewController : UIViewController, WKUIDelegate{
    
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: UIViewController
       
       override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
           webView.navigationDelegate = self
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: config)
        self.webView!.uiDelegate = self
                
        UserDefaults.standard.register(defaults: ["UserAgent" : "Safari"])
        //load URL here
           let url = NSURL(string: "https://web.whatsapp.com/")!
          
        let request = URLRequest(url: url as URL)

//        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36"

        webView.load(request)
        self.view.addSubview(webView)
           self.navegar()
           refreshNavigationControls()
       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        self.navegar()
          
       }
       
       // MARK: Button press handlers
       
       func navegar() {
        
        UserDefaults.standard.register(defaults: ["UserAgent" : "Safari"])
      
        
        
        let url = URL(string: "http://web.whatsapp.com")!
           webView.load(URLRequest(url: url))
        self.view.addSubview(webView)
       }
       
       @IBAction func handleBackButtonPress(_ sender: UIBarButtonItem) {
           webView.stopLoading()
           webView.goBack()
       }
       
       @IBAction func handleForwardButtonPress(_ sender: UIBarButtonItem) {
           webView.stopLoading()
           webView.goForward()
       }
       
       @IBAction func handleRefreshButtonPress(_ sender: UIBarButtonItem) {
           webView.reload()
       }
       
       // MARK: Private methods
       
       private func refreshNavigationControls() {
         
           refreshButton.isEnabled = webView.url != nil
        
       }
    
   }


   extension WhatsViewController: WKNavigationDelegate {
       
       func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
           UIApplication.shared.isNetworkActivityIndicatorVisible = true
           refreshNavigationControls()
       }
       
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           UIApplication.shared.isNetworkActivityIndicatorVisible = false
           webView.url?.absoluteString
       }
   }

    

