//  PopUpResetListConfirmationViewController.swift
//  QuickB2B
//  Created by Vijay's Braintech on 19/10/23.

import UIKit

protocol PopupResetListConfirmationDelegate: class {
    func showPopConfirmationUP(didTapCancel:Bool,didTapConfirm:Bool)
}

class PopUpResetListConfirmationViewController: UIViewController {
    
    //MARK: - Outlets
    weak var delegate:PopupResetListConfirmationDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var messageLabel: SemiBoldLabelSize14!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    var strMessage = ""
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        messageLabel.textColor = UIColor.white
        messageLabel.text = strMessage
        
        cancelButton.titleLabel?.font = UIFont(name: fontName.N_SemiBoldFont.rawValue, size: 16.0)
        confirmButton.titleLabel?.font = UIFont(name: fontName.N_SemiBoldFont.rawValue, size: 16.0)
    }
    
    override func viewDidLayoutSubviews() {
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func cancelButton(_ sender: UIButton) {
        delegate?.showPopConfirmationUP(didTapCancel: true, didTapConfirm: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        delegate?.showPopConfirmationUP(didTapCancel: false, didTapConfirm: true)
        self.dismiss(animated: false, completion: nil)
    }
}
