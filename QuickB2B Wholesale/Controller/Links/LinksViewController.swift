//  LinksViewController.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 23/01/2020 Saka.

import UIKit
import WebKit
import MessageUI

class LinksViewController: UIViewController {
    
    //MARK: - Outlet's
    @IBOutlet var linksTableView: UITableView!
    @IBOutlet var lblNoLinks: UILabel!
    @IBOutlet weak var appNameLabel: BoldLabelSize16!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tabBarView: CustomTabBarView!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!
    
    //MARK: - Properties
    var viewModel = LinksViewModel()
    var arrayOfChips = [AccountChipsData]()
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        self.configureCartImage()
        configureUI()
        self.registerCustomCell()
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
    
    //MARK: - Helper
    private func configureUI() {
        titleContainerView.layer.cornerRadius = Radius.titleViewRadius
        titleLabel.textColor = UIColor.white
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        navigationController?.navigationBar.isHidden = true
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
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
            FetchLinks.type.rawValue:KeyConstants.appType ,
            FetchLinks.app_type.rawValue:appType,
            FetchLinks.client_code.rawValue:KeyConstants.clientCode ,
            FetchLinks.user_code.rawValue:userID,
            FetchLinks.device_id.rawValue:Constants.deviceId]
        self.fetchLinks(with: dictParam)
        setNeedsStatusBarAppearanceUpdate()
        setupHamburgerMenu()
        arrayOfChips.append((AccountChipsData(id: "1", name: "Account", isExpanded: false, isSlected: false)))
        arrayOfChips.append((AccountChipsData(id: "2", name: "Past Orders", isExpanded: false, isSlected: false)))
        arrayOfChips.append((AccountChipsData(id: "3", name: "Links", isExpanded: false, isSlected: true)))
        arrayOfChips.append((AccountChipsData(id: "4", name: "App User Guide", isExpanded: false, isSlected: false)))
        arrayOfChips.append((AccountChipsData(id: "5", name: "Reset My List A-Z", isExpanded: false, isSlected: false)))
        arrayOfChips.append((AccountChipsData(id: "6", name: "Logout", isExpanded: false, isSlected: false)))
        chipsCollectionView.reloadData()
        totalAmountLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalAmountLabel.addGestureRecognizer(tapGesture)
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
    
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        var localStorageArray = LocalStorage.getItemsData()
        localStorageArray += LocalStorage.getShowItData()
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
    
    //MARK: - Register Custom Cell
    private func registerCustomCell() {
        linksTableView.register(UINib.init(nibName: "PdfTableViewCell", bundle: nil), forCellReuseIdentifier: "PdfTableViewCell")
        linksTableView.register(UINib.init(nibName: "RequestAnAccountStatementTableViewCell", bundle: nil), forCellReuseIdentifier: "RequestAnAccountStatementTableViewCell")
        linksTableView.register(UINib.init(nibName: "OurWebsiteTableViewCell", bundle: nil), forCellReuseIdentifier: "OurWebsiteTableViewCell")
        linksTableView.register(UINib.init(nibName: "EmailCallTableViewCell", bundle: nil), forCellReuseIdentifier: "EmailCallTableViewCell")
        chipsCollectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
    }
    
    //MARK: - Hamburger Delegates
    private func setupHamburgerMenu() {
        self.findHamburguerViewController()?.gestureEnabled = false
        self.findHamburguerViewController()?.gestureRecognizer?.isEnabled = false
    }
    
    //MARK: - Button Action
    @IBAction func menuButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
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
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
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
            
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
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
                //UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
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
    
    //MARK: - MAKE CALL FUNCTION
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    //MARK: - SEND EMAIL FUNCTION
    private func sendEmail(email:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            present(mail, animated: true)
        } else {
            self.presentPopUpVC(message: "Please set up email account",title: "")
        }
    }
}

//MARK: - Open-Url-Delegate
extension LinksViewController: OpenUrlDelegate {
    func openUrl(url:String) {
        self.openURl(url: url)
    }
    //OPEN URL FUNCTION
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
}

//MARK: - PopUpDelegate
extension LinksViewController: PopUpDelegate {
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
        } else {
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
            self.pushToOutlets()
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension LinksViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: false)
    }
}

