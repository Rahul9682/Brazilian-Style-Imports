//  ForgotPasswordViewController.swift
//  QuickB2B Wholesale
// Created by Sazid Saifi on 5/19/21.

import UIKit
import SwiftyJSON

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var customerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var customerIDTextField: UITextField!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet weak var supplIerNameLabel: UILabel!
    
    //MARK: -> Properties
    var viewModel = ForgotPasswordViewModel()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
         //MARK: - Helpers
    private func configureUI() {
       // supplIerNameLabel.text = "Supplier Name: " + KeyConstants.clientCode
        supplIerNameLabel.isHidden = true
        continueButton.layer.cornerRadius = 4
        customerIDTextField.delegate = self
        //customerIDTextField.addPlaceHolderText(placeHolderText: "Customer ID")
        
        //customerView.layer.cornerRadius = 4
        customerView.layer.borderWidth = 2
        customerView.layer.borderColor = UIColor.black.cgColor
        customerView.clipsToBounds = true
        customerIDTextField.placeholder = "Customer ID"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.customerID  = customerIDTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if let result = viewModel.validation() {
            self.presentPopUpVC(message: result,title: "")
        } else {
            self.resetPassword(with: viewModel.param())
        }
    }
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
}

//MARK: - View-Model Interaction
extension ForgotPasswordViewController {
    private func resetPassword(with param: [String: Any]) {
        viewModel.resetPassword(with: param, view: view) { result in
            switch result{
            case .success(let forgotPasswordData):
                if let forgotPasswordData = forgotPasswordData {
                    
                    guard let status = forgotPasswordData.status else { return }
                    if (status == 1) {
                        DispatchQueue.main.async{
                            guard let messge = forgotPasswordData.message else {return}
                            self.presentPopUpVC(message:messge,title: "")
                        }
                    } else {
                        DispatchQueue.main.async{
                            guard let messge = forgotPasswordData.message else {return}
                            self.presentPopUpVC(message:messge,title: "")
                        }
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                    }
                } else  {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: serverNotResponding, title: "")
                    }
                }
            case .none:
                break
            }
        }
    }
}
