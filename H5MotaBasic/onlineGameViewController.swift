//
//  onlineGameViewController.swift
//  H5MotaBasic
//
//  Created by Arbitrary Mouse on 5/23/24.
//

import UIKit
import WebKit

class onlineMotaViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var navigationDelegate: WKNavigationDelegate!
    override func viewDidLoad() {
        
        webView.uiDelegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://h5mota.com/play") {
            webView.load(URLRequest(url: url))
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self,
                                  selector: #selector(orientationDidChange),
                name: UIDevice.orientationDidChangeNotification, object: nil)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
    }
    
    @objc func orientationDidChange(_ notification: Notification) {
        if UIDevice.current.orientation.isLandscape {
            self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        webView.reload()
        sender.endRefreshing()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url), let url = webView.url {
            var urlString = url.absoluteString
            if(urlString.last == "/")
            {
                urlString = String(urlString.dropLast())
            }
            if(urlString.lastIndex(of: "/") != nil)
            {
                let range = urlString.index(urlString.lastIndex(of: "/")!, offsetBy: -5)..<urlString.lastIndex(of: "/")!
                if(urlString[range] == "games")
                {
                    self.tabBarController?.tabBar.isHidden = true
                }
                else if((UIDevice.current.orientation.rawValue == 0 || UIDevice.current.orientation.rawValue == 2) &&
                        self.tabBarController?.tabBar.isHidden == true)
                {
                    self.tabBarController?.tabBar.isHidden = false
                }
            }
        }
    }
}

extension onlineMotaViewController : WKUIDelegate {
    //用来接收 js的open方法
    //打开新网页的时候调用下面方法
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.request.url != nil {
            let url = navigationAction.request.url
            if let urlPath = url?.absoluteString {
                //print("urlPath=",urlPath)
                if (urlPath as NSString?)?.range(of: "https://").location != NSNotFound || (urlPath as NSString?)?.range(of: "http://").location != NSNotFound {
                    //如果找到https://或者 http://就打开网页
                    if let url = URL(string: urlPath ) {
                        webView.load(URLRequest(url: url))
                    }
                }
            }
        }
        return nil
    }
}
