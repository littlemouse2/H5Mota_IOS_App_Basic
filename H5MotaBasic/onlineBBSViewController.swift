//
//  onlineBBSViewController.swift
//  H5MotaBasic
//
//  Created by Arbitrary Mouse on 5/23/24.
//

import UIKit
import WebKit

class onlineBBSViewController: UIViewController{

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        webView.uiDelegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://h5mota.com/bbs/#/all") {
                      webView.load(URLRequest(url: url))
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        webView.reload()
        sender.endRefreshing()
    }
}

extension onlineBBSViewController : WKUIDelegate {
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
                    var urlString = webView.url!.absoluteString
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
                        else if(UIDevice.current.orientation == .portrait && self.tabBarController?.tabBar.isHidden == true)
                        {
                            self.tabBarController?.tabBar.isHidden = false
                        }
                    }
                }
            }
        }
        return nil
    }
}
