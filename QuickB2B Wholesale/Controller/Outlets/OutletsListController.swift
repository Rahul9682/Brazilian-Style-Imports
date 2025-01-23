//  OutletsListController.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/27/21.

import UIKit
import SwiftyJSON

class OutletsListController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var outletsListTableView: UITableView!
    @IBOutlet var staticLabelText: UILabel!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    
    
    //MARK: - Properties
    var viewModel = OutletsListViewModel()
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        labelContainerView.backgroundColor = UIColor.clear
        topContainerView.backgroundColor = UIColor.clear
        configureViewDidLoad()
        self.getOutletsList(with: viewModel.param())
        registerCustomCell()
    }
    
    //MARK: - Helpers
    func configureViewDidLoad(){
        staticLabelText.isHidden = true
        outletsListTableView.delegate = self
        outletsListTableView.dataSource = self
    }
    
    func configureUI() {
        if(self.viewModel.arrOutletsListData.count == 0){
            self.goToDashBoard()
        } else if(self.viewModel.arrOutletsListData.count == 1) {
            if let userId = self.viewModel.arrOutletsListData[0].user_code {
                UserDefaults.standard.set(userId, forKey:UserDefaultsKeys.UserLoginID)
                self.goToDashBoard()
            }
        } else {
            staticLabelText.isHidden = false
            let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
            appNameLabel.text = appName
            outletsListTableView.reloadData()
        }
    }
    
    //Register Cell
    func registerCustomCell(){
        outletsListTableView.register(UINib.init(nibName: "OutletsTableViewCell", bundle: nil), forCellReuseIdentifier: "OutletsTableViewCell")
    }
    
    //MARK: - GO TO DASHBOARD
    func goToDashBoard() {
        sendPushNotificationRequest()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension OutletsListController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrOutletsListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = outletsListTableView.dequeueReusableCell(withIdentifier: "OutletsTableViewCell") as? OutletsTableViewCell
        cell?.configureArrowImageUI(isShow: true, image: "arrow_right")
        
        if let outletName = self.viewModel.arrOutletsListData[indexPath.row].name {
            cell?.outletNameLabel.text = outletName
        }
        
        if indexPath.row == 0 {
            cell?.outletNameLabel.textColor = UIColor(red: 40.0/255.0, green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        } else {
            cell?.outletNameLabel.textColor = UIColor.black
        }
        
        if (indexPath.row % 2 == 0) {
            cell?.contentView.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)

        } else {
            cell?.contentView.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)

        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userId = self.viewModel.arrOutletsListData[indexPath.row].user_code {
            self.viewModel.arrOutletsListData[indexPath.row].isSelected = true
            UserDefaults.standard.set(userId, forKey:UserDefaultsKeys.UserLoginID)
            //self.goToDashBoard()
            self.sendPushNotificationRequest()
        }
    }
}

//MARK: - view-Model-Interaction
extension OutletsListController {
    private func getOutletsList(with param: [String: Any]) {
        viewModel.getOutletsList(with: param, view: self.view) { result in
            switch result{
            case .success(let getOutletListData):
                if let getOutletListData = getOutletListData {
                    DispatchQueue.main.async {
                        self.labelContainerView.backgroundColor = UIColor.white
                        self.topContainerView.backgroundColor = UIColor.white
                    }
                    guard let status = getOutletListData.status else { return }
                    if (status == 1) {
                        if let data = getOutletListData.data {
                            self.viewModel.arrOutletsListData = data
                        }
                        self.configureUI()
                    } else {
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: serverNotResponding, title: "")
                    }
                }
            case .none:
                break
            }
        }
    }
    
    //Get-Push-Notification Basically for update user device
    private func getPushNotification(with param: [String: Any]) {
        viewModel.getPushNotification(with: param) { result in
            switch result{
            case .success(let getPushNotificationData):
                if let getPushNotificationData = getPushNotificationData {
                    guard let result = getPushNotificationData.result else { return }
                    if (result == 1) {
                        self.callSaveCart()
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
    
    //Send-Push-Notification-Request Basically for update user device
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
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        let deviceID = UserDefaults.standard.object(forKey: "DeviceIdentifier") as? String ?? ""
        let fcmToken = UserDefaults.standard.object(forKey: "PushToken") as? String ?? ""
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        var dictParam = [String:Any]()
        dictParam = [
            GetPushNotification.type.rawValue:KeyConstants.appType ,
            GetPushNotification.app_type.rawValue:KeyConstants.app_Type,
            GetPushNotification.client_code.rawValue:KeyConstants.clientCode ,
            GetPushNotification.user_code.rawValue:userID ,
            GetPushNotification.device_id.rawValue:Constants.deviceId,
            GetPushNotification.device_type.rawValue:"FI",
            GetPushNotification.device_token.rawValue:fcmToken,
            GetPushNotification.device_model.rawValue:Constants.deviceName,
            GetPushNotification.device_ip_address.rawValue:Constants.deviceIP
        ]
        self.getPushNotification(with: dictParam)
    }
    
    //MARK: - Save Cart Items
    func callSaveCart() {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
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
                    
                        UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                        let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                        //dashboardVC?.selectedTabIndex = 0
                        if let index = self.viewModel.arrOutletsListData.firstIndex(where: { $0.isSelected == true }) {
                            let item = self.viewModel.arrOutletsListData.remove(at: index)
                            self.viewModel.arrOutletsListData.insert(item, at: 0)
                        }
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.outletsListData)
                        LocalStorage.saveOutletsListData(data: self.viewModel.arrOutletsListData)
                        self.navigationController?.pushViewController(dashboardVC!, animated: false)
                       
                        
                    } else {
                    }
                }
            case .failure(let error):
                print("error")
            }
        }
    }
}
