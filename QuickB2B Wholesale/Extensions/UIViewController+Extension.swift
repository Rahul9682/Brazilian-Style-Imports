//  UIViewController+Extension.swift
//  Thaizzle
//  Created by Gopabandhu on 03/12/20.
//  Copyright © 2020 Gopabandhu. All rights reserved.

import UIKit
//import MBProgressHUD

extension UIViewController {
    
    func mainNavigationController() -> HamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "HamburguerNavigationController") as! HamburguerNavigationController
    }
    
    //    //MARK: - Show Indicator Method
    //    func showIndicator() {
    //        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        Indicator.bezelView.color = UIColor.black // Your backgroundcolor
    //        Indicator.bezelView.style = .solidColor
    //        Indicator.contentColor = UIColor.white
    //        //Indicator.label.text = title
    //        Indicator.isUserInteractionEnabled = false
    //        //Indicator.detailsLabel.text = Description
    //        Indicator.show(animated: true)
    //    }
    //
    //    //MARK: - Hide Indicator Method
    //    func hideIndicator() {
    //        MBProgressHUD.hide(for: self.view, animated: true)
    //    }
    
    private struct ActivityIndicatorConstants {
        static var backgroundViewTag = 999
    }
    
    func showIndicator() {
        self.hideIndicator()
        // Check if the indicator is already present
        if self.view.viewWithTag(ActivityIndicatorConstants.backgroundViewTag) != nil {
            return
        }
        
        // Create a background view
        let bgView = UIView(frame: self.view.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.1) // Black transparent background
        bgView.tag = ActivityIndicatorConstants.backgroundViewTag
        
        // Create a container for the indicator
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the activity indicator
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the indicator to the container view
        containerView.addSubview(indicator)
        
        // Add container to the background view
        bgView.addSubview(containerView)
        
        // Add to the current view
        self.view.addSubview(bgView)
        
        // Center the indicator inside the container
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.widthAnchor.constraint(equalToConstant: 72),
            containerView.heightAnchor.constraint(equalToConstant: 72),
            containerView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
    }
    
    func hideIndicator() {
        if let bgView = self.view.viewWithTag(ActivityIndicatorConstants.backgroundViewTag) {
            bgView.removeFromSuperview()
        }
    }
    
    //MARK: - Show Custom PopUp
    func presentPopUpVC(message:String,title:String) {
        DispatchQueue.main.async {
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = StoryBoard.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC
            vc?.strMessage = message
            vc?.strTitle = title
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
}


//MARK: - Font Extension

extension UIFont {
    public enum OpenSansType: String {
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case bold = "-Bold"
    }
    
    static func OpenSans(_ type: OpenSansType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "OpenSans\(type.rawValue)", size: size)!
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
