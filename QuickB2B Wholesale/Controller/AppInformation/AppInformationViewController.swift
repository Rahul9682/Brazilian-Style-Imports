//  AppInformationViewController.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 23/01/2020 Saka.

import UIKit
import WebKit

class AppInformationViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var appNameLabel: BoldLabelSize16!
    @IBOutlet var informationWebView: WKWebView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tabBarView: CustomTabBarView!
    @IBOutlet weak var specialTitlesContainerView: UIView!
    @IBOutlet weak var specialTitleLabel: UILabel!
    @IBOutlet weak var specialTitileHeightConst: NSLayoutConstraint!
    @IBOutlet weak var chipsContainerView: UIView!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var chipsContainerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!
    
    //MARK: - Properties
    var viewModel = AppInformationViewModel()
    var specialTitle = ""
    var background: BackgroundView?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        self.configureCartImage()
        navigationController?.navigationBar.isHidden = true
        //viewModel.comingFrom = "AppInformation" // use forour side
        configureUI()
        registerCell()
        setNeedsStatusBarAppearanceUpdate()
        informationWebView.scrollView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
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
        didEnterBackgroundObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.informationWebView.frame   = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK:- Helper
    private func configureUI() {
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        if(viewModel.comingFrom == "FeaturedProduct") {
            specialTitileHeightConst.constant = 0
            specialTitlesContainerView.isHidden = true
            chipsContainerViewHeightConst.constant = 0
        } else {
            specialTitileHeightConst.constant = 34
            specialTitlesContainerView.isHidden = false
            chipsContainerViewHeightConst.constant = 21
        }
        
        specialTitlesContainerView.layer.cornerRadius = Radius.titleViewRadius
        specialTitleLabel.textColor = UIColor.white
        specialTitleLabel.text = specialTitle
        self.viewModel.arrSuppliers = viewModel.db.readData()
        informationWebView.uiDelegate = self
        informationWebView.navigationDelegate = self
        informationWebView.scrollView.showsVerticalScrollIndicator = false
        informationWebView.scrollView.showsHorizontalScrollIndicator = false
        informationWebView.backgroundColor = UIColor.white
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
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
            GetInformation.type.rawValue:KeyConstants.appType ,
            GetInformation.app_type.rawValue:appType,
            GetInformation.client_code.rawValue:KeyConstants.clientCode,
            GetInformation.user_code.rawValue:userID ,
            GetInformation.device_id.rawValue:Constants.deviceId
        ]
        if(viewModel.comingFrom == "FeaturedProduct") {
            self.getFeaturedProduct(with: dictParam)
        }
        if(viewModel.comingFrom == "AppInformation") {
            self.getAppInformation(with: dictParam)
        }
        setupHamburgerMenu()
        
        viewModel.arrayOfChips.append((AccountChipsData(id: "1", name: "Account", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "2", name: "Past Orders", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "3", name: "Links", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "4", name: "App User Guide", isExpanded: false, isSlected: true)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "5", name: "Reset My List A-Z", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "6", name: "Logout", isExpanded: false, isSlected: false)))
        chipsCollectionView.reloadData()
        totalAmountLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalAmountLabel.addGestureRecognizer(tapGesture)
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
    
    private func setupHamburgerMenu() {
        self.findHamburguerViewController()?.gestureEnabled = false
        self.findHamburguerViewController()?.gestureRecognizer?.isEnabled = false
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
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
            self.navigationController?.pushViewController(vc, animated: false)
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
    
    private func registerCell() {
        chipsCollectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
    }
    //MARK: -> Background View
    private func configureBackground(with image: UIImage?, message: String, count: Int) {
        DispatchQueue.main.async { [self] in
            if count == 0 {
                if self.background == nil {
                    self.background = Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)?.first as? BackgroundView
                    self.background?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.background?.frame = self.backgroundView.bounds
                    self.background?.configureUI(with: image, message: message)
                }
                self.informationWebView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                self.informationWebView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
            }
            background?.refreshButton.isHidden = true//false
            
            self.background?.didClickRefreshButton = {
                //call APi
            }
        }
    }
    
    //MARK: - Button Action
    @IBAction func menuButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    //MARK: - METHOD TO PUSH TO OUTLETS
    func pushToOutlets() {
        guard let  outletVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController else {return}
        self.navigationController?.pushViewController(outletVC, animated: false)
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
        if(viewModel.floatTotalPrice < 0.0){
            viewModel.floatTotalPrice = 0.0
        }
        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        let strTitleTotalPriceButton = "Total" + " " + currencySymbol + strTottalPrice
        self.totalAmountLabel.text = strTitleTotalPriceButton
        self.configureCartImage()
        //self.totalPriceButton.setTitle(strTitleTotalPriceButton , for: .normal)
        //        if strTottalPrice == "0" || strTottalPrice == "0.00" {
        //            totalAmountLabel.isHidden = true
        //        } else {
        //            totalAmountLabel.isHidden = false
        //            self.totalAmountLabel.text = strTitleTotalPriceButton
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
    
    //MARK: -> Button Actions
    @IBAction func cartButton(_ sender: UIButton) {
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

// MARK: - PopUpDelegate
extension AppInformationViewController: PopUpDelegate {
    
    //PRESENT POP UP WITH DELEGATE
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
    
    //POP UP DELEGATE
    func didTapDone() {
        var userId = ""
        var userDefaultId = ""
        if let userid = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String {
            userId = userid
        }
        if let userdefaultId = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String {
            userDefaultId = userdefaultId
        }
        
        if(userId == userDefaultId) {
            self.logOut()
        } else  {
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
            self.pushToOutlets()
        }
    }
}

// MARK: - WKUIDelegate,WKNavigationDelegate
extension AppInformationViewController: WKUIDelegate,WKNavigationDelegate {
    func HTMLImageCorrector(HTMLString: String) -> String {
        var HTMLToBeReturned = HTMLString
        while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil{
            if let match = HTMLToBeReturned.range(of:"(?<=width=\")[^\" height]+", options: .regularExpression) {
                HTMLToBeReturned.removeSubrange(match)
                if let match2 = HTMLToBeReturned.range(of:"(?<=height=\")[^\"]+", options: .regularExpression) {
                    HTMLToBeReturned.removeSubrange(match2)
                    let string2del = "width=\"\" height=\"\""
                    HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of:string2del, with: "")
                }
            }
        }
        return HTMLToBeReturned
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async { self.hideIndicator()
            self.view.isUserInteractionEnabled = true
        }
    }
}

// MARK: - API Integration
extension AppInformationViewController {
    //Get-AppInformation
    private func getAppInformation(with param: [String: Any]) {
        viewModel.getAppInformation(with: param, view: self.view) { result in
            switch result{
            case .success(let getInformationData):
                if let getInformationData = getInformationData {
                    guard let status = getInformationData.status else { return }
                    if (status == 1) {
                        self.configureBackground(with: Icons.noDataFound, message: "", count: 1)
                        if let htmlString = getInformationData.data?.CmsPage?.text {
                            let  htmlStringg = "<meta name=\"viewport\" content=\"initial-scale=1.0\" />" + htmlString
                            self.informationWebView.loadHTMLString(htmlStringg, baseURL: nil)
                        }
                    } else if(status == 2) {
                        self.configureBackground(with: Icons.noDataFound, message: "", count: 0)
                        DispatchQueue.main.async { self.hideIndicator()
                            self.view.isUserInteractionEnabled = true
                        }
                        guard let messge = getInformationData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                    } else {
                        self.configureBackground(with: Icons.noDataFound, message: "", count: 0)
                        DispatchQueue.main.async { self.hideIndicator()
                            self.view.isUserInteractionEnabled = true
                        }
                        guard let messge = getInformationData.message else {return}
                        self.presentPopUpVC(message:messge,title:"")
                    }
                }
            case .failure(let error):
                self.configureBackground(with: Icons.noDataFound, message: "", count: 0)
                DispatchQueue.main.async { self.hideIndicator()
                    self.view.isUserInteractionEnabled = true
                }
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
    
    //get-Featured-Product
    private func getFeaturedProduct(with param: [String: Any]) {
        viewModel.getFeaturedProduct(with: param, view: self.view) { result in
            switch result{
            case .success(let featuredProductData):
                if let featuredProductData = featuredProductData {
                    guard let status = featuredProductData.status else { return }
                    if (status == 1) {
                        self.configureBackground(with: Icons.noDataFound, message: "", count: 1)
                        if let htmlString = featuredProductData.data?.content{
                            let  htmlStringg = "<meta name=\"viewport\" content=\"initial-scale=1.0\" />" + htmlString
                            self.informationWebView.loadHTMLString(htmlStringg, baseURL: nil)
                        }
                    } else if(status == 2) {
                        self.configureBackground(with: Icons.noDataFound, message: "", count: 0)
                        DispatchQueue.main.async { self.hideIndicator()
                            self.view.isUserInteractionEnabled = true
                        }
                        guard let messge = featuredProductData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                    } else {
                        self.configureBackground(with: Icons.noDataFound, message: "", count: 0)
                        DispatchQueue.main.async { self.hideIndicator()
                            self.view.isUserInteractionEnabled = true
                        }
                        guard let messge = featuredProductData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }
                }
            case .failure(let error):
                self.configureBackground(with: Icons.noDataFound, message: "", count: 0)
                DispatchQueue.main.async { self.hideIndicator()
                    self.view.isUserInteractionEnabled = true
                }
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

//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
extension AppInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            //tabVC?.selectedTabIndex = 4
            self.navigationController?.pushViewController(tabVC!, animated: false)
        } else if indexPath.row == 1 {
            //LastOrdersViewController
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "LastOrdersViewController") as! LastOrdersViewController
            self.navigationController?.pushViewController(tbc, animated: false)
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
            //self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 4 {
            showPopUpToResetListConfirmation()
        } else if indexPath.row == 5 {
            //Logout
            logoutAccount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let categoryName = self.viewModel.arrayOfChips[indexPath.row].name {
            let label = UILabel(frame: CGRect.zero)
            label.text = categoryName
            label.sizeToFit()
            if ((label.frame.size.width) <= 60) {
                return CGSize(width:60,height:20)
            } else {
                return CGSize(width:label.frame.size.width,height:20)
            }
        }
        return CGSize(width:120,height:20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func logoutUser() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        self.viewModel.db.deleteByClientCode(strClientCode: clientCode)
        self.viewModel.arrSuppliers = self.viewModel.db.readData()
        self.viewModel.db.deleteByClientCode(strClientCode: clientCode)
        if(self.viewModel.arrSuppliers.count != 0){
            
            if let strAppName = self.viewModel.arrSuppliers[0]["supplier_name"]{
                UserDefaults.standard.set(strAppName, forKey:UserDefaultsKeys.AppName)
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


//MARK: -> Logout Confirmation Pop-Up
extension AppInformationViewController: ShowPopupResetListDelegate {
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

//MARK: -> LogoutDelegate
extension AppInformationViewController: LogoutDelegate {
    func logoutAccount() {
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
extension AppInformationViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        if presentingViewController is AppInformationViewController {
            print("handleAppDidBecomeActive")
            self.configureUI()
        }
    }
}

//MARK: - show-PopUp-ToResetListConfirmationDelegate
extension AppInformationViewController: PopupResetListConfirmationDelegate {
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
