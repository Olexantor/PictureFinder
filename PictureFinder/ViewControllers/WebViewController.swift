//
//  WebViewController.swift
//  PictureFinder
//
//  Created by Александр on 23.12.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    let pictureUrl: URL
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    init(pictureUrl: URL) {
        self.pictureUrl = pictureUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: pictureUrl))
        webView.allowsBackForwardNavigationGestures = true
    }
}
