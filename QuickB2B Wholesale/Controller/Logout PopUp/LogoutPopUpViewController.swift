//  LogoutPopUpViewController.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 27/07/23.

import UIKit

class LogoutPopUpViewControllert: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: LogoutDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var deleteAccountButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var mainContainerView: UIView!
    
    //MARK: - Properties
    var titleMessage: String?
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - HELPERS
    func configureUI() {
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
        if let titleMessage = titleMessage {
            titleLabel.text = titleMessage
        } else {
            titleLabel.text = ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == mainContainerView {
            dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func deleteAccountButton(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.successLogout()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

