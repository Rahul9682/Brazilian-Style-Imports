//  UIViewController+Extension.swift
//  Thaizzle
//  Created by Gopabandhu on 03/12/20.
//  Copyright © 2020 Gopabandhu. All rights reserved.

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func mainNavigationController() -> HamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "HamburguerNavigationController") as! HamburguerNavigationController
    }
    
    //MARK: - Show Indicator Method
    func showIndicator() {
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.bezelView.color = UIColor.black // Your backgroundcolor
        Indicator.bezelView.style = .solidColor
        Indicator.contentColor = UIColor.white
        //Indicator.label.text = title
        Indicator.isUserInteractionEnabled = false
        //Indicator.detailsLabel.text = Description
        Indicator.show(animated: true)
    }
    
    //MARK: - Hide Indicator Method
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
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
