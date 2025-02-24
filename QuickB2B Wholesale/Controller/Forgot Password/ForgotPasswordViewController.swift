//  ForgotPasswordViewController.swift
//  QuickB2B Wholesale
// Created by Sazid Saifi on 5/19/21.

import UIKit
import SwiftyJSON
import DropDown

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var customerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var customerIDTextField: UITextField!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet weak var supplIerNameLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownImage: UIButton!
    @IBOutlet weak var searchRegionTextfield: UITextField!
    
    @IBOutlet weak var dropDownViewHeightConst: NSLayoutConstraint!
    
    //MARK: -> Properties
    var viewModel = ForgotPasswordViewModel()
    var dropDown = DropDown()
    var arrayOfRegion: [ClientRegion] = []
    var selectedRegionCode: String?
    var selectedIndex: Int?
    var selectRegion:String?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        arrayOfRegion = LocalStorage.getClientRegionData()
        configuredropDown()
        let showRegion = UserDefaults.standard.integer(forKey: UserDefaultsKeys.showRegion)
           if showRegion  == 0 {
               dropDownView.isHidden = true
               dropDownViewHeightConst.constant = 0
           } else {
               dropDownView.isHidden = false
               dropDownViewHeightConst.constant = 34
           }
        searchRegionTextfield.text = self.selectRegion
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
         //MARK: - Helpers
    private func configureUI() {
       // supplIerNameLabel.text = "Supplier Name: " + KeyConstants.clientCode
        supplIerNameLabel.isHidden = true
        continueButton.layer.cornerRadius = 4
        dropDownView.layer.borderWidth = 2
        dropDownView.layer.borderColor = UIColor.black.cgColor
        dropDownView.clipsToBounds = true
        
        
        customerIDTextField.delegate = self
        customerView.layer.borderWidth = 2
        customerView.layer.borderColor = UIColor.black.cgColor
        customerView.clipsToBounds = true
        customerIDTextField.placeholder = "Customer ID"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func configuredropDown() {
        dropDown.backgroundColor = .white
        dropDown.separatorColor = .white
        dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
            cell.optionLabel.textAlignment = .center // Change to .left or .right if needed
        }
       // dropDownView.layer.cornerRadius = 4
        dropDown.anchorView = dropDownView
       // dropDown.bottomOffset = CGPoint(x: 0, y: dropDownView.bounds.height)
        dropDown.bounds = CGRect(x: 0, y: dropDownView.frame.height-60, width: dropDownView.frame.width - 40,height: dropDownView.frame.height)
        // dropDown.width = dropDownView.bounds.width - 40
        //dropDown.cornerRadius = 4
        let arrayOfRegionName: [String] = self.arrayOfRegion.map { $0.companyName ?? "" }
        dropDown.dataSource = arrayOfRegionName
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchRegionTextfield.text = item
            self.selectedRegionCode = arrayOfRegion[index].clientCode
        }
    }

    //MARK: - BUTTON ACTION
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
    }
    
    
    @IBAction func continueButton(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.customerID  = customerIDTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        viewModel.seletedRegionCode = selectedRegionCode
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
