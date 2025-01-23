//  CustomTabBarView.swift
//  QuickB2BWholesale
//  Created by Sazid on 13/04/23.

import UIKit

class CustomTabBarView: UIView {
    //MARK: -> OutLet's
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var hoeLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var specialImageView: UIImageView!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var themeBorder: UIView!
    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var trailingConst: NSLayoutConstraint!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    
    //MARK: -> Properties
    var didClickHomeButton: (() -> Void)?
    var didClickMyList: (() -> Void)?
    var didClickProduct: (() -> Void)?
    var didClickSpecials: (() -> Void)?
    var didClickMore: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //configureTabUI(with: .home)
    }
    
    @objc func bottomTitleLabelTapped(_ sender: UITapGestureRecognizer) {
        openURL("http://quickb2b.com/")
    }
    
    //MARK: -> Function to open a URL
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("URL cannot be opened.")
                // Handle the case when the URL cannot be opened, e.g., display an error message.
            }
        } else {
            print("Invalid URL.")
            // Handle the case when the URL string is not a valid URL.
        }
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        //Constants.getCartUpdatedItems()
        configureTabUI(with: .home)
        didClickHomeButton?()
    }
    
    @IBAction func myListButton(_ sender: UIButton) {
        //Constants.getCartUpdatedItems()
        configureTabUI(with: .myList)
        didClickMyList?()
    }
    
    
    @IBAction func productButton(_ sender: UIButton) {
        //Constants.getCartUpdatedItems()
        configureTabUI(with: .myProduct)
        didClickProduct?()
    }
    
    @IBAction func specialbutton(_ sender: UIButton) {
        configureTabUI(with: .special)
        didClickSpecials?()
    }
    
    @IBAction func moreButton(_ sender: UIButton) {
       // Constants.getCartUpdatedItems()

        configureTabUI(with: .account)
        didClickMore?()
    }
    
    func configureTabUI(with tab: TabType) {
        bottomTitleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomTitleLabelTapped(_:)))
        bottomTitleLabel.addGestureRecognizer(tapGesture)
        
        if tab == .home {
            configureUnderLine(type: .home)
            homeImage.image =  UIImage(named: "home")
            productImageView.image =  UIImage(named: "product")
            listImage.image =  UIImage(named: "myList")
            specialImageView.image =  UIImage(named: "cart")
            moreImageView.image =  UIImage(named: "user")
        } else if tab == .myList {
            configureUnderLine(type: .myList)
            homeImage.image =  UIImage(named: "home")
            listImage.image =  UIImage(named: "myList")
            productImageView.image =  UIImage(named: "product")
            specialImageView.image =  UIImage(named: "cart")
            moreImageView.image =  UIImage(named: "user")
        }  else if tab == .myProduct {
            configureUnderLine(type: .myProduct)
            homeImage.image =  UIImage(named: "home")
            listImage.image =  UIImage(named: "myList")
            productImageView.image =  UIImage(named: "product")
            specialImageView.image =  UIImage(named: "cart")
            moreImageView.image =  UIImage(named: "user")
        } else if tab == .myOrders {
            configureUnderLine(type: .myOrders)
            homeImage.image =  UIImage(named: "home")
            listImage.image =  UIImage(named: "myList")
            productImageView.image =  UIImage(named: "product")
            specialImageView.image =  UIImage(named: "cart")
            moreImageView.image =  UIImage(named: "user")
        } else {
            configureUnderLine(type: .account)
            homeImage.image =  UIImage(named: "home")
            listImage.image =  UIImage(named: "myList")
            productImageView.image =  UIImage(named: "product")
            specialImageView.image =  UIImage(named: "cart")
            moreImageView.image =  UIImage(named: "user")
        }
    }
    
    func addUnderLineWithColor(lbl: UILabel) {
        lbl.textColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
        var attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
        attributes[.underlineColor] = underlineColor
        let attributedString = NSAttributedString(string: lbl.text ?? "", attributes: attributes)
        lbl.attributedText = attributedString
    }
    
    func removeUnderLineWithColor(lbl: UILabel) {
        lbl.textColor = UIColor.black
        var attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineColor = UIColor.white
        attributes[.underlineColor] = underlineColor
        let attributedString = NSAttributedString(string: lbl.text ?? "", attributes: attributes)
        lbl.attributedText = attributedString
    }
    
    //MARK: -> configureUnderLine
    func configureUnderLine(type: TabType) {
        switch type {
        case .home:
            addUnderLineWithColor(lbl: hoeLabel)
            removeUnderLineWithColor(lbl: listLabel)
            removeUnderLineWithColor(lbl: productLabel)
            removeUnderLineWithColor(lbl: specialLabel)
            removeUnderLineWithColor(lbl: accountLabel)
        case .myList:
            addUnderLineWithColor(lbl: listLabel)
            removeUnderLineWithColor(lbl: hoeLabel)
            removeUnderLineWithColor(lbl: productLabel)
            removeUnderLineWithColor(lbl: specialLabel)
            removeUnderLineWithColor(lbl: accountLabel)
        case .myProduct:
            addUnderLineWithColor(lbl: productLabel)
            removeUnderLineWithColor(lbl: hoeLabel)
            removeUnderLineWithColor(lbl: listLabel)
            removeUnderLineWithColor(lbl: specialLabel)
            removeUnderLineWithColor(lbl: accountLabel)
        case .myOrders:
            addUnderLineWithColor(lbl: specialLabel)
            removeUnderLineWithColor(lbl: hoeLabel)
            removeUnderLineWithColor(lbl: listLabel)
            removeUnderLineWithColor(lbl: productLabel)
            removeUnderLineWithColor(lbl: accountLabel)
        case .account:
            addUnderLineWithColor(lbl: accountLabel)
            removeUnderLineWithColor(lbl: hoeLabel)
            removeUnderLineWithColor(lbl: listLabel)
            removeUnderLineWithColor(lbl: productLabel)
            removeUnderLineWithColor(lbl: specialLabel)
        default:
            break
        }
    }
    
    func getCartImage() -> String {
        let localStorageArray = LocalStorage.getFilteredData()
        if localStorageArray.count == 0 {
            return "cart_blank"
        } else {
            return "cart"
        }
    }
}

