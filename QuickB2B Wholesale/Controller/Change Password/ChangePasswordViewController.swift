//  ChangePasswordViewController.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/18/21.

import UIKit
import SwiftyJSON

class ChangePasswordViewController: UIViewController,UITextFieldDelegate,PopUpDelegate {
    
    //MARK: - Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPassContainerView: UIView!
    @IBOutlet weak var newPassContainerView: UIView!
    @IBOutlet weak var oldPassContainerView: UIView!
    
    @IBOutlet weak var oldPassEyeButton: UIButton!
    @IBOutlet weak var newPassEyeButton: UIButton!
    @IBOutlet weak var confirmPassEyeButton: UIButton!
    var isShowOldPass: Bool = false
    var isShowNewPass: Bool = false
    var isShowConfirmPass: Bool = false
  
    @IBAction func confirmPassEyeButton(_ sender: UIButton) {
        isShowConfirmPass =  !isShowConfirmPass
        configureConfirmPasswordEyeButton(isShowConfirmPass: isShowConfirmPass)
    }
    
    @IBAction func newPassEyeButton(_ sender: UIButton) {
        isShowNewPass =  !isShowNewPass
        configureNewPasswordEyeButton(isShowNewPass: isShowNewPass)
    }
    
    @IBAction func oldPassEyeButton(_ sender: UIButton) {
        isShowOldPass =  !isShowOldPass
        configureOldPasswordEyeButton(isShowOldPass: isShowOldPass)
    }

    private func configureOldPasswordEyeButton(isShowOldPass: Bool) {
        if isShowOldPass {
            oldPassEyeButton.setImage(Icons.openEye, for: .normal)
            oldPasswordTextField.isSecureTextEntry = false
        } else {
            oldPassEyeButton.setImage(Icons.closeEye, for: .normal)
            oldPasswordTextField.isSecureTextEntry = true
        }
    }
    
    private func configureNewPasswordEyeButton(isShowNewPass: Bool) {
        if isShowNewPass {
            newPassEyeButton.setImage(Icons.openEye, for: .normal)
            newPasswordTextField.isSecureTextEntry = false
        } else {
            newPassEyeButton.setImage(Icons.closeEye, for: .normal)
            newPasswordTextField.isSecureTextEntry = true
        }
    }
    
    private func configureConfirmPasswordEyeButton(isShowConfirmPass: Bool) {
        if isShowConfirmPass {
            confirmPassEyeButton.setImage(Icons.openEye, for: .normal)
            confirmPasswordTextField.isSecureTextEntry = false
        } else {
            confirmPassEyeButton.setImage(Icons.closeEye, for: .normal)
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    //MARK: - Properties
   
    var viewModel = ChangePasswordViewModel()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureOldPasswordEyeButton(isShowOldPass: isShowOldPass)
        configureNewPasswordEyeButton(isShowNewPass: isShowOldPass)
        configureConfirmPasswordEyeButton(isShowConfirmPass: isShowConfirmPass)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helpers
    private func configureUI() {
        saveButton.layer.cornerRadius = 5
//        oldPasswordTextField.layer.cornerRadius = 4
//        newPasswordTextField.layer.cornerRadius = 4
//        confirmPasswordTextField.layer.cornerRadius = 4
        
       // newPassContainerView.layer.cornerRadius = 4
        newPassContainerView.layer.borderWidth = 2
        newPassContainerView.layer.borderColor = UIColor.black.cgColor
        newPassContainerView.clipsToBounds = true
        
        //oldPassContainerView.layer.cornerRadius = 4
        oldPassContainerView.layer.borderWidth = 2
        oldPassContainerView.layer.borderColor = UIColor.black.cgColor
        oldPassContainerView.clipsToBounds = true
        
        //confirmPassContainerView.layer.cornerRadius = 4
        confirmPassContainerView.layer.borderWidth = 2
        confirmPassContainerView.layer.borderColor = UIColor.black.cgColor
        confirmPassContainerView.clipsToBounds = true
        
        oldPasswordTextField.placeholder = "Password"
        newPasswordTextField.placeholder = "New Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
        
        self.viewModel.arrSuppliers = viewModel.db.readData()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
//        oldPasswordTextField.addPlaceHolderText(placeHolderText: "Password")
//        newPasswordTextField.addPlaceHolderText(placeHolderText: "New Password")
//        confirmPasswordTextField.addPlaceHolderText(placeHolderText: "Confirm Password")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == oldPasswordTextField) {
            newPasswordTextField.becomeFirstResponder()
        } else if(textField == newPasswordTextField) {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            confirmPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - TAP GESTURE METHOD
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - Button Action
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.oldPassword = oldPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.newPassword = newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let res = viewModel.validations() {
            self.presentPopUpVC(message: res,title: "")
        } else {
            self.changePassword(with: viewModel.param())
        }
    }
    
    
    
    
    //MARK: - PRESENT POP UP WITH DELEGATE
    func presentPopUpWithDelegate(strMessage:String,buttonTitle:String) {
        DispatchQueue.main.async {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
            vc.strMessage = strMessage
            vc.buttonTitle = buttonTitle
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //MARK: - POP UP DELEGATE
    func didTapDone() {
        var userId = ""
        var userDefaultId = ""
        if let userid = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String {
            userId = userid
        }
        if let userdefaultId = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String {
            userDefaultId = userdefaultId
        }
        if(viewModel.isPopToAnotherViewController) {
            self.navigationController?.popViewController(animated: false)
        } else {
            if(userId == userDefaultId) {
                self.logOut()
            } else {
                UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
                UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
                self.pushToOutlets()
            }
        }
    }
    
    //MARK: - METHOD TO PUSH TO OUTLETS
    
    func pushToOutlets() {
        guard let  outletVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController else {return}
        self.navigationController?.pushViewController(outletVC, animated: false)
    }
    
    //MARK: - LOGOUT METHOD
    func logOut() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        viewModel.db.deleteByClientCode(strClientCode: clientCode)
        self.viewModel.arrSuppliers = viewModel.db.readData()
        if(viewModel.arrSuppliers.count != 0){
            
            if let strAppName = self.viewModel.arrSuppliers[0]["supplier_name"]{
                //UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
            }
            if let strClientCode = self.viewModel.arrSuppliers[0]["client_code"]{
                UserDefaults.standard.set(strClientCode, forKey: "ClientCode")
            }
            if let strUserLoginId = self.viewModel.arrSuppliers[0]["user_code"]{
                UserDefaults.standard.set(strUserLoginId, forKey:UserDefaultsKeys.UserLoginID)
            }
            if let strUserLoginId = self.viewModel.arrSuppliers[0]["user_code"]{
                UserDefaults.standard.set(strUserLoginId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            }
            
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
}

// MARK: View-Model Intetraction
extension ChangePasswordViewController {
    private func changePassword(with param: [String: Any]) {
        print("Request Param:: ",JSON(param))
        viewModel.changePassword(with: param, view: view) { result in
            switch result{
            case .success(let changePasswordData):
                if let changePasswordData = changePasswordData {
                    guard let status = changePasswordData.status else { return }
                    if (status == 1) {
                        self.viewModel.isPopToAnotherViewController = true
                        guard let messge = changePasswordData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                    } else if(status == 2){
                        self.viewModel.isPopToAnotherViewController = false
                        guard let messge = changePasswordData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                    }
                    else {
                        self.viewModel.isPopToAnotherViewController = false
                        guard let messge = changePasswordData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                } else {
                    self.presentPopUpVC(message: serverNotResponding, title: "")
                }
            case .none:
                break
            }
        }
    }
}
