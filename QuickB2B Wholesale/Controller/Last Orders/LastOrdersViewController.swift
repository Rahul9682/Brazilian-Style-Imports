//  LastOrdersViewController.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/18/21.

import UIKit
import SwiftyJSON

class LastOrdersViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var lastOrdersTableView: UITableView!
    @IBOutlet var orderDetailsView: UIView!
    @IBOutlet weak var tabBarView: CustomTabBarView!
    @IBOutlet var titleContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tabbarHeihtConst: NSLayoutConstraint!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!

    
    //MARK: - Properties
    var viewModel = LastOrdersViewModel()
    var OrderId = ""
    var refreshEnable = true
    var background: BackgroundView?
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        self.configureCartImage()
        configureUI()
        self.registerCustomCell()
        self.navigationController?.navigationBar.isHidden = true
        viewModel.arrayOfChips.append((AccountChipsData(id: "1", name: "Account", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "2", name: "Past Orders", isExpanded: false, isSlected: true)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "3", name: "Links", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "4", name: "App User Guide", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "5", name: "Reset My List A-Z", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "6", name: "Logout", isExpanded: false, isSlected: false)))
        collectionView.reloadData()
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height {
            print("Tab Bar Height: \(tabBarHeight)")
        } else {
            print("Tab Bar height not available.")
        }
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                updateTotaPrice()
            }
        }
        didEnterBackgroundObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                lastOrdersTableView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                lastOrdersTableView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                //self.tableView.reloadData()
                self.lastOrdersTableView.reloadData()
                //self.productListCollectionView.reloadData()
            }
            if refreshEnable {
                background?.refreshButton.isHidden = true//false
            } else {
                background?.refreshButton.isHidden = true
            }