//MARK: - Table View Delegates and Datasource
extension LinksViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)  {
            return viewModel.arrWebsiteData.count
        } else if (section == 1) {
            return 1;
        } else if (section == 2) {
            return 1;
        } else {
            return viewModel.arrPdfData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OurWebsiteTableViewCell", for: indexPath) as! OurWebsiteTableViewCell
            if let strLink = viewModel.arrWebsiteData[indexPath.row].link {
                cell.websiteLinkLabel.text = strLink
            }
            if (indexPath.row == 0) {
                cell.ourWebsiteHeightConst.constant = 32
            } else {
                cell.ourWebsiteHeightConst.constant = 0
            }
            cell.selectionStyle = .none
            return cell
        } else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestAnAccountStatementTableViewCell", for: indexPath) as! RequestAnAccountStatementTableViewCell
            cell.requestAnAccountButtoon.setTitle(viewModel.strRequestAccount, for: .normal)
            cell.btnRequestAccount = { [self] in
                if(viewModel.strRequestAccount != "") {
                    self.sendEmail(email: viewModel.strRequestAccount)
                }
            }
            cell.selectionStyle = .none
            return cell
        } else if(indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCallTableViewCell", for: indexPath) as! EmailCallTableViewCell
            cell.selectionStyle = .none
            
            if(viewModel.strEmail == "") {
                cell.emailButton.isHidden = true
                cell.emailButtonHeightConst.constant = 0
            } else {
                cell.emailButton.isHidden = false
                cell.emailButtonHeightConst.constant = 32
                cell.emailButton.setTitle("Email", for: .normal)
            }
            
            if(viewModel.strCall == "") {
                cell.callButtonHeightConst.constant = 0
                cell.callButton.isHidden = true
            } else {
                cell.callButton.isHidden = false
                cell.callButtonHeightConst.constant = 32
                cell.callButton.setTitle("Call", for: .normal)
            }
            
            cell.btnCall = {
                self.callNumber(phoneNumber: self.viewModel.strCall)
            }
            cell.btnEmail = {
                self.sendEmail(email: self.viewModel.strEmail)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PdfTableViewCell", for: indexPath) as! PdfTableViewCell
            cell.selectionStyle = .none
            if  let strPdfTitle = viewModel.arrPdfData[indexPath.row].title {
                cell.pdfTitleLabel.text = strPdfTitle
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            if(viewModel.arrWebsiteData.count == 0) {
                return 0
            } else {
                if (indexPath.row == 0){
                    return 125
                } else{
                    return 120
                }
            }
        } else if (indexPath.section == 1) {
            if(viewModel.strRequestAccount == "") {
                return 0
            } else {
                return 125
            }
        } else if (indexPath.section == 2) {
            if(viewModel.strEmail == "" && viewModel.strCall == "")  {
                return 0
            }
            if(viewModel.strEmail == "") {
                return 130
            }
            if(viewModel.strCall == "") {
                return 130
            }
            else {
                return 180
            }
        } else {
            if(viewModel.arrPdfData.count == 0) {
                return 0
            } else {
                return 150
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
            if let strWebSiteLink = self.viewModel.arrWebsiteData[indexPath.row].link {
                self.openURl(url: strWebSiteLink)
            }
        }
        
        if(indexPath.section == 3) {
            if let strPdfLink = self.viewModel.arrPdfData[indexPath.row].link {
                self.openURl(url: strPdfLink)
            }
        }
    }
}

//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
extension LinksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfChips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipsCollectionViewCell", for: indexPath) as! ChipsCollectionViewCell
        cell.configureUI()
        cell.configureAccountData(chipsData: arrayOfChips[indexPath.row])
        if indexPath.row == arrayOfChips.count - 1 {
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
            //self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 3 {
            //APP USER GUIDE
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "AppInformationViewController") as! AppInformationViewController
            tbc.viewModel.comingFrom = "AppInformation"
            tbc.specialTitle = "APP USER GUIDE"
            self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 4 {
            print("reset List")
            showPopUpToResetListConfirmation()
        }else if indexPath.row == 5 {
            //Logout
            logoutAccount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let categoryName = self.arrayOfChips[indexPath.row].name {
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
}

//MARK: -> Logout Confirmation Pop-Up
extension LinksViewController: ShowPopupResetListDelegate {
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

//MARK: - API Integration
extension LinksViewController {
    //Fetch-Links
    private func fetchLinks(with param: [String: Any]) {
        viewModel.fetchLinks(with: param, view: self.view) { result in
            switch result {
            case .success(let linksData):
                if let linksData = linksData {
                    guard let status = linksData.status else { return }
                    if (status == 1) {
                        if let arrLinksData = linksData.data?.links {
                            self.viewModel.arrLinks = arrLinksData
                        }
                        if let arrWebsitesData = linksData.data?.websites {
                            self.viewModel.arrWebsiteData = arrWebsitesData
                        }
                        if let arrPdfData = linksData.data?.pdf {
                            self.viewModel.arrPdfData = arrPdfData
                        }
                        if let strRequestAccount = linksData.data?.statementEmail {
                            self.viewModel.strRequestAccount = strRequestAccount
                        }
                        if let email = linksData.data?.representatives?.email {
                            self.viewModel.strEmail = email
                        }
                        if let call = linksData.data?.representatives?.phone{
                            self.viewModel.strCall = call
                        }
                        self.linksTableView.delegate = self
                        self.linksTableView.dataSource = self
                        self.linksTableView.reloadData()
                        self.chipsCollectionView.reloadData()
                        
                        
                    } else if(status == 2 ) {
                        self.chipsCollectionView.reloadData()
                        
                        guard let messge = linksData.message else {return}
                        self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "Ok")
                    }
                    else {
                        self.chipsCollectionView.reloadData()
                        
                        guard let messge = linksData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.chipsCollectionView.reloadData()
                }
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
}

//MARK: -> LogoutDelegate
extension LinksViewController: LogoutDelegate {
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
extension LinksViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        print("handleAppDidBecomeActive")
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                updateTotaPrice()
            }
        }
        if presentingViewController is LinksViewController {
            configureUI()
        }
    }
}

//MARK: - show-PopUp-ToResetListConfirmationDelegate
extension LinksViewController: PopupResetListConfirmationDelegate {
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
