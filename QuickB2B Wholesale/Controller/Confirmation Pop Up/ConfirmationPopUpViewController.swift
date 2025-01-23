//  ConfirmationPopUpViewController.swift
//  QuickB2B
//  Created by Braintech on 17/05/24.

import UIKit

class ConfirmationPopUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
    // MARK: - Properties
    var successDelegate: ConfirmationPopupSuccessDelegate?
    var titleMessage = ""
    var okButtonTitle = "Ok"
    var cancelButtonTitle = "Cancel"
    var isApplyButtonBGColor:Bool = false
    var didClickCrossButton:(()->Void)?
    
    // MARK: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        applyButtonBGCOlor(isApply:isApplyButtonBGColor)
    }
    
    //MARK: - HELPERS
    func configureUI() {
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
        messageTitleLabel.text = titleMessage
        okButton.setTitle(okButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
    }
    
    func applyButtonBGCOlor(isApply:Bool) {
        if isApply {
            okButton.layer.cornerRadius = 4
            okButton.layer.borderWidth = 0.5
            okButton.layer.borderColor = UIColor.white.cgColor
            okButton.backgroundColor = UIColor.init(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            
            cancelButton.layer.cornerRadius = 4
            cancelButton.layer.borderWidth = 0.5
            cancelButton.layer.borderColor = UIColor.white.cgColor
            cancelButton.backgroundColor = UIColor.init(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        } else {
            okButton.layer.cornerRadius = 4
            okButton.layer.borderWidth = 0.5
            okButton.layer.borderColor = UIColor.clear.cgColor
            okButton.backgroundColor = UIColor.clear
            
            cancelButton.layer.cornerRadius = 4
            cancelButton.layer.borderWidth = 0.5
            cancelButton.layer.borderColor = UIColor.clear.cgColor
            okButton.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Button Actions
    @IBAction func okButton(_ sender: UIButton) {
        if let successDelegate = successDelegate {
            successDelegate.isSuccess(success: true)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        if let successDelegate = successDelegate {
            successDelegate.isSuccess(success: false)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        didClickCrossButton?()
        self.dismiss(animated: false, completion: nil)
    }
}
