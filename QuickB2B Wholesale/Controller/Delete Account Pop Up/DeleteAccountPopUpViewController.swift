//  DeleteAccountPopUpViewController.swift
//Created by Sazid Saifi on 16/08/22.

import UIKit

protocol DeleteAccountDelegate {
    func success()
}

class DeleteAccountPopUpViewController: UIViewController {
    
    //MARK: - OUTLETS
    var delegate: DeleteAccountDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var deleteAccountButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var mainContainerView: UIView!
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - HELPERS
    func configureUI() {
        containerView.layer.cornerRadius = Radius.popUpViewRadius
//        crossButton.layer.cornerRadius = 5
//        crossButton.layer.borderWidth = 0.5
//        crossButton.layer.borderColor = UIColor(displayP3Red: 83/255, green: 168/255, blue: 276/255, alpha: 1).cgColor
//        
        crossButton.layer.borderWidth = 1
        crossButton.layer.borderColor = AppColors.popUpCrossBorderColor.cgColor
        crossButton.layer.cornerRadius = 5
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
            delegate.success()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

