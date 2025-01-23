//  ShowThankYouPopUpViewController.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 6/1/21.

import UIKit

protocol ConfirmPaymentDelegate:class {
    func goToDashBoard()
}

class ShowThankYouPopUpViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    weak var delegate:ConfirmPaymentDelegate?
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        containerView.layer.cornerRadius = Radius.popUpViewRadius
        crossButton.layer.borderWidth = 1
        crossButton.layer.cornerRadius = 5
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        
        
        closeButton.layer.cornerRadius = 4
        closeButton.layer.borderWidth = 0.5
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.backgroundColor = UIColor.init(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func closeButton(_ sender: UIButton) {
        delegate?.goToDashBoard()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        delegate?.goToDashBoard()
        self.dismiss(animated: false, completion: nil)
    }
}
