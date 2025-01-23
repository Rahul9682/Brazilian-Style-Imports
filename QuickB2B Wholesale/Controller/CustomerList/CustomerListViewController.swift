//
//  CustomerListViewController.swift
//  QuickB2B
//
//  Created by Braintech on 21/10/24.
//

import UIKit
import SwiftyJSON

class CustomerListViewController: UIViewController, PopUpDelegate {
   
    
    
    //MARK: - Outlet's
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backgroundView: BackgroundView!
    
    
    @IBOutlet weak var crossView: UIView!
    
    //MARK: - Properties
    var viewModel = CustomerListViewModel()
    var arrCustomerList: [CustomerDetails] = []
    var  userCode = ""
    var noOfoutlets = UserDefaults.standard.integer(forKey: "UserOutlets")
    var background: BackgroundView?
    let acmCode = UserDefaults.standard.string(forKey:  UserDefaultsKeys.acmLoginID) ?? ""
    
    //MARK: - Life-Cycle-Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        confiqureUI()
        registerCell()
        getCustomerList(param: ["client_code": KeyConstants.clientCode, "acm_code": acmCode ,"search":"",login.device_id.rawValue:Constants.deviceId])
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        confiqureUI()
        registerCell()
        getCustomerList(param: ["client_code": KeyConstants.clientCode, "acm_code": acmCode ,"search":"",login.device_id.rawValue:Constants.deviceId])
        searchTextField.delegate = self
    }
    
    //MARK: - Helpers
    func confiqureUI(){
        searchBarView.layer.cornerRadius = Radius.searchViewRadius
        searchBarView.layer.borderWidth = Radius.searchViewborderWidth
        searchBarView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        appNameLabel.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.AppName)
        crossView.isHidden = true
       

    }
    
    func registerCell(){
        self.tableView.register(UINib(nibName: "CustomerListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerListTableViewCell")
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    private func configureBackgroundList(with image: UIImage?, message: String, count: Int) {
        DispatchQueue.main.async { [self] in
            if count == 0 {
                if self.background == nil {
                    self.background = Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)?.first as? BackgroundView
                    self.background?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.background?.frame = self.backgroundView.bounds
                    self.background?.configureUI(with: image, message: message)
                }
                background?.refreshButton.isHidden = true//false
                tableView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                tableView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                self.tableView.reloadData()
            }
            
           
        }
    }
    
    
    //MARK: - Button Actions
    @IBAction func searchBarCancelAction(_ sender: Any) {
        self.view.endEditing(true)
        crossView.isHidden = true
        searchTextField.text = ""
        getCustomerList(param: ["client_code": KeyConstants.clientCode, "acm_code": acmCode,"search":"",login.device_id.rawValue:Constants.deviceId])
    }
    
    
    @IBAction func addCustomerAction(_ sender: Any) {
        let createAnAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCustomerViewController") as? AddCustomerViewController
        self.navigationController?.pushViewController(createAnAccountVC!, animated: false)
    }
    
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CustomerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCustomerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerListTableViewCell", for: indexPath) as! CustomerListTableViewCell
        cell.custmerName.text = ""
        cell.customerCode.text = "\(arrCustomerList[indexPath.row].businessName ?? "") - \(arrCustomerList[indexPath.row].deliverySuburb ?? "")"
        cell.email.text = "\(arrCustomerList[indexPath.row].email ?? "")"
        if arrCustomerList[indexPath.row].isManager == 1 {
            cell.custmerName.textColor = hexStringToUIColor(hex: "2497A0")
            cell.customerCode.textColor = hexStringToUIColor(hex: "2497A0")
        } else {
            cell.custmerName.textColor = .black
            cell.customerCode.textColor = .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did selected")
        getCustomerDetails(param: ["client_code": KeyConstants.clientCode, "acm_code": acmCode, "user_code": arrCustomerList[indexPath.row].customerCode ?? "",login.device_id.rawValue:Constants.deviceId])
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55
//    }
    
    func presentPopUpWithDelegate(strMessage:String,buttonTitle:String) {
        DispatchQueue.main.async {
            guard   let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
            vc.strMessage = strMessage
            vc.buttonTitle = buttonTitle
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func didTapDone() {
        logout()
        
        
    }
    
    func logout() {
        Constants.clearUserDefaults()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(tbc, animated: false)
    }
    
    
}
//MARK: - API Calling
extension CustomerListViewController {
    func getCustomerList (param: [String: String]) {
        viewModel.getCustomerListing(with: param, view: self.view, completionHandler: { result in
            switch result {
            case .success(let response):
                if let status = response?.status {
                    if status == 1 {
                        if let data = response?.data {
                            if data.count == 0 {
                                self.configureBackgroundList(with: Icons.noDataFound, message: "", count: 0)
                            } else {
                                self.configureBackgroundList(with: UIImage(), message: "", count: data.count)
                                self.arrCustomerList = data
                                self.tableView.reloadData()
                            }
                           
                        }
                    } else if status == 2 {
                        guard let messge = response?.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                  
                }
              
                
            case .failure(let error):
                self.configureBackgroundList(with: Icons.noDataFound, message: "", count: 0)
            case .none:
                self.configureBackgroundList(with: Icons.noDataFound, message: "", count: 0)
            }
        })
    }
    
    func getCustomerDetails (param: [String: String]) {
        viewModel.getCustomerDetails(with: param, view: self.view, completionHandler: { result in
            switch result {
            case .success(let response):
                if let response = response {
                    if let status = response.status, let outLet = response.outlets {
                        UserDefaults.standard.set(outLet, forKey: "UserOutlets")
                        
                        if status == 1 {
                            if let data = response.data {
                                let email = data.email
                                let appName = data.appCompanyName
                                let userCode = data.userCode
                                let businessName = data.businessName
                                let customerType = data.customerType
                                
                                let strClientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                                // UserDefaults.standard.set(outlets, forKey: "UserOutlets")
                                UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                                UserDefaults.standard.set(userCode, forKey:UserDefaultsKeys.UserLoginID)
                                UserDefaults.standard.set(userCode, forKey: UserDefaultsKeys.UserDefaultLoginID)
                                UserDefaults.standard.set(businessName, forKey: "BusinessName")
                                UserDefaults.standard.set(appName, forKey: UserDefaultsKeys.AppName)
                                UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                                UserDefaults.standard.set(email, forKey: "email")
                                
                                self.userCode = userCode ?? ""
                                
                                //                     if let outletNumber = login.outlets {
                                //                         self.noOfoutlets = outletNumber
                                //                     }
                                self.sendPushNotificationRequest()
                                
                                if(self.viewModel.arrSuppliers.count == 0) {
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
                        } else if status == 0 {
                            print()
                        }
                    }
                }
            case .failure(let error):
                print(error)
            case .none:
                print("")
            }
        })
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
            
                        noOfoutlets = UserDefaults.standard.integer(forKey: "UserOutlets")
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

extension CustomerListViewController: UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            crossView.isHidden = true
        } else {
            crossView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            crossView.isHidden = true
        } else {
            crossView.isHidden = false
        }
        getCustomerList(param: ["client_code": KeyConstants.clientCode, "acm_code": acmCode,"search": "\(textField.text ?? "")", login.device_id.rawValue:Constants.deviceId])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
      //  getCustomerList(param: ["client_code": KeyConstants.clientCode, "acm_code": "","search": "\(textField.text ?? "")"])
    }
}
