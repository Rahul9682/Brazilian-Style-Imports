//  HomeViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import SwiftyJSON
import WebKit

class HomeViewController: UIViewController{
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var bannerTableView: UITableView!
    @IBOutlet weak var bannerTableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var outletsContainerView: UIView!
    @IBOutlet weak var outletsContainerWidthConst: NSLayoutConstraint!
    @IBOutlet weak var outletsContainerTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var OutletTableContainerView: UIView!
    @IBOutlet weak var outletsTableView: UITableView!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var totalCartItemsCount: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var outLetContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var outletHeaderLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var switchButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginUserNameLabel: UILabel!
    
    
    //MARK: -> Properties
    var viewModel = HomeViewModel()
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var dictData = [String:Any]()
    var arrUpdatedPriceQuantity = [[String:Any]]()
    var arrayOfUpdatedSpecialItems =  [SpecialItems]()
    var index = 0
    var listingType:ProductListingType = .none
    var showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
    var featuredheight: CGFloat = 675
    var isReload: Bool = false
    var didFinsh: Bool = false
    private var indicator: UIActivityIndicatorView!
    var tabType: TabType = .home
    var isChangedQuantity: Bool = false
    var isShowOutletsTable: Bool = false
    var arrayOfOutletsListData = [GetOutletsListData]()
    var isEnableForceUpdate:Bool = true
    var updateType:String = ""
    var appstoreVersion = ""
    var updateAlertMessage = ""
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    var acmCode  = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID)
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = "Total $0.00"
        configureUI()
        registerCell()
        configureTabBar()
        addCartSuccesObserver()
        //getHomeData()
        // updateTotaPrice()
        //configureNavigation()
        //self.showFeaturedPopUp()
        // Add observer for when the app enters background
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Add observer for when the app is about to terminate
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        self.viewModel.arrayOfLocalStorageItems = LocalStorage.getItemsData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.tableViewHeightConstraint.constant = CGFloat(LocalStorage.getOutletsListData().count * 38)
        self.OutletTableContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        self.OutletTableContainerView.layer.borderWidth = Radius.searchViewborderWidth
        // self.outLetContainerViewHeightConstraint.constant = CGFloat(LocalStorage.getOutletsListData().count * 38 + 90 )
        self.OutletTableContainerView.layer.cornerRadius = Radius.searchViewRadius
        if let business_name = UserDefaults.standard.string(forKey: "BusinessName") {
            UserNameLabel.text = business_name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                updateTotaPrice()
                appNameStackView.distribution = .fillEqually
            } else {
                appNameStackView.distribution = .fill
            }
        } else {
            appNameStackView.distribution = .fillEqually
        }
        self.tableView.isHidden = true
        let outLet =  UserDefaults.standard.integer(forKey: "UserOutlets")
        if outLet > 0 {
            self.configureOutletsView(noOfOutltes: LocalStorage.getOutletsListData().count)
            if let acmCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID) {
                loginUserNameLabel.isHidden = false
                switchButton.isHidden = false
                switchButtonHeightConstraint.constant = 30
            } else {
                loginUserNameLabel.isHidden = true
                switchButton.isHidden = true
                switchButtonHeightConstraint.constant = 0
            }
            outletHeaderLabel.isHidden = false
          
        } else {
            if let acmCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID) {
                self.configureOutletsView(noOfOutltes: 1)
            } else {
                outletsContainerView.isHidden = true
                outletsContainerWidthConst.constant = 0
               outletsContainerTrailingConst.constant = 0
                outletHeaderLabel.isHidden = true
            }
            outletHeaderLabel.isHidden = true
        }
       // self.configureOutletsView(noOfOutltes: 1)
        
        addObserver()
        getHomeData()
        updateTotaPrice()
        didEnterBackgroundObserver()
        configureCartImage()
    }
    
    
    @objc func appWillEnterBackground() {
        print("App is entering background")
         callUpdateInventory()
    }

    @objc func appWillTerminate() {
        print("App is about to terminate")
        callUpdateInventory()
    }
    
    
    func callUpdateInventory() {
        // Your viewWillDisappear logic here
        self.view.endEditing(true)
        removeObserver()
        removeCartSuccesObserver()
        viewModel.isMenuButtonSelected = true
        if isChangedQuantity {
            DispatchQueue.main.async {
                self.sendRequestUpdateUserProductList()
            }
        }
        self.isChangedQuantity = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabbarView.bounds
        tabBar?.configureTabUI(with: tabType)
        tabBar?.didClickHomeButton = {
            //            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            //            vc.selectedTabIndex = 0
            //            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickMyList = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            DispatchQueue.main.async {
                if self.displayAllItems {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                    vc.tabType = .myList
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
                    vc.tabType = .myList
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
        
        tabBar?.didClickProduct = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
        tabBar?.didClickSpecials = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            DispatchQueue.main.async {
                var localStorageArray = LocalStorage.getFilteredData()
                 localStorageArray += LocalStorage.getFilteredMultiData()
                if localStorageArray.count == 0 {
                    self.tabType = .myOrders
                    self.configureTabBar()
                    self.presentPopUpVC(message: emptyCart, title: "")
                } else {
                    let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
                    confirmPaymentVC.tabType = .myOrders
                    self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
                }
            }
        }
        
        tabBar?.didClickMore = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        self.outletsTableView.reloadData()
        self.tabbarView.addSubview(tabBar!)
    }
    
    deinit {
        print("denit")
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Call Update Inventory Api
        print("viewWillDisappear")
        self.view.endEditing(true)
        removeObserver()
        removeCartSuccesObserver()
        viewModel.isMenuButtonSelected = true
        if isChangedQuantity {
            DispatchQueue.main.async {
                self.sendRequestUpdateUserProductList()
            }
        }
        self.isChangedQuantity = false
    }
    
    //MARK: -> Helpers
    func configureUI() {
        self.toggleOutletsListView(isShow: isShowOutletsTable)
        configureWebIndicator()
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        tableView.delegate = self
        tableView.dataSource = self
        bannerTableView.delegate = self
        bannerTableView.dataSource = self
        viewModel.isComingFromReviewOrderButton = false
        searchContainerView.layer.cornerRadius = Radius.searchViewRadius
        searchContainerView.layer.borderWidth = Radius.searchViewborderWidth
        searchContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH ALL PRODUCTS",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
        
        outletsContainerView.layer.cornerRadius = Radius.searchViewRadius
        outletsContainerView.layer.borderWidth = Radius.searchViewborderWidth
        outletsContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        
        outletsTableView.delegate = self
        outletsTableView.dataSource = self
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
        tableView.register(UINib(nibName: "SpecialProductTableViewCell", bundle: nil), forCellReuseIdentifier:"SpecialProductTableViewCell")
        tableView.register(UINib(nibName: "FeaturedTableViewCell", bundle: nil), forCellReuseIdentifier:"FeaturedTableViewCell")
        bannerTableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        outletsTableView.register(UINib(nibName: "OutletsTableViewCell", bundle: nil), forCellReuseIdentifier: "OutletsTableViewCell")
    }
    
    @objc func totalAmountLabelTapped(_ sender: UITapGestureRecognizer) {
        var localStorageArray = LocalStorage.getFilteredData()
        localStorageArray += LocalStorage.getFilteredMultiData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = .myOrders
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
    
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        var localStorageArray = LocalStorage.getFilteredData()
        localStorageArray += LocalStorage.getFilteredMultiData()
        for i in 0..<localStorageArray.count {
            var strPrice = ""
            var strQuantity = ""
            var strPortion = ""
            if  let strPricee = localStorageArray[i].item_price {
                strPrice = strPricee
            }
            if let strPortionn = localStorageArray[i].portion {
                strPortion = strPortionn
            }
            if let strQuantityy = localStorageArray[i].quantity {
                strQuantity = strQuantityy
            }
            let floatPrice = (strPrice as NSString).floatValue
            let floatQuantity = (strQuantity as NSString).floatValue
            let floatPortion = (strPortion as NSString).floatValue
            if(floatPortion > 0.0) {
                totalPrice = totalPrice + floatPrice * floatQuantity * floatPortion
            }
            else {
                totalPrice = totalPrice + floatPrice * floatQuantity
            }
        }
        
        viewModel.floatTotalPrice = totalPrice
        if(viewModel.floatTotalPrice < 0.0) {
            viewModel.floatTotalPrice = 0.0
        }
        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        let strTitleTotalPriceButton = "Total" + " " + currencySymbol + strTottalPrice
        //        if self.viewModel.showPrice != "0" {
        //            self.totalPriceLabel.text = strTitleTotalPriceButton
        //        } else {
        //            self.totalPriceLabel.text = ""
        //        }
        
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                self.totalPriceLabel.text = strTitleTotalPriceButton
            } else {
                self.totalPriceLabel.text = ""
            }
        } else {
            self.totalPriceLabel.text = ""
        }
        self.configureCartImage()
    }
    
    func configureCartImage() {
        cartImageIcon.image = Icons.cart
        //        let cartItems = LocalStorage.getFilteredData()
        //        let cartItemsString = String(cartItems.count)
        //        let digitCount = cartItemsString.count
        //        totalCartItemsCountTopConst.constant = 11.5
        //        if digitCount > 1 {
        //            totalCartItemsCountTrailingConst.constant = 8.5
        //        } else if cartItems.count == 1 {
        //            totalCartItemsCountTrailingConst.constant = 14
        //        } else {
        //            totalCartItemsCountTrailingConst.constant = 11
        //        }
        //        if cartItems.count > 0 {
        //            totalCartItemsCount.text = "\(cartItems.count)"
        //        } else {
        //            totalCartItemsCount.text = "0"
        //        }
        var cartItems = LocalStorage.getFilteredData()
        cartItems += LocalStorage.getFilteredMultiData()
        totalCartItemsCountTopConst.constant = Constants.totalCartItemsCountTopConst
        totalCartItemsCountTrailingConst.constant = CGFloat(Constants.cartItemsCountLabelTrailingConst())
        if cartItems.count > 0 {
            totalCartItemsCount.text = "\(cartItems.count)"
        } else {
            totalCartItemsCount.text = "0"
        }
    }
    
    func configureOutletsView(noOfOutltes: Int) {
        if noOfOutltes > 0 {
            outletsContainerView.isHidden = false
            outletsContainerWidthConst.constant = 42
            outletsContainerTrailingConst.constant = 5
        } else {
            outletsContainerView.isHidden = true
            outletsContainerWidthConst.constant = 0
            outletsContainerTrailingConst.constant = 0
        }
    }
    
    func toggleOutletsListView(isShow: Bool) {
        if isShow {
            OutletTableContainerView.isHidden = false
        } else {
            OutletTableContainerView.isHidden = true
        }
    }
    
    //MARK: Show Featured PopUp API
    func showFeaturedPopUp() {
        let isShowFeaturedImageOnDashboard = UserDefaults.standard.object(forKey:UserDefaultsKeys.isShowFeaturedImageOnDashboard) as? Bool ?? false
        if(isShowFeaturedImageOnDashboard){
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
            if (customerType == "Wholesale Customer") {
                appType = KeyConstants.app_TypeDual
            } else {
                appType = KeyConstants.app_TypeRetailer
            }
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
            dictParam = [
                GetInformation.type.rawValue:KeyConstants.appType ,
                GetInformation.app_type.rawValue:appType,
                GetInformation.client_code.rawValue:KeyConstants.clientCode ,
                GetInformation.user_code.rawValue:userID,
                GetInformation.device_id.rawValue:Constants.deviceId
            ]
            self.getFeaturedProduct(with: dictParam)
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.isShowFeaturedImageOnDashboard)
        }
    }
    
    //MARK: Logout API
    func logout() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        db.deleteByClientCode(strClientCode: clientCode)
        self.arrSuppliers = db.readData()
        if(arrSuppliers.count != 0){
            if let strAppName = self.arrSuppliers[0]["supplier_name"]{
                //UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
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
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "RegionViewController") as! RegionViewController
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
    
    //MARK: -> Button Actions
    @IBAction func searchButton(_ sender: UIButton) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "CommonSearchViewController") as! CommonSearchViewController
        vc.tabType = self.tabType
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func switchCustomer(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey:  UserDefaultsKeys.outletsListData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let switchCustomerVC = storyboard.instantiateViewController(withIdentifier: "CustomerListViewController") as! CustomerListViewController
        self.navigationController?.pushViewController(switchCustomerVC, animated: false)
    }
    
    @IBAction func cartButton(_ sender: UIButton) {
        var localStorageArray = LocalStorage.getFilteredData()
        localStorageArray += LocalStorage.getFilteredMultiData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = .myOrders
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
    
    @IBAction func changeOutletButton(_ sender: UIButton) {
        print("Change Outlets")
        let arrayOfOutlets = LocalStorage.getOutletsListData()
        print(arrayOfOutlets.count)
        
        self.isShowOutletsTable = !self.isShowOutletsTable
        self.toggleOutletsListView(isShow: isShowOutletsTable)
    }
}

