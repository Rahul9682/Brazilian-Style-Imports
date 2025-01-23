//  SideMenuViewController.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 16/06/23.

import UIKit
import SDWebImage
//import BSImagePicker
import Alamofire

class SideMenuViewController: UIViewController {
    
    //MARK: -> Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentVersionLabel: SemiBoldLabelSize14!
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    @IBOutlet weak var manuHeaderContainerView: UIView!
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var userNameLabel: RegularLabelSize14!
    
    @IBOutlet weak var emailLabel: RegularLabelSize14!
    
    
    //MARK: -> Properties
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var arrayOfProfileMenus = [[[String: Any]]]()
    var logoutMessage: String?
    var isLogin: Bool = false
    
    //MARK: -> Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }

    override func viewDidLayoutSubviews() {}
    
    //MARK: -> Helpers
    private func configureUI() {
        manuHeaderContainerView.backgroundColor = UIColor.init(red: 212.0/255, green: 235.0/255, blue: 242.0/255, alpha: 0.8)
        
        headerContainerView.backgroundColor = UIColor.init(red: 212.0/255, green: 235.0/255, blue: 242.0/255, alpha: 0.8)
        self.arrSuppliers = db.readData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        setupItems()
        self.tableView.reloadData()
        let email = UserDefaults.standard.value(forKey: "email") as? String
        let businessName = UserDefaults.standard.value(forKey: "BusinessName") as? String
        userNameLabel.text = businessName
        emailLabel.text = email
//        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            currentVersionLabel.text = "App Version: " + appVersion
//        }
        currentVersionLabel.text = "Developed by QuickB2B"
    }
    
    private func clearSDImageCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
    }
    
    private func setupItems() {
//        arrayOfProfileMenus = [
//            ["name": "Featured Items", "image": "ic_flag"],
//            ["name": "My Last 7 Order", "image": "ic_last_order"],
//            ["name": "Reset My List A-Z", "image": "ic_reset"],
//            ["name": "My Account Details", "image": "ic_account"],
//            ["name": "Manage Suppliers", "image": "ic_manage_supplier"],
//            ["name": "Links", "image": "ic_link"],
//            ["name": "App User Guide", "image": "ic_user_guide"]
//        ]
        
        arrayOfProfileMenus = [
            [  ["name": "Featured Items", "image": "ic_flag"],
               ["name": "My Last 7 Order", "image": "ic_last_order"],
               ["name": "Reset My List A-Z", "image": "ic_reset"],
            ],
            [
                ["name": "My Account Details", "image": "ic_account"],
                ["name": "Manage Suppliers", "image": "ic_manage_supplier"],
                ["name": "Links", "image": "ic_link"],
                ["name": "App User Guide", "image": "ic_user_guide"],
            ]
        ]
        
        
    }
    
    private func registerCustomCell() {
        tableView.register(UINib.init(nibName: "MenuV3Cell", bundle: nil), forCellReuseIdentifier: "MenuV3Cell")
        tableView.register(UINib.init(nibName: "MenuV3Header", bundle: nil), forCellReuseIdentifier: "MenuV3Header")
        tableView.register(UINib.init(nibName: "MenuV3FooterCell", bundle: nil), forCellReuseIdentifier: "MenuV3FooterCell")
    }
    
    //MARK: -> Show Logout Alert Method
    func showLogoutAlert(on vc: UIViewController, with title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
            let activeViewCont = navigationController?.visibleViewController
            activeViewCont?.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Logout Method
    func logout() {
//        self.userLogout { data, error in
//            if let data = data {
//                if let status = data.status {
//                    if status == 1 {
//                        Constants.resetUserDefaultsData()
//                        var hasViewController: Bool = false
//                        let nav :HamburguerNavigationController = self.mainNavigationController()
//                        let storyBoard = UIStoryboard(name: Storyboard.dashboardStoryboard, bundle: nil)
//                        let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//                        nav.setViewControllers([vc], animated: false)
//                        hasViewController = true
//                        if let hamburguerViewController = self.findHamburguerViewController() {
//                            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
//                                if hasViewController {
//                                    hamburguerViewController.contentViewController = nav
//                                }
//                            })
//                        }
//                    } else {
//                        self.showToast(message: error, toastType: .error)
//                    }
//                }
//            } else {
//                self.showToast(message: error, toastType: .error)
//            }
//
//        }
        
    }
    
    //MARK: -> APIs
    private func userLogout(with param: [String: Any]) {
       // self.logout()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion {
            self.dismiss(animated: false)
        }
    }
}

