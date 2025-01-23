//  ConfirmOrderPopUpViewController.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 01/08/23.

import UIKit

class ConfirmOrderPopUpViewController: UIViewController {

    //MARK: -> Outlet’s
    @IBOutlet weak var messageLabel: UILabel!
    var delegate: LogoutDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var mainContainerView: UIView!
    
    //MARK: -> Properties
    var messageTitle: String = ""
    var confirmButtonTitle: String = ""
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - HELPERS
    func configureUI() {
        messageLabel.text = messageTitle
        confirmButton.setTitle(confirmButtonTitle, for: .normal)
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
        
        confirmButton.layer.cornerRadius = 4
        confirmButton.layer.borderWidth = 0.5
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.backgroundColor = UIColor.init(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        cancelButton.layer.cornerRadius = 4
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.backgroundColor = UIColor.init(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
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
    
    @IBAction func confirmButton(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.successLogout()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
