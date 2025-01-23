//  UITextField+Extension.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 07/06/23.

import UIKit
import UITextView_Placeholder

//MARK:- UITEXTFIELD EXTENSION

extension UITextField {
    
    func addShadoww(placeHolderText: String) {
        self.textColor = UIColor.black
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func addPlaceHolderText(placeHolderText: String) {
        self.textColor = UIColor.black
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor.black.cgColor
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftViewMode = .always
    }
    
    func addPadding() {
      
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.rightViewMode = .always
    }
   
    func addLeftPadding() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.rightViewMode = .always
    }
    
    func removeLeftPadding() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.height))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.rightViewMode = .always
    }
    
    func addBorderLayerr() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftViewMode = .always
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5;
    }
}

//MARK:- UITEXTVIEW EXTENSION

extension UITextView {
    
    func addPlaceHolderText(placeHolderText: String) {
        self.textColor = UIColor.black
        self.placeholderColor = UIColor.lightGray
        self.placeholder = placeHolderText
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(red: 40.0/255.0, green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0).cgColor
    }
    
}

//MARK:- UIBUTTON EXTENSION

extension UIButton {
    
 func addBorder() {
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.borderWidth = 2
    
 }
 
}

//MARK:- UIVIEW EXTENSION

extension UIView {
    
 func addBorderLayer() {
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.5
    self.layer.cornerRadius = 5
    
 }
 
}
    
    