//MARK: -> TableView Delegate
extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nav :HamburguerNavigationController = self.mainNavigationController()
        var hasViewController: Bool = false
        var isLogout: Bool = false
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            //Featured-Item
            hasViewController = true
            hasViewController = true
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "AppInformationViewController") as! AppInformationViewController
            tbc.specialTitle = "Featured ITEMS"
            tbc.viewModel.comingFrom = "FeaturedProduct"
            nav.setViewControllers([tbc], animated: false)
        } else if indexPath.row == 1 {
            //About_US
            hasViewController = true
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "LastOrdersViewController") as! LastOrdersViewController
            nav.setViewControllers([tbc], animated: false)
            print(indexPath.row)
        } else if indexPath.row == 2 {
            //Reset-List
            print("Reset List")
            hasViewController = true
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            UserDefaults.standard.set(true, forKey: "isResetList")
            let tbc = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            tbc.selectedTabIndex = 1
            //tbc.viewModel.isResetList = true
            nav.setViewControllers([tbc], animated: false)
        }
    }
        else if indexPath.section == 1 {
             if indexPath.row == 0 {
                hasViewController = true
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tbc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
                nav.setViewControllers([tbc], animated: false)
                print(indexPath.row)
            } else if indexPath.row == 1 {
                //About_US
                hasViewController = true
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tbc = storyBoard.instantiateViewController(withIdentifier: "ManageSupplierViewController") as! ManageSupplierViewController
                nav.setViewControllers([tbc], animated: false)
                print(indexPath.row)
            } else if indexPath.row == 2 {
                //About_US
                hasViewController = true
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tbc = storyBoard.instantiateViewController(withIdentifier: "LinksViewController") as! LinksViewController
                nav.setViewControllers([tbc], animated: false)
                print(indexPath.row)
            } else if indexPath.row == 3 {
                //About_US
                hasViewController = true
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tbc = storyBoard.instantiateViewController(withIdentifier: "AppInformationViewController") as! AppInformationViewController
                tbc.viewModel.comingFrom = "AppInformation"
                tbc.specialTitle = "APP USER GUIDE"
                nav.setViewControllers([tbc], animated: false)
                print(indexPath.row)
            }
        }
        if !isLogout {
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
        }
    }
}

//MARK: - TableView DataSource
extension SideMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrayOfProfileMenus[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuV3Cell", for: indexPath) as! MenuV3Cell
        cell.logoutButton.isEnabled = false
        cell.isUserInteractionEnabled = true
        cell.configureUI(with: arrayOfProfileMenus[indexPath.section][indexPath.row], with: indexPath.section, index: indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius = 12
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
//            guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MenuV3Cell") as? MenuV3Cell else {return nil}
//            cell.containerViewLeadingConst.constant = 0
//            cell.logoutButton.isEnabled = true
//            cell.isUserInteractionEnabled = true
//            cell.configureUI(with:["name": "Logout", "image": "logout"] , with: 0, index: section)
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MenuV3FooterCell") as? MenuV3FooterCell else {return nil}
            
            cell.logoutLabel.textColor = UIColor.red
            cell.didClickLogoutButton = {
                self.showLogoutAlert(on: self, with: "", message: "Are You Sure to logout?") { alert in
                    self.isLogin = false
                    //Constants.resetUserDefaultsData()
                    var hasViewController: Bool = false
                    let nav :HamburguerNavigationController = self.mainNavigationController()
                    //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    //                let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    // nav.setViewControllers([vc], animated: false)
                    hasViewController = true
                    Constants.clearUserDefaults()
                    
                    let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                    self.db.deleteByClientCode(strClientCode: clientCode)
                    self.arrSuppliers = self.db.readData()
                    self.db.deleteByClientCode(strClientCode: clientCode)
                    if(self.arrSuppliers.count != 0){
                        
                        if let strAppName = self.arrSuppliers[0]["supplier_name"]{
                            UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
                        }
                        if let strClientCode = self.arrSuppliers[0]["client_code"]{
                            UserDefaults.standard.set(strClientCode, forKey: "ClientCode")
                        }
                        if let strUserLoginId = self.arrSuppliers[0]["user_code"]{
                            UserDefaults.standard.set(strUserLoginId, forKey:UserDefaultsKeys.UserLoginID)
                        }
                        if let strUserLoginId = self.arrSuppliers[0]["user_code"]{
                            UserDefaults.standard.set(strUserLoginId, forKey:UserDefaultsKeys.UserDefaultLoginID)
                        }
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        UserDefaults.standard.set("produceList", forKey: "isCheckView")
                        let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
                        self.navigationController?.pushViewController(tbc, animated: false)
                    } else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let tbc = storyBoard.instantiateViewController(withIdentifier: "SupplierIdViewController") as! SupplierIdViewController
                        //  self.navigationController?.pushViewController(tbc, animated: false)
                        nav.setViewControllers([tbc], animated: false)
                    }
                    
                    if let hamburguerViewController = self.findHamburguerViewController() {
                        hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                            if hasViewController {
                                hamburguerViewController.contentViewController = nav
                            }
                        })
                    }
                }
            }
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 54
            
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

//MARK: - Custom Delegate
//extension SideMenuViewController: DelegateSuccess {
//    func success(with success: Bool) {
//        if(success) {
//            let nav :HamburguerNavigationController = self.mainNavigationController()
//            var hasViewController: Bool = false
//            let isLogout: Bool = false
//            hasViewController = true
//            let tbc = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//            nav.setViewControllers([tbc], animated: false)
//            if !isLogout {
//                if let hamburguerViewController = self.findHamburguerViewController() {
//                    hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
//                        if hasViewController {
//                            hamburguerViewController.contentViewController = nav
//                        }
//                    })
//                }
//            }
//        }
//    }
//}

//MARK: -> Api Call
//extension SideMenuViewController {
//    func userLogout(with completionHandler: @escaping ((SuccessModel?, String?) -> ())) {
//        guard let url = URL(string: AppUrls.baseUrl + AppUrls.logout) else { fatalError("URL is incorrect.") }
//        print(url)
//        var resource = Resource<SuccessModel?>(url: url)
//        resource.httpMethods = .post
//
//        DispatchQueue.main.async { Spinner.start() }
//        WebService().load(resource: resource) { result, jsonData in
//
//            DispatchQueue.main.async { Spinner.stop() }
//
//            switch result {
//            case .success(let data):
//                if let data = data {
//                    completionHandler(data, nil)
//                }
//            case .failure(let error):
//                let error = error.get()
//                completionHandler(nil, error)
//            }
//        }
//    }
//}

