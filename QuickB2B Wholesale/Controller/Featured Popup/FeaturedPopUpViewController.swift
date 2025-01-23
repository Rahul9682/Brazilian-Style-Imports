//  FeaturedPopUpViewController.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/28/21.

import UIKit
import WebKit

class FeaturedPopUpViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var featuredProductWebView: WKWebView!
    
    //MARK:- Properties
    var strHtmlContent = ""
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    //MARK: - CONFIGURE UI METHOD
    private func configureUI() {
        viewContainer.backgroundColor = UIColor.clear
        featuredProductWebView.scrollView.showsHorizontalScrollIndicator = false
        featuredProductWebView.scrollView.showsVerticalScrollIndicator = false
        featuredProductWebView.navigationDelegate = self
        featuredProductWebView.uiDelegate = self
        let  htmlStringg = "<meta name=\"viewport\" content=\"initial-scale=1.0\" />" + strHtmlContent
        self.featuredProductWebView.loadHTMLString(htmlStringg, baseURL: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: - WEB VIEW DELEGATES
extension FeaturedPopUpViewController: WKNavigationDelegate,WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async { self.showIndicator()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async { self.hideIndicator()
            self.view.isUserInteractionEnabled = true
        }
    }
}
