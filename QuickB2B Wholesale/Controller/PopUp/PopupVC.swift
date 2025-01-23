//  PopupVC.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 4/15/21.

import UIKit

class PopupVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var btnOK: UIButton!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    //MARK: - Properties
    var strMessage = ""
    var buttonTitle = ""
    var strTitle = ""
    weak var delegate:PopUpDelegate?
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        buttonTitle = "OK"
        lblMessage.text = strMessage;
        lblTitle.text = strTitle
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
        btnOK.setTitle(buttonTitle, for: .normal)
        btnOK.titleLabel?.font = UIFont(name: fontName.N_SemiBoldFont.rawValue, size: 16.0)
    }
    
    //MARK: - Button Action
    @IBAction func crossButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil);
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil);
        delegate?.didTapDone()
    }
}