//            self.background?.didClickRefreshButton = {
//                if(self.viewModel.isResetList) {
//                    self.showPopUpToResetList()
//                    self.viewModel.isResetList = false
//                    UserDefaults.standard.set(false, forKey: "isResetList")
//                } else {
//                    self.callGetItems()
//                }
//            }
        }
    }
    
    @objc func totalAmountLabelTapped(_ sender: UITapGestureRecognizer) {
        var localStorageArray = LocalStorage.getFilteredData()
        localStorageArray += LocalStorage.getFilteredMultiData()        
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = .account
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
    
    //MARK: - Helpers
    private func configureUI() {
        titleContainerView.layer.cornerRadius = Radius.titleViewRadius
        titleLabel.textColor = UIColor.white
        self.viewModel.arrSuppliers = viewModel.db.readData()
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String  ?? ""
        dictParam = [
            FetchUserOrder.type.rawValue:KeyConstants.appType ,
            FetchUserOrder.app_type.rawValue:appType,
            FetchUserOrder.client_code.rawValue:KeyConstants.clientCode ,
            FetchUserOrder.user_code.rawValue:userID,
            FetchUserOrder.device_id.rawValue:Constants.deviceId ,
        ]
        self.fetchUserOder(with: dictParam)
        lastOrdersTableView.delegate = self
        lastOrdersTableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        orderDetailsView.backgroundColor = UIColor.black
        orderDetailsView.layer.cornerRadius = Radius.radius4
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func registerCustomCell() {
        lastOrdersTableView.register(UINib.init(nibName: "OrderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsTableViewCell")
        lastOrdersTableView.register(UINib.init(nibName: "OrderedItemTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderedItemTableViewCell")
        collectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
    }
    
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        //        for i in 0..<self.viewModel.arrayOfListItems.count {
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
        if(viewModel.floatTotalPrice < 0.0){
            viewModel.floatTotalPrice = 0.0
        }
        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        let strTitleTotalPriceButton = "Total" + " " + currencySymbol + strTottalPrice
        self.totalPriceLabel.text = strTitleTotalPriceButton
        self.configureCartImage()
        //self.totalPriceButton.setTitle(strTitleTotalPriceButton , for: .normal)
        
        //        if strTottalPrice == "0" || strTottalPrice == "0.00" {
        //            totalPriceLabel.isHidden = true
        //        } else {
        //            totalPriceLabel.isHidden = false
        //            self.totalPriceLabel.text = strTitleTotalPriceButton
        //        }
    }
    
    func configureCartImage() {
        cartImageIcon.image = Icons.cart
        var cartItems = LocalStorage.getFilteredData()
        cartItems += LocalStorage.getFilteredMultiData()
        totalCartItemsCountTopConst.constant = Constants.totalCartItemsCountTopConst
        totalCartItemsCountTrailingConst.constant = CGFloat(Constants.cartItemsCountLabelTrailingConst())
        if cartItems.count > 0 {
            cartItemsCountLabel.text = "\(cartItems.count)"
        } else {
            cartItemsCountLabel.text = "0"
        }
    }
    
    func pushToOutlets() {
        guard let  outletVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController else {return}
        self.navigationController?.pushViewController(outletVC, animated: false)
    }
    
    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabBarView.bounds
        tabBar?.configureTabUI(with: .account)
        tabBar?.didClickHomeButton = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickMyList = {
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
        
        tabBar?.didClickProduct = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickSpecials = {
            let localStorageArray = LocalStorage.getFilteredData()
            if localStorageArray.count == 0 {
                self.presentPopUpVC(message: emptyCart, title: "")
            } else {
                let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
                confirmPaymentVC.tabType = .myOrders
                self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
            }
        }
        
        tabBar?.didClickMore = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        self.tabBarView.addSubview(tabBar!)
    }
    
    func deviceHasSafeArea() -> Bool {
        if #available(iOS 11.0, *) {
            // Check if the window's safeAreaInsets are greater than zero.
            if let window = UIApplication.shared.windows.first {
                return window.safeAreaInsets != UIEdgeInsets.zero
            }
        }
        return false
    }
    
    //MARK: - LOGOUT METHOD
    func logOut() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        viewModel.db.deleteByClientCode(strClientCode: clientCode)
        self.viewModel.arrSuppliers = viewModel.db.readData()
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
                UserDefaults.standard.set(strUserLoginId, forKey: UserDefaultsKeys.UserDefaultLoginID)
            }
            
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "RegionViewController") as! RegionViewController
            //  self.navigationController?.pushViewController(tbc, animated: false)
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
    
    func logoutUser() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        self.viewModel.db.deleteByClientCode(strClientCode: clientCode)
        self.viewModel.arrSuppliers = self.viewModel.db.readData()
        self.viewModel.db.deleteByClientCode(strClientCode: clientCode)
        if(self.viewModel.arrSuppliers.count != 0){
            
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
                UserDefaults.standard.set(strUserLoginId, forKey: UserDefaultsKeys.UserDefaultLoginID)
            }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            //  self.navigationController?.pushViewController(tbc, animated: false)
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func menuButton(_ sender: UIButton) {
        self.view.endEditing(true)
        UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func caretButton(_ sender: UIButton) {
        let localStorageArray = LocalStorage.getFilteredData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = .account
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension LastOrdersViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrUserOrderData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.viewModel.arrUserOrderData[section].isExpanded == true) {
            return viewModel.arrOrderDetailsData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lastOrdersTableView.dequeueReusableCell(withIdentifier: "OrderedItemTableViewCell") as! OrderedItemTableViewCell
        if let inventoryName = viewModel.arrOrderDetailsData[indexPath.row].inventory_name {
            cell.itemNameLabel.text = inventoryName
        }
        if let quantity = viewModel.arrOrderDetailsData[indexPath.row].quantity {
            cell.itemQuantityLabel.text = quantity
        }
        
        //        if indexPath.row == viewModel.arrOrderDetailsData.count - 1 {
        //            cell.reOrderButton.isHidden = false
        //        } else {
        //            cell.reOrderButton.isHidden = true
        //        }
        
        cell.didClickReorder = {
            //Call Reorder Api
            self.callReOrder()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = lastOrdersTableView.dequeueReusableCell(withIdentifier: "OrderDetailsTableViewCell") as! OrderDetailsTableViewCell
        header.configureDropDownImage(isExpand: viewModel.arrUserOrderData[section].isExpanded)
        if(section % 2 == 0) {
            header.contentView.backgroundColor = UIColor.white//MyTheme.customColor2
        } else {
            header.contentView.backgroundColor = UIColor.white//MyTheme.customColor1
        }
        if let orderID = viewModel.arrUserOrderData[section].order_id {
            header.orderIDLabel.text = orderID
            header.orderIDLabel.textColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
        }
        if let orderDate = viewModel.arrUserOrderData[section].order_date {
            header.orderDateLabel.text = orderDate
        } else {
            header.orderDateLabel.text = ""
        }
        
        if let shippedDate = viewModel.arrUserOrderData[section].shipped_Date {
            header.orderTimeLabel.text = shippedDate
        } else {
            header.orderTimeLabel.text = ""
        }
        
        if let orderTime = viewModel.arrUserOrderData[section].status {
            header.statusLabel.text = orderTime
        } else {
            header.statusLabel.text = ""
        }
        
        header.didClickReorder = {
            if let orderID = self.viewModel.arrUserOrderData[section].order_id {
                self.OrderId = orderID
                self.callReOrder()
            }
        }
        
        header.expandRowButton.tag = section
        header.btnExpandRow = { [self] in
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
            if (customerType == "Wholesale Customer") {
                appType = KeyConstants.app_TypeDual
            } else {
                appType = KeyConstants.app_TypeRetailer
            }
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String  ?? ""
            if let orderID = viewModel.arrUserOrderData[section].order_id {
                self.OrderId = orderID
                dictParam = [
                    GetOrderDetails.type.rawValue:KeyConstants.appType ,
                    GetOrderDetails.app_type.rawValue:appType,
                    GetOrderDetails.client_code.rawValue:KeyConstants.clientCode ,
                    GetOrderDetails.user_code.rawValue:userID ,
                    GetOrderDetails.order_id.rawValue:orderID,
                    GetOrderDetails.device_id.rawValue:Constants.deviceId
                ]
                
                for i in 0..<viewModel.arrUserOrderData.count {
                    if(header.expandRowButton.tag == i) {
                        if self.viewModel.arrUserOrderData[i].isExpanded {
                            self.viewModel.arrUserOrderData[i].isExpanded = false
                        } else {
                            self.viewModel.arrUserOrderData[i].isExpanded = true
                            self.getOrderDetails(with: dictParam)
                        }
                    } else {
                        self.viewModel.arrUserOrderData[i].isExpanded = false
                    }
                }
                header.configureDropDownImage(isExpand: self.viewModel.arrUserOrderData[section].isExpanded)
                lastOrdersTableView.reloadData()
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36//UITableView.automaticDimension//34
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension//44
    }
}

//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
extension LastOrdersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOfChips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipsCollectionViewCell", for: indexPath) as! ChipsCollectionViewCell
        cell.configureUI()
        cell.configureAccountData(chipsData: viewModel.arrayOfChips[indexPath.row])
        if indexPath.row == viewModel.arrayOfChips.count - 1 {
            cell.rightSeparatorView.backgroundColor = UIColor.white
        } else {
            cell.rightSeparatorView.backgroundColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = StoryBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as? AccountDetailsVC
            self.navigationController?.pushViewController(tabVC!, animated: false)
        } else if indexPath.row == 1 {
            //LastOrdersViewController
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "LastOrdersViewController") as! LastOrdersViewController
            //self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 2 {
            //LinksViewController
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "LinksViewController") as! LinksViewController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 3 {
            //APP USER GUIDE
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "AppInformationViewController") as! AppInformationViewController
            tbc.viewModel.comingFrom = "AppInformation"
            tbc.specialTitle = "APP USER GUIDE"
            self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 4 {
            showPopUpToResetListConfirmation()
        } else if indexPath.row == 5 {
            //Logout
            logoutAccount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if let string = viewModel.arrayOfChips[indexPath.row].name {
        //            let width = ((string.count) * 10)
        //            return CGSize(width: width + (string.count < 5 ? 60 : 12), height: 32)
        //        }
        //        return CGSize(width:0, height: 0)
        //        if let categoryName = self.viewModel.arrayOfChips[indexPath.row].name {
        //            let label = UILabel(frame: CGRect.zero)
        //            label.text = categoryName
        //            label.sizeToFit()
        //            if ((label.frame.size.width) <= 60) {
        //                return CGSize(width:60,height:14)
        //            } else {
        //                return CGSize(width:label.frame.size.width,height:14)
        //            }
        //        }
        //        return CGSize(width:120,height:14)
        //
        if let categoryName = self.viewModel.arrayOfChips[indexPath.row].name {
            let label = UILabel(frame: CGRect.zero)
            label.text = categoryName
            label.sizeToFit()
            // return CGSize(width:label.frame.size.width,height:14)
            if ((label.frame.size.width) <= 60) {
                return CGSize(width:60,height:14)
            } else {
                return CGSize(width:label.frame.size.width,height:14)
            }
        }
        return CGSize(width:120,height:14)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: -> Logout Confirmation Pop-Up
extension LastOrdersViewController: ShowPopupResetListDelegate {
    func showPopUpToResetList() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupResetListViewController") as? PopupResetListViewController
            vc?.strMessage = logoutConfirmationMesssage
            vc?.delegate = self
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    func showPopUP(didTapCancel: Bool, didTapConfirm: Bool) {
        if(didTapCancel){
            print("Cancel Tapped")
        } else if(didTapConfirm){
            print("Yes Tapped")
            self.logoutUser()
        }
    }
}

//MARK: - PopUpDelegate
extension LastOrdersViewController: PopUpDelegate {
    func presentPopUpWithDelegate(strMessage:String,buttonTitle:String) {
        DispatchQueue.main.async {
            guard   let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
            vc.strMessage = strMessage
            vc.buttonTitle = buttonTitle
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func didTapDone() {
        var userId = ""
        var userDefaultId = ""
        if let userid = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String {
            userId = userid
        }
        if let userdefaultId = UserDefaults.standard.object(forKey: UserDefaultsKeys.UserDefaultLoginID) as? String {
            userDefaultId = userdefaultId
        }
        
        if(userId == userDefaultId) {
            self.logoutUser()
        }
        else {
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
            self.pushToOutlets()
        }
    }
}

//MARK: - View-Model Interaction
extension LastOrdersViewController {
    //Fetch-User-Order
    private func fetchUserOder(with param: [String: Any]) {
        viewModel.fetchUserOder(with: param, view: self.view) { result in
            switch result{
            case .success(let userOrderData):
                if let userOrderData = userOrderData {
                    guard let status = userOrderData.status else { return }
                    if (status == 1) {
                        if let data = userOrderData.data {
                            self.viewModel.arrUserOrderData = data
                            print(JSON(data))
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.lastOrdersTableView.reloadData()
                        }
                    } else if(status == 2) {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        DispatchQueue.main.async {
                            guard let messge = userOrderData.message else {return}
                            self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        DispatchQueue.main.async {
                            guard let messge = userOrderData.message else {return}
                            self.presentPopUpVC(message:messge,title: "")
                        }
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
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .none:
                break
            }
            
            self.configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrUserOrderData.count)
        }
    }
    
    //Get-Order-Details
    private func getOrderDetails(with param: [String: Any]) {
        viewModel.getOrderDetails(with: param, view: self.view) { result in
            switch result {
            case .success(let userOrderData):
                if let userOrderData = userOrderData {
                    guard let status = userOrderData.status else { return }
                    if (status == 1) {
                        if let data = userOrderData.data {
                            self.viewModel.arrOrderDetailsData = data
                        }
                        self.lastOrdersTableView.reloadData()
                    } else if(status == 2) {
                        DispatchQueue.main.async {
                            guard let messge = userOrderData.message else {return}
                            self.presentPopUpVC(message:messge,title: "")
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            guard let messge = userOrderData.message else {return}
                            self.presentPopUpVC(message:messge,title: "")
                        }
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
    
    //Fetch-Re-Order
    private func reOrder(with param: [String: Any]) {
        viewModel.reOrder(with: param, view: self.view) { result in
            switch result{
            case .success(let userOrderData):
                if let userOrderData = userOrderData {
                    if let arrayOfReorderList = userOrderData.all_inventories {
                        self.viewModel.arrayOfReorderList = arrayOfReorderList
                        for i in 0..<self.viewModel.arrayOfReorderList.count {
                            Constants.checkItems(localData: self.viewModel.arrayOfReorderList, data: self.viewModel.arrayOfReorderList[i])
                        }
                    }
                    var data = LocalStorage.getShowItData()
                   
                    if let arrayOfReorderList = userOrderData.multi_items {
                        self.viewModel.arrayOfReorderMultiList = arrayOfReorderList
                        for i in 0..<self.viewModel.arrayOfReorderMultiList.count {
                            data.append(self.viewModel.arrayOfReorderMultiList[i])
                            LocalStorage.saveMultiData(data: data)
                        }
                    }
                    let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
                    confirmPaymentVC.tabType = .myOrders
                    self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
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
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .none:
                break
            }
        }
    }
    
    func callReOrder() {
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String  ?? ""
        dictParam = [
            ReOrder.orderId.rawValue:self.OrderId,
            ReOrder.client_code.rawValue:KeyConstants.clientCode ,
            ReOrder.user_code.rawValue:userID,
            ReOrder.device_id.rawValue:Constants.deviceId]
        print(JSON(dictParam))
        self.reOrder(with: dictParam)
    }
}

//MARK: -> LogoutDelegate
extension LastOrdersViewController: LogoutDelegate {
    func logoutAccount(){
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutPopUpViewControllert") as? LogoutPopUpViewControllert
            vc?.titleMessage = logoutConfirmationMesssage
            vc?.delegate = self
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    func successLogout() {
        self.logoutUser()
    }
}

//MARK: -> Handle-Background-State
extension LastOrdersViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        print("handleAppDidBecomeActive")
        if presentingViewController is LastOrdersViewController {
            configureUI()
        }
    }
}


//MARK: - show-PopUp-ToResetListConfirmationDelegate
extension LastOrdersViewController: PopupResetListConfirmationDelegate {
    func showPopUpToResetListConfirmation() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpResetListConfirmationViewController") as? PopUpResetListConfirmationViewController
            vc?.strMessage = "Clicking confirm will re-arrange items in My List in alphabetical order."
            vc?.delegate = self
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    func showPopConfirmationUP(didTapCancel: Bool, didTapConfirm: Bool) {
        if(didTapCancel){
            print("cancel")
        } else if(didTapConfirm){
            print("Confirm")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyListViewController") as? MyListViewController
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isResetList)
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
}
