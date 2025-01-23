
//  Created by mac5 on 01/08/17.
//  Copyright © 2017 Braintechnosys pvt ltd. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties
    var isLogout: Bool = false
    var strFetauredImage = ""
    
    //MARK: - SIDE MENU
    var arrayItems = [[String: Any]]()
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var itemsForHeader = [String]()
    var logoutMessage: String?
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        registerCustomCell()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        titleLabel.text = appName
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
         
        dictParam = [
           GetFeaturedImage.client_code.rawValue:clientCode ,
            //GetFeaturedImage.client_code.rawValue:"develop" ,
            GetFeaturedImage.user_code.rawValue:userID ,
        ]
        self.getFeaturedImage(with: dictParam)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    // MARK: Helpers
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        setupHamburgerMenu()
        setupItems()
    }
    
    private func setupItems() {
        
        let authenticatedMenuItems = [
            ["name": "MY LAST 7 ORDERS"],
            ["name": "RESET MY LIST A-Z"],
            ["name": "MY ACCOUNT DETAILS"],
            ["name": "MANAGE SUPPLIERS"],
            ["name": "LINKS"],
            ["name": "APP USER GUIDE"]]
        
        arrayItems = authenticatedMenuItems
        tableView.reloadData()
    }
    
    private func setupHamburgerMenu() {
        self.findHamburguerViewController()?.gestureEnabled = false
        self.findHamburguerViewController()?.gestureRecognizer?.isEnabled = false
    }
    
    private func registerCustomCell() {
        
        tableView.register(UINib.init(nibName: "MenuHeader", bundle: nil), forCellReuseIdentifier: "MenuHeaderTableViewCell")
        tableView.register(UINib.init(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        tableView.register(UINib.init(nibName: "MenuFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuFooterTableViewCell")
    }
    
    //MARK: Logout API
    private func logout() {
        Constants.clearUserDefaults()
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        db.deleteByClientCode(strClientCode: clientCode)
        self.arrSuppliers = db.readData()
        if(arrSuppliers.count != 0){
      
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

            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            var hasViewController: Bool = false
            let nav :HamburguerNavigationController = self.mainNavigationController()
            let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            nav.setViewControllers([tbc], animated: false)
            hasViewController = true
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
        }else {
            var hasViewController: Bool = false
            let nav :HamburguerNavigationController = self.mainNavigationController()
            let tbc = storyboard?.instantiateViewController(withIdentifier: "SupplierIdViewController") as! SupplierIdViewController
            nav.setViewControllers([tbc], animated: false)
            hasViewController = true
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
        }
    }
    
    //MARK: Button Action
    @IBAction func backButton(_ sender: UIButton) {
        let isComingFromDAshBoard = UserDefaults.standard.object(forKey: "isComingFromDashboard") as? Bool ?? false
        if(isComingFromDAshBoard) {
            var hasViewController: Bool = false
            let nav :HamburguerNavigationController = self.mainNavigationController()
            hasViewController = true
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
            nav.setViewControllers([tbc], animated: false)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
            UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        }else {
            let hasViewController: Bool = false
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = self
                    }
                })
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        self.logout()
    }
    
    //MARK: - API INTEGRATION
    private func getFeaturedImage(with param: [String: Any]) {
        
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getFeaturedItem) else { fatalError("URL is incorrect.") }
        
  
        print(url)
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<FeaturedImageModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
//        DispatchQueue.main.async { self.showIndicator() }
        WebService().load(resource: resource) { result in
            
//            DispatchQueue.main.async { self.hideIndicator() }
            
            switch result{
            case .success(let featuredImageData):
                if let featuredImageData = featuredImageData {
                    
                    guard let status = featuredImageData.status else { return }
                    
                    if (status == 1) {
                        if let featuredImage = featuredImageData.featured_item_image {
                            if(featuredImage != ""){
                                self.strFetauredImage = featuredImage
                                self.tableView.reloadData()
                            }
                        }
                      
                 
                    } else if(status == 2) {
                   
                    }
                    else {
             
                    }
                    
                }
            case .failure(let error):
                if(error == .networkError) {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                    }
                  
                }else  {
//                    DispatchQueue.main.async {
//                        self.presentPopUpVC(message: serverNotResponding, title: "")
//                    }
                 
                }
            }
        }
    }
}

extension SideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav :HamburguerNavigationController = self.mainNavigationController()
        var hasViewController: Bool = false
        
        if indexPath.row == 0 {
            hasViewController = true
            self.isLogout = false
            let tbc = storyboard?.instantiateViewController(withIdentifier: "LastOrdersViewController") as! LastOrdersViewController
            nav.setViewControllers([tbc], animated: false)
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
            let tbc = storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
            tbc.viewModel.isResetList = true
            nav.setViewControllers([tbc], animated: false)
            hasViewController = true
            self.isLogout = false
        } else if indexPath.row == 2 {
            hasViewController = true
            self.isLogout = false
            let tbc = storyboard?.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
            nav.setViewControllers([tbc], animated: false)
        }
        else if indexPath.row == 3 {
            
        hasViewController = true
        let tbc = storyboard?.instantiateViewController(withIdentifier: "ManageSupplierViewController") as!  ManageSupplierViewController
        nav.setViewControllers([tbc], animated: false)
        }
            else if indexPath.row == 4 {
                
            hasViewController = true
            let tbc = storyboard?.instantiateViewController(withIdentifier: "LinksViewController") as! LinksViewController
            nav.setViewControllers([tbc], animated: false)
        }else if indexPath.row == 5 {
            hasViewController = true
            let tbc = storyboard?.instantiateViewController(withIdentifier: "AppInformationViewController") as! AppInformationViewController
            tbc.viewModel.comingFrom = "AppInformation"
            nav.setViewControllers([tbc], animated: false)
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

extension SideMenuVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.configureUI(with: arrayItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderTableViewCell") as! MenuHeaderTableViewCell
        let nav :HamburguerNavigationController = self.mainNavigationController()
        var hasViewController: Bool = false
        if(strFetauredImage != "") {
            if let url = strFetauredImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                strFetauredImage = url
                if let url = URL(string: strFetauredImage) {
                    //header.featuredImageView?.kf.setImage(with: url)
                    header.featuredImageView?.sd_setImage(with: url, placeholderImage: nil)
                }
            }
        }
    
      
        header.didClickFeaturedButton = {
            hasViewController = true
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "AppInformationViewController") as! AppInformationViewController
            tbc.viewModel.comingFrom = "FeaturedProduct"
            nav.setViewControllers([tbc], animated: false)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
            
        }
        
        header.didClickMyProductButton = {
            hasViewController = true
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
            nav.setViewControllers([tbc], animated: false)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
        }
        
        header.didClickSearchProductButton = {
            hasViewController = true
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            nav.setViewControllers([tbc], animated: false)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
            
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableCell(withIdentifier: "MenuFooterTableViewCell") as! MenuFooterTableViewCell
        footer.btnOpenUrl = {
            self.openURl(url: "https://www.quickb2b.com/")
        }
        return footer
    }
    
    //MARK:- OPEN URL FUNCTION
    
    private func openURl(url:String) {
        guard let url = URL(string: url) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    
  
    }
    

