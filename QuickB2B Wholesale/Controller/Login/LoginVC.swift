//  LoginVC.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 4/13/21.

import UIKit
import SwiftyJSON

class LoginVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var accessButtonButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var customerIDTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    //
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userIdContainerView: UIView!
    @IBOutlet weak var userIdEyeButton: UIButton!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordEyeButton: UIButton!
    
    //MARK: - Properties
    var viewModel = LoginViewModel()
    var isShowUserId:Bool = true
    var isShowPassword:Bool = false
    var noOfoutlets = 0
    var  userCode = ""
    
    //MARK: - View-Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return .darkContent
            } else {
                return .lightContent
            }
        } else {
            return .lightContent
        }
    }
    
    //MARK:- Helpers
    private func configureUI() {
        forgotPasswordButton.titleLabel?.font =  UIFont(name: fontName.N_RegularFont.rawValue, size: 14)
        accessButtonButton.titleLabel?.font =  UIFont(name: fontName.N_RegularFont.rawValue, size: 14)
        configureUserEyeButton(isShow: isShowUserId)
        configurePasswordEyeButton(isShow: isShowPassword)
        userIdContainerView.layer.cornerRadius = 4
        passwordContainerView.layer.cornerRadius = 4
        loginButton.layer.cornerRadius = 4
        //        customerIDTextField.addShadoww(placeHolderText: "User ID")
        //        passwordTextField.addShadoww(placeHolderText: "Password")
        customerIDTextField.attributedPlaceholder = NSAttributedString(
            string: "User ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
        customerIDTextField.delegate = self
        passwordTextField.delegate = self
        customerIDTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        if(viewModel.logoutString == "logout") {
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.UserLoginID)
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.Date)
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.ponumber)
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.comment)
        }
        var db:DBHelper = DBHelper()
        self.viewModel.arrSuppliers = viewModel.db.readData()
        if(self.viewModel.arrSuppliers.count != 0) {
            let userId = UserDefaults.standard.object(forKey:  "UserLoginID") as? String ?? ""
            let loginId = UserDefaults.standard.object(forKey: UserDefaultsKeys.UserDefaultLoginID) as? String ?? ""
          
            if( userId != "") {
                UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(dashboardVC!, animated: false)
            } else if (userId == "" && loginId != "" ) {
                let outLetController = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
                self.navigationController?.pushViewController(outLetController!, animated: false)
            }
        } else {
            let acm_Code = UserDefaults.standard.object(forKey: UserDefaultsKeys.acmLoginID) as? String ?? ""
            if (acm_Code != "") {
                let acmController = self.storyboard?.instantiateViewController(withIdentifier: "CustomerListViewController") as? CustomerListViewController
                self.navigationController?.pushViewController(acmController!, animated: false)
            }
        }
        

        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func configureUserEyeButton(isShow: Bool) {
        if isShow {
            userIdEyeButton.setImage(Icons.openEye, for: .normal)
            customerIDTextField.isSecureTextEntry = false
        } else {
            userIdEyeButton.setImage(Icons.closeEye, for: .normal)
            customerIDTextField.isSecureTextEntry = true
        }
    }
    
    private func configurePasswordEyeButton(isShow: Bool) {
        if isShow {
            passwordEyeButton.setImage(Icons.openEye, for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordEyeButton.setImage(Icons.closeEye, for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - Button Action
    @IBAction func loginButton(_ sender: UIButton) {
        viewModel.strCustomerID = customerIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.strPassword  = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let result = viewModel.validations() {
            self.presentPopUpVC(message: result, title: "")
        } else {
            self.view.endEditing(true)
            viewModel.strCustomerID = customerIDTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            viewModel.strPassword  = passwordTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            LocalStorage.clearItemsData()
            loginUser(with: viewModel.param())
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func accessAccount(_ sender: UIButton) {
        let createAnAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateAnAccountViewController") as? CreateAnAccountViewController
        self.navigationController?.pushViewController(createAnAccountVC!, animated: false)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let forgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPasswordVC!, animated: false)
    }
    
    
    @IBAction func userIdEyeButton(_ sender: UIButton) {
        isShowUserId = !isShowUserId
        configureUserEyeButton(isShow: isShowUserId)
    }
    
    @IBAction func passwordEyeButton(_ sender: UIButton) {
        isShowPassword = !isShowPassword
        configurePasswordEyeButton(isShow: isShowPassword)
    }
}

//MARK: - View_model Ineraction
extension LoginVC {
    //Login-User
    func loginUser(with param: [String: Any]) {
        viewModel.loginUser(with: param, view: self.view) { result in
            switch result {
            case .success(let login):
                if let login = login {
                    guard let status = login.status else { return }
                    if (status == 1) {
                        let outlets = login.outlets
                        UserDefaults.standard.set(outlets, forKey: "UserOutlets")
                        
                        if let loginType = login.login_type {
                            if loginType == "ACM" {
                                
                                let appName = login.data?.APP_COMPANY_NAME
                                let email = login.data?.email
                                let phone = login.data?.phone
                                let acm_code = login.data?.acm_code
                                let business_name = login.data?.business_name
                                UserDefaults.standard.set(business_name, forKey: UserDefaultsKeys.business_name)                                
                                UserDefaults.standard.set(appName, forKey: UserDefaultsKeys.AppName)
                                UserDefaults.standard.set(email, forKey: "email")
                                UserDefaults.standard.set(phone, forKey: "phone")
                                UserDefaults.standard.set(acm_code, forKey: UserDefaultsKeys.acmLoginID)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let nextVC = storyboard.instantiateViewController(withIdentifier: "CustomerListViewController") as? CustomerListViewController
                                self.navigationController?.pushViewController(nextVC!, animated: false)
                                
                                
                            } else {
                                self.customerIDTextField.text =  ""
                                let email = login.data?.email
                                let appName = login.data?.APP_COMPANY_NAME
                                let userCode = login.data?.user_code
                                let businessName = login.data?.business_name
                                let customerType = login.data?.customer_type
                                let outlets = login.outlets
                                let strClientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                                UserDefaults.standard.set(outlets, forKey: "UserOutlets")
                                UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                                //UserDefaults.standard.set(userCode, forKey:UserDefaultsKeys.UserLoginID)
                                UserDefaults.standard.set(userCode, forKey: UserDefaultsKeys.UserDefaultLoginID)
                                UserDefaults.standard.set(businessName, forKey: "BusinessName")
                                UserDefaults.standard.set(appName, forKey: UserDefaultsKeys.AppName)
                                UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                                UserDefaults.standard.set(email, forKey: "email")
                                
                                self.userCode = userCode ?? ""
                                
                                if let outletNumber = login.outlets {
                                    self.noOfoutlets = outletNumber
                                }
                                self.sendPushNotificationRequest()
                                
                                if(self.viewModel.arrSuppliers.count == 0){
                                    self.viewModel.db.insert(strClientCode: strClientCode, strSupplierName: appName ?? "", strUserCode: userCode ?? "")
                                    self.viewModel.arrSuppliers = self.viewModel.db.readData()
                                } else {
                                    for i in 0..<self.viewModel.arrSuppliers.count {
                                        let strLocalSaveClientCode = self.viewModel.arrSuppliers[i]["client_code"]
                                        if(strLocalSaveClientCode as! String == strClientCode){
                                            self.viewModel.db.updateData(strClientCodee: strClientCode, strUserCode: userCode ?? "", strSupplierName: appName  ?? "")
                                        }
                                    }
                                }
                                
                                if(self.viewModel.db.isAlreadyInSupplier(strClientCodee: strClientCode)){
                                    
                                } else {
                                    self.viewModel.db.insert(strClientCode: strClientCode, strSupplierName: appName ?? "", strUserCode: userCode ?? "")
                                    self.viewModel.arrSuppliers = self.viewModel.db.readData()
                                }
                            }
                        }
                        

                    } else {
                        guard let messge = login.message else {return}
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
    
    //Send-Push-Notification-Request
    func sendPushNotificationRequest() {
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        
        var orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
        
        if(orderFlag == ""){
            orderFlag = "0"
        }
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String ?? ""
        let deviceID = UserDefaults.standard.object(forKey: "DeviceIdentifier") as? String ?? ""
        let fcmToken = UserDefaults.standard.object(forKey: "PushToken") as? String ?? ""
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        var dictParam = [String:Any]()
        dictParam = [
            GetPushNotification.type.rawValue:KeyConstants.appType ,
            GetPushNotification.app_type.rawValue:KeyConstants.app_Type,
            GetPushNotification.client_code.rawValue:KeyConstants.clientCode,
            GetPushNotification.user_code.rawValue:userID ,
            GetPushNotification.device_id.rawValue:Constants.deviceId,
            GetPushNotification.device_type.rawValue:"FI",
            GetPushNotification.device_token.rawValue:fcmToken,
            GetPushNotification.device_model.rawValue:Constants.deviceName,
            GetPushNotification.device_ip_address.rawValue:Constants.deviceIP
        ]
        self.getPushNotification(with: dictParam)
    }
    
    //Get-Push-Notification
    private func getPushNotification(with param: [String: Any]) {
        viewModel.getPushNotification(with: param) { result in
            switch result{
            case .success(let getPushNotificationData):
                if let getPushNotificationData = getPushNotificationData {
                    guard let result = getPushNotificationData.result else { return }
                    if (result == 1) {
                        self.callSaveCart()
                        //                        if(self.noOfoutlets == 0) {
                        //                            UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                        //                            let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                        //                            dashboardVC?.selectedTabIndex = 0
                        //                            self.navigationController?.pushViewController(dashboardVC!, animated: false)
                        //                        } else {
                        //                            let outLetController = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
                        //                            self.navigationController?.pushViewController(outLetController!, animated: false)
                        //                        }
                    } else {
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
    
    //MARK: - Save Cart Items
    func callSaveCart() {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String
        let param = [SaveCartParam.user_code.rawValue: userCode,
                     SaveCartParam.client_code.rawValue: KeyConstants.clientCode,
                     SaveCartParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print(JSON(param))
        self.carartItemsList(with: param as [String : Any])
    }
    
    private func carartItemsList(with param: [String: Any]) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.cartItemsV3) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<HomeModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        WebService().load(resource: resource) { [self] result in
            switch result{
            case .success(let cartData):
                if let cartData = cartData {
                    guard let status = cartData.status else { return }
                    if (status == 1) {
                        LocalStorage.clearItemsData()
                        LocalStorage.clearMultiItemsData()
                        if let cartData = cartData.data {
                            if let allInventories = cartData.allInventories {
                                if allInventories.count > 0 {
                                    LocalStorage.saveItemsData(data: allInventories)
                                }
                            }
                            if let multi_items = cartData.multi_items {
                                if multi_items.count > 0 {
                                    LocalStorage.saveMultiData(data: multi_items)                                    
                                }
                            }
                            let notificationCenter = NotificationCenter.default
                            notificationCenter.post(name: Notification.Name("cartSucess"), object: nil, userInfo: nil)
                        }
                        
                        if let currencySymbol = cartData.currency_symbol {
                            if(currencySymbol != ""){
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            } else {
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            }
                        }
                        
                        if let showPrice  = cartData.showPrice {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                        }
                        
                        if(self.noOfoutlets == 0) {
                            UserDefaults.standard.set(userCode, forKey:UserDefaultsKeys.UserLoginID)
                            UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                            let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            // dashboardVC?.selectedTabIndex = 0
                            self.navigationController?.pushViewController(dashboardVC!, animated: false)
                        } else {
                            let outLetController = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
                            self.navigationController?.pushViewController(outLetController!, animated: false)
                        }
                    } else {
                    }
                }
            case .failure(let error):
                print("error")
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == customerIDTextField) {
            passwordTextField.becomeFirstResponder()
        } else if(textField == passwordTextField) {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
