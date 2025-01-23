//  FeaturedTableViewCell.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import WebKit

class FeaturedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var webkitview: WKWebView!
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var productTitlelabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        //setGradientBackground()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureUI() {
        webkitview.scrollView.isScrollEnabled = false
        webkitview.scrollView.showsVerticalScrollIndicator = false
        //webkitview.uiDelegate = self
      //  webkitview.navigationDelegate = self
        selectionStyle = .none
        //productDescriptionLabel.text = "New Product Alert"
        //productDescriptionLabel.text = "A slice of functionality that describes a product's appearance, components, and/or capabilities. User story. A product feature described from the perspective of the end-user."
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.topView.bounds
        self.topView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func configureData(data: FeaturedItem?) {
        if let data = data {
            if let htmlString = data.content {
                let  htmlStringg = "<meta name=\"viewport\" content=\"initial-scale=1.0\" />" + htmlString
                self.webkitview.loadHTMLString(htmlStringg, baseURL: nil)
            }
        }
    }
    
    //MARK: -> Button Actions
}

// MARK: - WKUIDelegate,WKNavigationDelegate
//extension FeaturedTableViewCell: WKUIDelegate,WKNavigationDelegate {
//    func HTMLImageCorrector(HTMLString: String) -> String {
//        var HTMLToBeReturned = HTMLString
//        while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil{
//            if let match = HTMLToBeReturned.range(of:"(?<=width=\")[^\" height]+", options: .regularExpression) {
//                HTMLToBeReturned.removeSubrange(match)
//                if let match2 = HTMLToBeReturned.range(of:"(?<=height=\")[^\"]+", options: .regularExpression) {
//                    HTMLToBeReturned.removeSubrange(match2)
//                    let string2del = "width=\"\" height=\"\""
//                    HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of:string2del, with: "")
//                }
//            }
//        }
//        return HTMLToBeReturned
//    }
//
//    func webViewDidFinishLoad(webView: UIWebView) {
//        webView.frame.size.height = 1
//        webView.frame.size = webView.sizeThatFits(CGSize.zero)
//    }
//}
