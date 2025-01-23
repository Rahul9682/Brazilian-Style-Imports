// PopupResetListViewController.swift
// QuickB2B Wholesale
// Created by Sazid Saifi on 5/28/21.

import UIKit

protocol ShowPopupResetListDelegate: class {
    func showPopUP(didTapCancel:Bool,didTapConfirm:Bool)
}

class PopupResetListViewController: UIViewController {

    //MARK: - Outlets
    weak var delegate:ShowPopupResetListDelegate?
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
    }
    
    override func viewDidLayoutSubviews() {
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func cancelButton(_ sender: UIButton) {
        delegate?.showPopUP(didTapCancel: true, didTapConfirm: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        delegate?.showPopUP(didTapCancel: false, didTapConfirm: true)
        self.dismiss(animated: false, completion: nil)
    }
}
