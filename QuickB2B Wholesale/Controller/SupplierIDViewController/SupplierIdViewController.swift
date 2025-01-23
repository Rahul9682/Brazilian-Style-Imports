//  SupplierIdViewController.swift
//  QuickB2BWholesale
//  Created by braintech on 20/07/21.

import UIKit
import SwiftyJSON

class SupplierIdViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var supplierIDTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Properties
    var viewModel = SupplierIdViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        //self.navigationController?.pushViewController(loginVC!, animated: false)
        backButton.isHidden = true
        supplierIDTextField.addShadoww(placeHolderText: "enter supplier id")
        self.viewModel.arrSuppliers = viewModel.db.readData()

        if let userId = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String {
            if(viewModel.logoutString == "addSupplier"){
                backButton.isHidden = false
            } else if(viewModel.logoutString == "logout") {
                UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.UserLoginID)
                UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.Date)
                UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.ponumber)
                UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.comment)
                
                if(viewModel.arrSuppliers.count != 0){
                    if let strAppName = self.viewModel.arrSuppliers[0]["supplier_name"]{
                        UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
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
                }
                
                if(self.viewModel.arrSuppliers.count != 0){
                    let userId = UserDefaults.standard.object(forKey:  "UserLoginID") as? String ?? ""
                    if( userId != ""){
                        UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                        let noOfOutlets = UserDefaults.standard.object(forKey: "UserOutlets") as? Int ?? 0
                        if(noOfOutlets == 0) {
                            //let dashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController
                            //self.navigationController?.pushViewController(dashBoardVC!, animated: false)
                            UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                            let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            self.navigationController?.pushViewController(dashboardVC!, animated: false)
                        } else {
                            let outletsListVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
                            self.navigationController?.pushViewController(outletsListVC!, animated: false)
                        }
                    }
                }
            } else {
                if(self.viewModel.arrSuppliers.count != 0){
                    let userId = UserDefaults.standard.object(forKey:  "UserLoginID") as? String ?? ""
                    if( userId != ""){
                        UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                        let noOfOutlets = UserDefaults.standard.object(forKey: "UserOutlets") as? Int ?? 0
                        if(noOfOutlets == 0){
                            //let dashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController
                            //self.navigationController?.pushViewController(dashBoardVC!, animated: false)
                            UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                            let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            self.navigationController?.pushViewController(dashboardVC!, animated: false)
                        }else {
                            let outletsListVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
                            self.navigationController?.pushViewController(outletsListVC!, animated: false)
                        }
                    }
                }
            }
        } else {
            var dictParam = [String:Any]()
            dictParam = [
                AppDetailsGeneric.type.rawValue:KeyConstants.appType ,
                AppDetailsGeneric.app_type.rawValue:KeyConstants.app_Type,
                // AppDetailsGeneric.client_code.rawValue:supplierIDTextField.text ?? "",
                AppDetailsGeneric.device_id.rawValue:Constants.deviceId,
                AppDetailsGeneric.client_code.rawValue: KeyConstants.clientCode
            ]
            self.getAppDetails2(with: dictParam)
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func continueButton(_ sender: Any) {
        //UserDefaults.standard.set("develop", forKey: "ClientCode")
        if(supplierIDTextField.text == "") {
            self.presentPopUpVC(message: "Please enter supplier id.", title: "")
        } else {
            var dictParam = [String:Any]()
            dictParam = [
                AppDetailsGeneric.type.rawValue:KeyConstants.appType ,
                AppDetailsGeneric.app_type.rawValue:KeyConstants.app_Type,
                AppDetailsGeneric.client_code.rawValue:supplierIDTextField.text ?? "",
                AppDetailsGeneric.device_id.rawValue:Constants.deviceId,
                //AppDetailsGeneric.client_code.rawValue:"develop"
            ]
            self.getAppDetails(with: dictParam)
        }
    }
    
    @IBAction func bacKButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageSupplierViewController") as? ManageSupplierViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}

//MARK: - View-Model Interaction
extension SupplierIdViewController {
    private func getAppDetails(with param: [String: Any]) {
        viewModel.getAppDetails(with: param, view: self.view) { result in
            switch result {
            case .success(let appDetails):
                if let appDetails = appDetails {
                    guard let status = appDetails.status else { return }
                    if (status == 1) {
                        if(self.viewModel.db.isAlreadyInSupplier(strClientCodee: self.supplierIDTextField.text ?? "")){
                            self.presentPopUpVC(message: "Supplier Id Already Exist", title: "")
                        } else {
                            if let isEnableRetailFeatured = appDetails.data?.ENABLE_RETAIL_FEATURE {
                                UserDefaults.standard.setValue(isEnableRetailFeatured, forKey: "ENABLE_RETAIL_FEATURE")
                            }
                            if let appName = appDetails.data?.APP_NAME {
                                //UserDefaults.standard.set(appName, forKey: UserDefaultsKeys.AppName)
                            }
                            UserDefaults.standard.set(self.supplierIDTextField.text, forKey: "ClientCode")
                            let supplierNameViewController = self.storyboard?.instantiateViewController(withIdentifier: "SupplierNameViewController") as? SupplierNameViewController
                            if(self.viewModel.logoutString == "addSupplier"){
                                supplierNameViewController?.logOutStr = "addSupplier"
                            } else if(self.viewModel.logoutString == "logout"){
                                supplierNameViewController?.logOutStr = "logout"
                            }
                            self.navigationController?.pushViewController(supplierNameViewController!, animated: false)
                        }
                    } else {
                        guard let messge = appDetails.message else {return}
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
    
    
    private func getAppDetails2(with param: [String: Any]) {
        viewModel.getAppDetails(with: param, view: self.view) { result in
            switch result {
            case .success(let appDetails):
                if let appDetails = appDetails {
                    guard let status = appDetails.status else { return }
                    if (status == 1) {
                        if(self.viewModel.db.isAlreadyInSupplier(strClientCodee: self.supplierIDTextField.text ?? "")){
                            self.presentPopUpVC(message: "Supplier Id Already Exist", title: "")
                        } else {
                            if let isEnableRetailFeatured = appDetails.data?.ENABLE_RETAIL_FEATURE {
                                UserDefaults.standard.setValue(isEnableRetailFeatured, forKey: "ENABLE_RETAIL_FEATURE")
                            }
                            if let appName = appDetails.data?.APP_NAME {
                                //UserDefaults.standard.set(appName, forKey: UserDefaultsKeys.AppName)
                            }
                            UserDefaults.standard.set(KeyConstants.clientCode, forKey: "ClientCode")
                            let supplierNameViewController = self.storyboard?.instantiateViewController(withIdentifier: "SupplierNameViewController") as? SupplierNameViewController
                            if(self.viewModel.logoutString == "addSupplier"){
                                supplierNameViewController?.logOutStr = "addSupplier"
                            } else if(self.viewModel.logoutString == "logout"){
                                supplierNameViewController?.logOutStr = "logout"
                            }
                            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                            if(self.viewModel.logoutString == "addSupplier"){
                                loginVC?.viewModel.logoutString = "addSupplier"
                            } else if(self.viewModel.logoutString ==  "logout"){
                                loginVC?.viewModel.logoutString = "logout"
                            }
                            self.navigationController?.pushViewController(loginVC!, animated: false)
                        }
                    } else {
                        guard let messge = appDetails.message else {return}
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
