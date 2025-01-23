//  UpdateAvailableViewController.swift
//  QuickB2B
//  Created by Sazid Saifi on 29/09/23.

import UIKit

class UpdateAvailableViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerViewHeightConst: NSLayoutConstraint!
    
    //MARK: -> Properties
    var updateType: String = ""
    var updateMessage: String = ""
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateType = "Flexible"
        configureUI()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        updateButton.titleLabel?.textColor = UIColor.white
        updateButton.layer.cornerRadius = 4
        updateButton.layer.backgroundColor = UIColor.black.cgColor
        titleLabel.text = updateMessageTitle
//        messageLabel.text = "Swift is a multi-paradigm, compiled programming language for designing applications for iOS and macOS, tvOS and watchOS. Apple Inc. is the company behind it. It is a powerful and intuitive language that is also simple to pick up. Swift is an interactive programming language that is quick, safe, and welcoming to new projects. It is based on the Objective C runtime library, which enables the execution of C, Objective C, C++, and Swift code in the same program. Swift has been integrated with Xcode since version 6 and is built with the open-source LLVM compiler and can be used for creating both the front end and back end functionalities of applications."
       messageLabel.text = self.updateMessage
        let contentSize = messageLabel.sizeThatFits(CGSize(width: messageLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        // The height of the content is stored in contentSize.height
        let messageLabelContentHeight = contentSize.height
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        cancelButton.titleLabel?.textColor = UIColor.gray
        if self.updateType == "Flexible" {
            cancelButton.isHidden = false
           // containerViewHeightConst.constant = 230
            containerViewHeightConst.constant = (160 + messageLabelContentHeight) + 40
        } else {
            cancelButton.isHidden = true
            containerViewHeightConst.constant = (200 + messageLabelContentHeight) - 40
        }
        print("height",containerViewHeightConst.constant)
    }
    
    //MARK: -> Button Actions
    @IBAction func updateButton(_ sender: UIButton) {
        if let url = URL(string: GlobalConstantClass.APIConstantNames.AppStoreUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