//MARK: -> UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == bannerTableView {
            return 1
        } else if tableView == outletsTableView {
            return 1
        } else {
            return 9
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == outletsTableView {
            return LocalStorage.getOutletsListData().count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bannerTableView {
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
            bannerCell.configureUI()
            print(viewModel.arrayOfBanner)
            bannerCell.configureUI(with: viewModel.arrayOfBanner)
            bannerCell.delegeteBannerImageClick = self
            return bannerCell
        } else if tableView == outletsTableView {
            let outletCell = tableView.dequeueReusableCell(withIdentifier: "OutletsTableViewCell") as! OutletsTableViewCell
            
            if indexPath.row == 0 {
                outletCell.configureArrowImageUI(isShow: true, image: "rightTick")
                outletCell.outletNameLabel.textColor = UIColor(red: 40.0/255.0, green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            } else {
                outletCell.configureArrowImageUI(isShow: false, image: "")
                outletCell.outletNameLabel.textColor = UIColor.black
            }
            
            let arrayOfOutlets = LocalStorage.getOutletsListData()
            
            if let outletName = arrayOfOutlets[indexPath.row].name {
                outletCell.outletNameLabel.text = outletName
            }
            if (indexPath.row % 2 == 0) {
                outletCell.contentView.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
                // outletCell.outletNameLabel.textColor = UIColor(red: 40.0/255.0, green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            } else {
                outletCell.contentView.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
                
                //outletCell.outletNameLabel.textColor = UIColor.black
            }
            outletCell.selectionStyle = .none
            return outletCell
        } else {
            let index = indexPath.section
            switch index {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
                cell.containerViewTopConst.constant = 12
                cell.titleLabel.text = "Search by Categories"
                cell.configureSellAllButton(isShow: true)
                cell.didClickSeeAll = { [weak self] in
                    let storyBoard = UIStoryboard(name: Storyboard.allCategory, bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AllCategoryViewController") as! AllCategoryViewController
                    vc.tabType = self!.tabType
                    vc.arrayOfAllCategory = self?.viewModel.arrayOfCategory ?? []
                    vc.viewModel.arrayOfBanner = self?.viewModel.arrayOfBanner ?? []
                    self?.navigationController?.pushViewController(vc, animated: false)
                }
                return cell
            case 1:
                if let _ = UserDefaults.standard.value(forKey: "isWebViewReload") as? String {
                    print("not call")
                } else {
                    print("call")
                    let webCell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell") as! FeaturedTableViewCell
                    webCell.configureUI()
                    webCell.configureData(data: self.viewModel.featuredItem)
                    webCell.webkitview.navigationDelegate = self
                    webCell.webkitview.uiDelegate = self
                    if self.viewModel.featuredItem != nil {
                        UserDefaults.standard.set("Yes", forKey: "isWebViewReload")
                    }
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell") as! CategoriesTableViewCell
                cell.configureData(data: viewModel.arrayOfCategory)
                cell.delegeteProductClick = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
                //cell.spcingheightConst.constant = 25
                cell.containerViewTopConst.constant = 8
                cell.titleLabel.text = "Specials"
                cell.configureSellAllButton(isShow: true)
                cell.didClickSeeAll = { [weak self] in
                    let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let tabVC = StoryBoard.instantiateViewController(withIdentifier: "SpecialsViewController") as? SpecialsViewController
                    // tabVC?.selectedTabIndex = 3
                    self?.navigationController?.pushViewController(tabVC!, animated: false)
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialProductTableViewCell") as! SpecialProductTableViewCell
                cell.delegeteProductClick = self
                cell.delegeteGetItemCode = self
                cell.delegeteGetStringText = self
                cell.delegeteSuccessWithListType = self
                cell.popUpDelegate = self
                cell.reloadDelegate = self
                cell.configureHomeData(data: self.viewModel.arrayOfSpecial, showImage: self.viewModel.showImage, showPrice: self.viewModel.showPrice, listingType: .specials)
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
                cell.containerViewTopConst.constant = 20
                cell.titleLabel.text = "My Products List"
                cell.configureSellAllButton(isShow: true)
                if self.viewModel.showMyProduct == 1 {
                    //cell.spcingheightConst.constant = 25
                } else {
                    //cell.spcingheightConst.constant = 0
                }
                
                cell.didClickSeeAll = { [weak self] in
                    if let displayAllItems = self?.displayAllItems {
                        if displayAllItems {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                            vc.tabType = .myList
                            self?.navigationController?.pushViewController(vc, animated: false)
                        } else {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
                            vc.tabType = .myList
                            self?.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                  
                }
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
                cell.delegeteProductClick = self
                cell.delegeteGetItemCode = self
                cell.delegeteGetStringText = self
                cell.delegeteSuccessWithListType = self
                cell.popUpDelegate = self
                cell.reloadDelegate = self
                cell.configureHomeProductListData(data: self.viewModel.arrayOfAllInventory, showImage: self.viewModel.showImage, showPrice: self.viewModel.showPrice, listingType: .proudctList)
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
                cell.containerViewTopConst.constant = 30//20
                cell.titleLabel.text = "Featured"
                //cell.spcingheightConst.constant = 25
                cell.configureSellAllButton(isShow: false)
                return cell
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell") as! FeaturedTableViewCell
                cell.configureUI()
                cell.configureData(data: self.viewModel.featuredItem)
                cell.webkitview.navigationDelegate = self
                cell.webkitview.uiDelegate = self
                cell.webkitview.scrollView.alwaysBounceVertical = false
                
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == outletsTableView {
            var arrayOfOutlets = LocalStorage.getOutletsListData()
            
            if let userId = arrayOfOutlets[indexPath.row].user_code {
                for i in 0..<arrayOfOutlets.count {
                    arrayOfOutlets[i].isSelected = false
                }
                
                arrayOfOutlets[indexPath.row].isSelected = true
                if let index = arrayOfOutlets.firstIndex(where: { $0.isSelected == true }) {
                    let item = arrayOfOutlets.remove(at: index)
                    arrayOfOutlets.insert(item, at: 0)
                }
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.outletsListData)
                LocalStorage.saveOutletsListData(data: arrayOfOutlets)
                
                self.isShowOutletsTable = !self.isShowOutletsTable
                self.toggleOutletsListView(isShow: self.isShowOutletsTable)
                UserDefaults.standard.set(userId, forKey:UserDefaultsKeys.UserLoginID)
                //callSaveCart()
                self.requestForRegisterUserDevice()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == bannerTableView {
            let showBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
            if showBanner == 1 &&  self.viewModel.arrayOfBanner.count > 0 {
                bannerTableViewHeightConst.constant = 130
                return 130
            } else {
                bannerTableViewHeightConst.constant = 0
                return 0
            }
        } else if tableView == outletsTableView {
            return 38
        } else {
            let index = indexPath.section
            switch (index) {
            case 0:
                if self.viewModel.homeData?.categoryExists != 0 && viewModel.arrayOfCategory.count > 0 {
                    return UITableView.automaticDimension//26
                } else {
                    return 0
                }
            case 2:
                if self.viewModel.arrayOfSpecial.count > 0  {
                    return UITableView.automaticDimension//40
                } else {
                    return 0
                }
                
            case 1:
                //Category Cell
                if self.viewModel.homeData?.categoryExists != 0 && viewModel.arrayOfCategory.count > 0 {
                    return 140
                } else {
                    return 0
                }
            case 3:
                if self.viewModel.arrayOfSpecial.count > 0  {
                    if self.viewModel.showImage == "1" {
                        return 230
                    } else {
                        return 154
                    }
                } else {
                    return 0
                }
            case 4:
                if self.viewModel.showMyProduct == 1 && viewModel.arrayOfAllInventory.count > 0 {
                    return UITableView.automaticDimension//55
                } else {
                    return 0
                }
            case 5:
                if self.viewModel.showMyProduct == 1 && viewModel.arrayOfAllInventory.count > 0 {
                    if self.viewModel.showImage == "1" {
                        return 230
                    } else {
                        return 154
                    }
                } else {
                    return 0
                }
            case 6:
                return UITableView.automaticDimension//55
            case 7:
                print("uu",self.featuredheight)
                return self.featuredheight
            default:
                return 0
            }
        }
    }
}

//MARK: - Delegete-BannerImage-Click
extension HomeViewController: DelegeteBannerImageClick {
    func didClickBannerImage(ind: Int) {
        let linkItemType = self.viewModel.arrayOfBanner[ind].linkItemType
        
        if linkItemType == "category" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isComeFromBanner)
            vc.categoryId = self.viewModel.arrayOfBanner[ind].linkItemTypeID ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "specials" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SpecialsViewController") as! SpecialsViewController
            vc.tabType = self.tabType
            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "product" {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.tabType =  self.tabType
            vc.isComingFromBannerClick = true
            vc.itemCode = self.viewModel.arrayOfBanner[ind].linkItemTypeID ?? ""
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//MARK: - GetProductClickIndex
extension HomeViewController: DelegeteProductClick {
    func didClickProduct(index: Int, listingType: ProductListingType) {
        if listingType == .searchByCategory {
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            if let categoryId = viewModel.arrayOfCategory[index].id {
                UserDefaults.standard.setValue(categoryId, forKey: "AllCategoryId")
            }
            let tabVC = StoryBoard.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
            //tabVC?.selectedTabIndex = 2
            self.navigationController?.pushViewController(tabVC!, animated: false)
        } else if listingType == .specials {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.productDetails = self.viewModel.arrayOfSpecial[index]
            vc.tabType =  self.tabType
            vc.delegeteSuccess = self
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        } else if listingType == .proudctList {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.tabType =  self.tabType
            vc.delegeteSuccess = self
            vc.productDetails = self.viewModel.arrayOfAllInventory[index]
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//MARK: - DelegeteGetItemCode
extension HomeViewController: DelegeteGetItemCode {
    func itemCode(itemCode: String) {
        viewModel.itemCode = itemCode
        //addProduct(param: viewModel.AddProductParam() as [String : Any],itemCode: itemCode)
        self.deleteItemWithId(itemCode: itemCode)
        LocalStorage.deleteGetItemsIndex(itemCode: itemCode)
        LocalStorage.deleteMultiItemsIndex(itemCode: itemCode)
    }
}

//MARK: - DelegeteGetItemCode
extension HomeViewController: DelegeteSuccess {
    func isSuceess(success: Bool, text: String) {
        if success {
            //self.getHomeData()
            self.updateTotaPrice()
            self.tableView.reloadData()
        }
    }
}

//MARK: - DelegeteGetStringText
extension HomeViewController: DelegeteGetStringText, DelegeteSuccessWithListType,ReloadTableViewDelegate {
    func reloadTableView() {
        self.isChangedQuantity = true
        self.tableView.reloadData()
    }

    func isSuccessWithListType(success: Bool, text: String, listType: ProductListingType, measureQty: String) {
        self.isChangedQuantity = true
        self.listingType = listType
        if self.listingType == .specials {
            print(text,measureQty)
            guard let itemCode = self.viewModel.arrayOfSpecial[index].item_code else { return }
            
            if let ind = self.viewModel.arrayOfAllInventory.firstIndex(where: {$0.item_code == itemCode}) {
                self.viewModel.arrayOfAllInventory[ind].originQty = text
                self.viewModel.arrayOfAllInventory[ind].measureQty = measureQty
                self.viewModel.arrayOfAllInventory[ind].priority = 1
            }
            
            if let ind = self.viewModel.arrayOfSpecial.firstIndex(where: {$0.item_code == itemCode}) {
                self.viewModel.arrayOfSpecial[ind].originQty = text
                self.viewModel.arrayOfSpecial[ind].measureQty = measureQty
                self.viewModel.arrayOfSpecial[ind].priority = 1
                Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfSpecial[ind])
            }
        } else { // Product List
            guard let itemCode = self.viewModel.arrayOfAllInventory[index].item_code else { return }
            print(text,measureQty)
            if let ind = self.viewModel.arrayOfSpecial.firstIndex(where: {$0.item_code == itemCode}) {
                self.viewModel.arrayOfSpecial[ind].originQty = text
                self.viewModel.arrayOfSpecial[ind].measureQty = measureQty
                self.viewModel.arrayOfSpecial[ind].priority = 1
            }
            
            if let ind = self.viewModel.arrayOfAllInventory.firstIndex(where: {$0.item_code == itemCode}) {
                self.viewModel.arrayOfAllInventory[ind].originQty = text
                self.viewModel.arrayOfAllInventory[ind].measureQty = measureQty
                self.viewModel.arrayOfAllInventory[ind].priority = 1
                Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfAllInventory[ind])
            }
        }
        self.updateTotaPrice()
        self.tableView.beginUpdates()
        if self.listingType == .specials {
            self.tableView.reloadSections(NSIndexSet(index: 5) as IndexSet, with: UITableView.RowAnimation.none)
        } else  if self.listingType == .proudctList {
            self.tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: UITableView.RowAnimation.none)
        }
       // self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func DelegeteGetStringText(quantity: String, index: Int, measure: String) {
        self.index = index
    }
    
    func updateArray(quantity: String,itemCode:String, index: Int) {
        if quantity != "" {
            if self.listingType == .specials {
                self.viewModel.arrayOfNewSpecials = self.viewModel.arrayOfSpecial
                self.viewModel.arrayOfNewSpecials[index].quantity = quantity
                self.viewModel.arrayOfNewSpecials[index].item_code = itemCode
                self.viewModel.arrayOfSpecial = self.viewModel.arrayOfNewSpecials
            } else {
                self.viewModel.arrayOfNewAllInventory = self.viewModel.arrayOfAllInventory
                self.viewModel.arrayOfNewAllInventory[index].quantity = quantity
                self.viewModel.arrayOfNewAllInventory[index].item_code = itemCode
                self.viewModel.arrayOfAllInventory = self.viewModel.arrayOfNewAllInventory
            }
        }
        self.updateTotaPrice()
        self.sendRequestUpdateUserProductList()
    }
    
    func sendRequestUpdateUserProductList() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        var arrUpdatedPriceQuantity = [[String:Any]]()
        var arrMultiItemQuantity = [[String:Any]]()
        let localStorageArray = LocalStorage.getItemsData()
        for i in 0..<localStorageArray.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            var strMeasureQty = ""
            var strOriginQty = ""
            var strPriority = 1
            var strIsMeasure = 0
            var strId = 0
            if let strQuantity = localStorageArray[i].quantity {
                strQuantityy = strQuantity
            }
            if let strItemName = localStorageArray[i].item_name {
                strItemNamee = strItemName
            }
            if let strItemCode  = localStorageArray[i].item_code {
                strItemCodee = strItemCode
            }
            
            if let measureQty  = localStorageArray[i].measureQty {
                strMeasureQty = measureQty
            }
            
            if let originQty  = localStorageArray[i].originQty {
                strOriginQty = originQty
            }
            
            if let isMeasure  = localStorageArray[i].is_meas_box {
                strIsMeasure = isMeasure
            }
            
            if let priority  = localStorageArray[i].priority {
                strPriority = priority
            }
            
            if let id  = localStorageArray[i].id {
                strId = id
            }
            
            var dictData = [String:Any]()
            dictData["quantity"] = strQuantityy
            dictData["item_name"] = strItemNamee
            dictData["item_code"] = strItemCodee
            dictData["measureQty"] = strMeasureQty
            dictData["originQty"] = strOriginQty
            dictData["is_meas_box"] = strIsMeasure
            dictData["priority"] = strPriority
            dictData["id"] = strId
            arrUpdatedPriceQuantity.insert(dictData, at: i)
        }
        
        let localMultiItemStorageArray = LocalStorage.getShowItData()
        for i in 0..<localMultiItemStorageArray.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            var strmeasureQty = ""
            var stroriginQty = ""
            var strIsMeasure = 0
            var strPriority = 1
            var strId = 0
            if let strQuantity = localMultiItemStorageArray[i].quantity {
                strQuantityy = strQuantity
            }
            if let strItemName = localMultiItemStorageArray[i].item_name {
                strItemNamee = strItemName
            }
            if let strItemCode  = localMultiItemStorageArray[i].item_code {
                strItemCodee = strItemCode
            }
            
            if let measureQty  = localMultiItemStorageArray[i].measureQty {
                strmeasureQty = measureQty
            }
            
            if let originQty  = localMultiItemStorageArray[i].originQty {
                stroriginQty = originQty
            }
            
            if let isMeasure  = localMultiItemStorageArray[i].is_meas_box {
                strIsMeasure = isMeasure
            }
            
            if let priority  = localMultiItemStorageArray[i].priority {
                strPriority = priority
            }
            
            if let id  = localMultiItemStorageArray[i].id {
                strId = id
            }
            
            var dictData = [String:Any]()
            dictData["quantity"] = strQuantityy
            dictData["item_name"] = strItemNamee
            dictData["item_code"] = strItemCodee
            dictData["measureQty"] = strmeasureQty
            dictData["originQty"] = stroriginQty
            dictData["is_meas_box"] = strIsMeasure
            dictData["priority"] = strPriority
            dictData["id"] = strId
            arrUpdatedPriceQuantity.insert(dictData, at: i)
        }
        
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        
        var  orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
        
        if(orderFlag == ""){
            orderFlag = "0"
        }
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
            UpdateProductList.type.rawValue:KeyConstants.appType ,
            UpdateProductList.app_type.rawValue:appType,
            UpdateProductList.client_code.rawValue: KeyConstants.clientCode,
            UpdateProductList.user_code.rawValue:userID ,
            UpdateProductList.orderFlag.rawValue:orderFlag,
            UpdateProductList.cartItems.rawValue:arrUpdatedPriceQuantity,
            UpdateProductList.device_id.rawValue:Constants.deviceId,
            UpdateProductList.acm_code.rawValue:acmCode,
        ]
        print("Update",JSON(dictParam))
        self.updateProductList(with: dictParam)
    }
}

//MARK: - View-Model Interaction
extension HomeViewController {
    func getHomeData() {
        self.getItems(with: self.viewModel.param() as [String : Any])
    }
    
    private func getItems(with param: [String: Any]) {
        self.view.endEditing(true)
        viewModel.getHomeData(with: param) { data, error in
            if let getUserItemsData = data {
                if (getUserItemsData.status == 1) {
                    if let displayAllItem = getUserItemsData.displayAllItems {
                        UserDefaults.standard.set(displayAllItem, forKey: "displayAllItem")
                        self.displayAllItems = displayAllItem
                    }
                    self.viewModel.homeData = getUserItemsData.data
                    if let app_version_update = getUserItemsData.app_version_update {
                        self.appstoreVersion = app_version_update
                    }
                    
                    if let show_image = getUserItemsData.show_image {
                        self.viewModel.showImage = show_image
                    }
                    
                    if let showAppBanner = getUserItemsData.showAppBanner {
                        UserDefaults.standard.set(showAppBanner, forKey:UserDefaultsKeys.showAppBanner)
                    }
                    
                    if let app_version_update_type = getUserItemsData.app_version_update_type {
                        self.updateType = app_version_update_type
                    }
                    
                    if let app_version_update_content = getUserItemsData.app_version_update_content {
                        self.updateAlertMessage = app_version_update_content
                    }
                    //
                    if let bannerLists = getUserItemsData.data?.bannerLists {
                        self.viewModel.arrayOfBanner = bannerLists
                        let showBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
                        if showBanner == 1 &&  self.viewModel.arrayOfBanner.count > 0 {
                            self.bannerTableViewHeightConst.constant = 130
                        } else {
                            self.bannerTableViewHeightConst.constant = 0
                        }
                    } else {
                        self.bannerTableViewHeightConst.constant = 0
                    }
                    //
                    if let specialItemList = getUserItemsData.data?.specialInventories {
                        self.viewModel.arrayOfSpecial = specialItemList
                    }
                    
                    if let featuredData = getUserItemsData.data?.featuredItem {
                        self.viewModel.featuredItem = featuredData
                    }
                    
                    if let allcategory = getUserItemsData.data?.allCategories {
                        self.viewModel.arrayOfCategory = allcategory
                    }
                    
//                    if let multiList = getUserItemsData.data?.multi_items {
//                        if !multiList.isEmpty {
//                            LocalStorage.clearMultiItemsData()
//                            LocalStorage.saveMultiData(data: multiList)
//                        }
//                    }
                    
                    
                    if let allInventories = getUserItemsData.data?.allInventories {
                        self.viewModel.arrayOfAllInventory = allInventories
                    }
                    
                    if let customerType = getUserItemsData.customerType {
                        UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                    }
                    
                    if let showItemInGrid = getUserItemsData.showItemInGrid {
                        UserDefaults.standard.set(showItemInGrid, forKey: UserDefaultsKeys.showItemInGrid)
                    }
                    
                    if let showMyProduct = getUserItemsData.show_my_product {
                        self.viewModel.showMyProduct = showMyProduct
                    }
                    
                    if let showPrice  = getUserItemsData.showPrice {
                        UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                        if(showPrice == "0") {
                            //self.totalPriceView.isHidden = true
                            // self.totalPriceLabel.isHidden = true
                            // self.totalPriceViewHeightConst.constant = 0
                            // self.totalPriceButton.isHidden = true
                        } else {
                            // self.totalPriceView.isHidden = false
                            //self.totalPriceLabel.isHidden = false
                            // self.totalPriceViewHeightConst.constant = 30
                            // self.totalPriceButton.isHidden = false
                        }
                        self.viewModel.showPrice = showPrice
                    }
                    
                    if let outletsNumber = getUserItemsData.outlets {
                        self.viewModel.noOfOutlets = outletsNumber
                        //self.configureOutletsView(noOfOutltes: self.viewModel.noOfOutlets)
                    } else {
                        self.viewModel.noOfOutlets = 0
                    }
                    
                    if let currencySymbol = getUserItemsData.currency_symbol {
                        if(currencySymbol != ""){
                            UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                        } else {
                            UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                        }
                    }
                    
                    if let categoryExist = getUserItemsData.data?.categoryExists {
                        if(categoryExist == 0) {
                            self.viewModel.isCategoryExist = false
                            //self.hideCollectionView()
                            if let arrItemsData = getUserItemsData.data {
                                //self.viewModel.arrItemsData  = arrItemsData
                            }
                        } else {
                            self.viewModel.isCategoryExist = true
                            //self.showCollectionView()
                            //if let arrItemsWithCategoryData = getUserItemsData.data?.allCategories {
                            //self.viewModel.arrItemsCategoryData = arrItemsWithCategoryData
                            //if let arrItemsDataNew = self.viewModel.arrItemsCategoryData[0].data {
                            // self.viewModel.arrItemsData = arrItemsDataNew
                            //}
                            //tableView.reloadData()
                            //}
                        }
                    }
                    
                    if(self.viewModel.showPrice != "0") {
                        self.updateTotaPrice()
                    }
                    //self.showFeaturedPopUp()
                } else if(getUserItemsData.status == 2) {
                    guard let messge = getUserItemsData.message else {return}
                    self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                }
                
                else {
                    //self.itemsTableView.isHidden = true
                    //self.addProductButton.isHidden = false
                    //self.labelAddProduct.isHidden = false
                    //self.categoryCollectionView.isHidden = true
                    //self.viewOutlet.isHidden = true
                }
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.bannerTableView.reloadData()
                    self.tableView.reloadData()
                    self.outletsTableView.reloadData()
                }
            }
            if let error = error {
                print(error)
            }
            
            //self.checkForAppVersionUpdates(appStoreVersion: self.appstoreVersion)
        }
    }
    
    //Add-Product
    func addProduct(param:[String:Any],itemCode: String) {
        viewModel.addProduct(with: param, view: self.view) { result in
            switch result{
            case .success(let addProductData):
                if let addProductData = addProductData {
                    guard let status = addProductData.status  else { return }
                    if (status == 1) {
                        guard let messge = addProductData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    } else if (status == 2) {
                        guard let messge = addProductData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    } else {
                        guard let messge = addProductData.message else {return}
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
    
    //MARK: - sendRequestUpdateUserProductList //Called When Add quantity on TextField.
    //Update-Product-List
    private func updateProductList(with param: [String: Any]) {
        viewModel.updateProductList(with: param, view: self.view) { result in
            switch result{
            case .success(let deletedItemData):
                print(deletedItemData)
            case .failure(let error):
                print(error)
            case .none:
                break
            }
        }
    }
    
    //Get Featured- Product
    private func getFeaturedProduct(with param: [String: Any]) {
        viewModel.getFeaturedProduct(with: param, view: self.view) { result in
            switch result {
            case .success(let featuredProductData):
                if let featuredProductData = featuredProductData {
                    guard let status = featuredProductData.status else { return }
                    
                    if (status == 1) {
                        DispatchQueue.main.async {
                            let strImage = featuredProductData.data?.image ?? ""
                            let strContent = featuredProductData.data?.content  ?? ""
                            let strSavedDate = featuredProductData.data?.date ?? ""
                            let strShow = featuredProductData.data?.show ?? ""
                            let strVisibility = featuredProductData.data?.visibility ?? ""
                            let strOnLaunch = featuredProductData.data?.on_launch ?? ""
                            let strOnLogin = featuredProductData.data?.on_login ?? ""
                            let strDateRes = UserDefaults.standard.object(forKey:UserDefaultsKeys.Date) as? String ?? ""
                            if(strOnLaunch == "1") {
                                if(strShow == "1"){
                                    DispatchQueue.main.async {
                                        let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                        featuredPopUpVC?.strHtmlContent = strContent
                                        featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                        self.present(featuredPopUpVC!, animated: false, completion: nil)
                                    }
                                } else {
                                }
                            }
                            if(strOnLogin == "0") {
                            }
                            else {
                                if(strSavedDate != strDateRes) {
                                    if(strShow == "1") {
                                        if(strVisibility == "1") {
                                            if(strContent == ""  && strImage == "") {
                                            } else {
                                                DispatchQueue.main.async {
                                                    let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                    featuredPopUpVC?.strHtmlContent = strContent
                                                    featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                    featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                    self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                }
                                            }
                                        }
                                        else {
                                            if(strContent == "") {
                                            }else {
                                                DispatchQueue.main.async {
                                                    let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                    featuredPopUpVC?.strHtmlContent = strContent
                                                    featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                    featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                    self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                }
                                            }
                                        }
                                    } else {
                                    }
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/YYYY"
                                    let currentDate = Date()
                                    let strCurrentDate = dateFormatter.string(from: currentDate)
                                    UserDefaults.standard.set(strCurrentDate, forKey:UserDefaultsKeys.CurrentDate)
                                    UserDefaults.standard.set(strSavedDate, forKey:UserDefaultsKeys.Date)
                                }
                                else {
                                    let currentDate = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrentDate) as? String ?? ""
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/YYYY"
                                    let strDate1 = dateFormatter.string(from: Date())
                                    if(strDate1 == currentDate) {
                                    } else {
                                        if(strShow == "1"){
                                            if(strVisibility == "1") {
                                                if (strContent == "" && strImage == "") {
                                                }
                                                else{
                                                    DispatchQueue.main.async {
                                                        let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                        featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                        featuredPopUpVC?.strHtmlContent = strContent
                                                        featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                        self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                    }
                                                }
                                            } else {
                                                if (strContent == "") {
                                                }
                                                else {
                                                    DispatchQueue.main.async {
                                                        let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                        featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                        featuredPopUpVC?.strHtmlContent = strContent
                                                        featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                        self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                    }
                                                }
                                            }
                                        }
                                        UserDefaults.standard.set(strDate1, forKey:UserDefaultsKeys.CurrentDate)
                                    }
                                }
                            }
                        }
                    } else if(status == 2) {
                        guard let messge = featuredProductData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                    else {
                        guard let messge = featuredProductData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }                }
            case .failure(let error):
                if(error == .networkError) {
                    self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                } else  {
                    self.presentPopUpVC(message: serverNotResponding, title: "")
                }
            case .none:
                break
            }
        }
    }
    
    //MARK: -> deleteItemWithId
    func deleteItemWithId(itemCode: String) {
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        
        dictParam = [
            DeleteItems.type.rawValue:KeyConstants.appType ,
            DeleteItems.app_type.rawValue:appType,
            DeleteItems.client_code.rawValue:KeyConstants.clientCode,
            DeleteItems.user_code.rawValue:userID ,
            DeleteItems.item_code.rawValue:itemCode,
            DeleteItems.device_id.rawValue:Constants.deviceId,
        ]
        deleteItem(with: dictParam, itemCode: itemCode)
    }
    
    
    // //MARK: -> Delete-Item
    func deleteItem(with param: [String: Any],itemCode:String) {
        viewModel.deleteItem (with: param, view: self.view,itemCode: itemCode) { result in
            switch result{
            case .success(let deletedItemData):
                if let deletedItemData = deletedItemData {
                    guard let status = deletedItemData.status else { return }
                    if (status == 1) {
                        self.getHomeData()
                    } else if(status == 2) {
                        guard let messge = deletedItemData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                    else {
                        guard let messge = deletedItemData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                } else  {
                    self.presentPopUpVC(message: serverNotResponding, title: "")
                }
            case .none:
                break
            }
        }
    }
    
    func callSaveCart() {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [SaveCartParam.user_code.rawValue: userCode,
                     SaveCartParam.client_code.rawValue: KeyConstants.clientCode,
                     SaveCartParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print(JSON(param))
        self.viewModel.carartItemsList(with: param as [String : Any]){ result in
            switch result{
            case .success(let deletedItemData):
                self.getHomeData()
            case .failure(_):
                print("Error")
            case .none:
                break
            }
        }
    }
    
    func requestForRegisterUserDevice() {
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
            GetPushNotification.client_code.rawValue:KeyConstants.clientCode,
            GetPushNotification.user_code.rawValue:userID ,
            GetPushNotification.device_id.rawValue:Constants.deviceId,
            GetPushNotification.device_type.rawValue:"FI",
            GetPushNotification.device_token.rawValue:fcmToken,
            GetPushNotification.device_model.rawValue:Constants.deviceName,
            GetPushNotification.device_ip_address.rawValue:Constants.deviceIP
        ]
        self.registerUserDevice(with: dictParam)
    }
    
    //registerUserDevice
    private func registerUserDevice(with param: [String: Any]) {
        viewModel.registerUserDevice(with: param) { result in
            switch result{
            case .success(let getPushNotificationData):
                if let getPushNotificationData = getPushNotificationData {
                    guard let result = getPushNotificationData.result else { return }
                    if (result == 1) {
                        self.callSaveCart()
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
}

//MARK: - PopUpDelegate
extension HomeViewController: PopUpDelegate, ShowListDelegate {
    func didShowListTapDone(itemCode:String) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowListPopUpViewController") as? ShowListPopUpViewController
        // featuredPopUpVC?.view.backgroundColor = UIColor.clear
        nextVC?.refreshDelegate = self
        nextVC?.itemCode = itemCode
        nextVC?.modalPresentationStyle = .overFullScreen
        self.present(nextVC!, animated: false, completion: nil)
    }
    
    func didTapDone() {
//        var userId = ""
//        var userDefaultId = ""
//        if let userid = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String {
//            userId = userid
//        }
//        if let userdefaultId = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String {
//            userDefaultId = userdefaultId
//        }
//        
//        //userDefaultId = userId
//        if(userId == userDefaultId) {
            logout()
//        } else {
//            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
//            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
//            self.pushToOutlets()
//        }
    }
    
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
    
    //MARK: - METHOD TO PUSH TO OUTLETS
    func pushToOutlets() {
        guard let  outletVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController else {return}
        self.navigationController?.pushViewController(outletVC, animated: false)
    }
}

//MARK: -> UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != outletsTableView {
            let isShowBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
            if isShowBanner == 1 {
                if scrollView.contentOffset.y > 0 {
                    //bannerContainerView.isHidden = true
                    bannerTableViewHeightConst.constant = 0
                } else {
                    //bannerContainerView.isHidden = false
                    bannerTableViewHeightConst.constant = 130
                }
            }
        }
    }
}

//MARK: -> Notification-Center
extension HomeViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("tabChange"), object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        UserDefaults.standard.setValue(true, forKey: "tabChange")
    }
    
    @objc private func notificationReceived(notification: NSNotification) {
        print("tab cHanged ****")
        if self.viewModel.showPrice != "0" {
            updateTotaPrice()
        }
        tableView.reloadData()
    }
    
    private func addCartSuccesObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartSuccesNotificationReceived(notification:)), name: Notification.Name("cartSucess"), object: nil)
    }
    
    
    
    @objc private func cartSuccesNotificationReceived(notification: NSNotification) {
        print("cart Succsess ****")
        if self.viewModel.showPrice != "0" {
            updateTotaPrice()
        } else {
            self.configureCartImage()
        }
    }
    
    private func removeCartSuccesObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Handle Background State
extension HomeViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        if presentingViewController is HomeViewController {
            print("handleAppDidBecomeActive")
            addObserver()
            addCartSuccesObserver()
            getHomeData()
            if self.viewModel.showPrice != "0" {
                updateTotaPrice()
            }
        }
    }
}


//MARK: - WKNavigationDelegate, WKUIDelegate
extension HomeViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.isReload = !self.isReload
        //self.showIndicator()
        print("Web view didStartProvisionalNavigation")
    }
    
    // This function will be invoked when the web page content begin to return.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Web view didCommit")
    }
    
    // This function will be invoked when the page content returned successfully.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let javascript = "Math.max( document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight );"
        webView.evaluateJavaScript(javascript) { (result, error) in
            if let contentHeight = result as? CGFloat {
                print("Content Height: \(contentHeight)")
                if contentHeight > 0 {
                    self.featuredheight = contentHeight + 40
                }
            } else if let error = error {
                print("Error evaluating JavaScript: \(error.localizedDescription)")
            }
        }
        //        let height = webView.scrollView.contentSize.height
        //        if height > 0 {
        //            self.featuredheight = height
        //        }
        
        if self.isReload {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: 7) as IndexSet, with: UITableView.RowAnimation.none)
            self.tableView.endUpdates()
        } else {
            self.didFinsh = !self.didFinsh
            if didFinsh {
                self.tableView.beginUpdates()
                self.tableView.reloadSections(NSIndexSet(index: 7) as IndexSet, with: UITableView.RowAnimation.none)
                self.tableView.endUpdates()
            } else {
                print("Web view didFinish")
            }
        }
        // hideIndicator()
    }
    
    // This function will be invoked when the web view object load page failed.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Web view didFailProvisionalNavigation")
    }
    
    private func loadWebIndicator() {
        indicator.startAnimating()
    }
    
    private func hideWebIndicator() {
        indicator.stopAnimating()
    }
    
    func configureWebIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
        indicator.tintColor = .white
        indicator.center = self.view.center
        view.addSubview(indicator)
    }
}

extension HomeViewController {
    func checkForAppVersionUpdates(appStoreVersion: String) {
        if let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("appCurrentVersion",appCurrentVersion)
            if appCurrentVersion < appStoreVersion {
                DispatchQueue.main.async {
                    let isShowFeaturedImageOnDashboard = UserDefaults.standard.object(forKey:UserDefaultsKeys.isShowUpdateAppPopUp) as? Bool ?? false
                    if(isShowFeaturedImageOnDashboard){
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAvailableViewController") as! UpdateAvailableViewController
                        vc.modalPresentationStyle = .overFullScreen
                        vc.updateType = self.updateType
                        vc.updateMessage = self.updateAlertMessage
                        self.present(vc, animated: false, completion: nil)
                    }
                    UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.isShowUpdateAppPopUp)
                }
            }
        }
    }
}

extension HomeViewController: RefreshDelegate {
    func refresh() {
        updateTotaPrice()
        configureCartImage()
        self.tableView.reloadData()
        self.sendRequestUpdateUserProductList()
    }
    
    
}
