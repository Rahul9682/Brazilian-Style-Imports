//  AccountDetailsVC.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/17/21.

import UIKit
import SwiftyJSON

class AccountDetailsVC: UIViewController,UITextFieldDelegate, PopUpDelegate {
    
    //MARK: - Outlets
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var editUserDetailsButton: UIButton!
    @IBOutlet var savePostalAddressButton: UIButton!
    @IBOutlet var saveDeliveryAddressButton: UIButton!
    @IBOutlet var saveUserDetailsButton: UIButton!
    @IBOutlet var editPostalAddress: UIButton!
    @IBOutlet var editDeliveryAddressButton: UIButton!
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var emailUserDetailsLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var businessDetailsLabel: UILabel!
    @IBOutlet var customerIDLabel: UILabel!
    @IBOutlet var userDetailsLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet var deliveryAddressLabel: UILabel!
    @IBOutlet var deliveryStreetLabel: UILabel!
    @IBOutlet var deliverySuburbLabel: UILabel!
    @IBOutlet var deliveryCountryLabel: UILabel!
    @IBOutlet var deliveryStateLabel: UILabel!
    @IBOutlet var deliveryPostCodeLabel: UILabel!
    @IBOutlet var postalAddressLabel: UILabel!
    @IBOutlet var postalStreetLabel: UILabel!
    @IBOutlet var postalSuburbLabel: UILabel!
    @IBOutlet var postalCountryLabel: UILabel!
    @IBOutlet var postalStateLabel: UILabel!
    @IBOutlet var postalPostCodeLabel: UILabel!
    @IBOutlet var customerIDTextField: UITextField!
    @IBOutlet var businssNameTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var deliveryNumberTextField: UITextField!
    @IBOutlet var deliverySubUrbTextField: UITextField!
    @IBOutlet var deliveryCountryTextField: UITextField!
    @IBOutlet var deliveryStateTextField: UITextField!
    @IBOutlet var deliveryPostCodeTextField: UITextField!
    @IBOutlet var postalNumberTextField: UITextField!
    @IBOutlet var postalSuburbTextField: UITextField!
    @IBOutlet var postalCountryTextField: UITextField!
    @IBOutlet var postalStateTextField: UITextField!
    @IBOutlet var postalPostCodeTextField: UITextField!
    @IBOutlet var deliveryNoteLabel: LightLabelSize16!
    @IBOutlet var deliveryNoteTextView: UITextView!
    @IBOutlet var deliveryNoteTextViewHeightConst: NSLayoutConstraint!
    @IBOutlet var saveUserDetailsButtonHeightConst: NSLayoutConstraint!
    @IBOutlet var viewUserDetailsHeightConst: NSLayoutConstraint!
    @IBOutlet var saveDeliveryDetailsButtonHeightConst: NSLayoutConstraint!
    @IBOutlet var viewDeliveryDetailsHeightConst: NSLayoutConstraint!
    @IBOutlet var savePostalDetailsButtonHeightConst: NSLayoutConstraint!
    @IBOutlet var deliveryNoteLabelHeightConst: NSLayoutConstraint!
    @IBOutlet var viewPostaDetailsHeightConst: NSLayoutConstraint!
    @IBOutlet var businessNameTextFieldTopConst: NSLayoutConstraint!
    @IBOutlet var businessDetailsHeightConst: NSLayoutConstraint!
    @IBOutlet var businessDetailLabelTopConst: NSLayoutConstraint!
    @IBOutlet var businessNameTextFieldHeightConst: NSLayoutConstraint!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var specialTitlesContainerView: UIView!
    @IBOutlet weak var specialTitleLabel: UILabel!
    @IBOutlet weak var chipsContainerView: UIView!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var carClick: UIControl!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!
    @IBOutlet weak var switchCustomerButton: UIButton!
    
    //MARK: - Properties
    var viewModel = AccountDetailsVCViewModel()
    var isClickLogout: Bool = false
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    
    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        specialTitlesContainerView.layer.cornerRadius = Radius.titleViewRadius
        specialTitleLabel.textColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        self.viewModel.arrSuppliers = viewModel.db.readData()
        self.findHamburguerViewController()?.gestureEnabled = false
        self.findHamburguerViewController()?.gestureRecognizer?.isEnabled = false
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        customerIDTextField.delegate = self
        businssNameTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        mobileTextField.delegate = self
        deliveryNumberTextField.delegate = self
        deliverySubUrbTextField.delegate = self
        deliveryCountryTextField.delegate = self
        deliveryStateTextField.delegate = self
        deliveryPostCodeTextField.delegate = self
        postalNumberTextField.delegate = self
        postalSuburbTextField.delegate = self
        postalCountryTextField.delegate = self
        postalStateTextField.delegate = self
        postalPostCodeTextField.delegate = self
        saveUserDetailsButtonHeightConst.constant = 0
        saveUserDetailsButton.isHidden = true
        viewUserDetailsHeightConst.constant = 290
        saveDeliveryDetailsButtonHeightConst.constant = 0
        saveDeliveryAddressButton.isHidden = true
        viewDeliveryDetailsHeightConst.constant = 230
        savePostalDetailsButtonHeightConst.constant = 0
        viewPostaDetailsHeightConst.constant = 230
        savePostalAddressButton.isHidden = true
        savePostalAddressButton.layer.cornerRadius = 5
        saveDeliveryAddressButton.layer.cornerRadius = 5
        saveUserDetailsButton.layer.cornerRadius = 5
        customerIDTextField.isEnabled = false
        deliveryNoteTextView.text = ""
        setNeedsStatusBarAppearanceUpdate()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        // self.view.addGestureRecognizer(tap)
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        registerCell()
        viewModel.arrayOfChips.append((AccountChipsData(id: "1", name: "Account", isExpanded: false, isSlected: true)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "2", name: "Past Orders", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "3", name: "Links", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "4", name: "App User Guide", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "5", name: "Reset My List A-Z", isExpanded: false, isSlected: false)))
        viewModel.arrayOfChips.append((AccountChipsData(id: "6", name: "Logout", isExpanded: false, isSlected: false)))
        chipsCollectionView.reloadData()
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        
        if let acm = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID) {
            switchCustomerButton.isHidden = false
        } else {
            switchCustomerButton.isHidden = true
        }
    }
    
    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabbarView.bounds
        tabBar?.configureTabUI(with: .account)
        
        tabBar?.didClickHomeButton = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickMyList = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
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
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickSpecials = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            var localStorageArray = LocalStorage.getFilteredData()
             localStorageArray += LocalStorage.getFilteredMultiData()
            if localStorageArray.count == 0 {
                self.configureTabBar()
                self.presentPopUpVC(message: emptyCart, title: "")
            } else {
                let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
                confirmPaymentVC.tabType = .myOrders
                self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
            }
        }
        
        tabBar?.didClickMore = {
            //            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
            //            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.tabbarView.addSubview(tabBar!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerCell() {
        chipsCollectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureCartImage()
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                updateTotaPrice()
                appNameStackView.distribution = .fillEqually
            }else {
                appNameStackView.distribution = .fill
            }
        }else {
            appNameStackView.distribution = .fillEqually
        }
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Wholesale Customer") {
                businessDetailsHeightConst.constant = 21
                businessNameTextFieldHeightConst.constant = 30
                businessDetailLabelTopConst.constant = 12
                businessNameTextFieldTopConst.constant = 8
                deliveryNoteLabel.isHidden = true
                deliveryNoteLabelHeightConst.constant = 0
                deliveryNoteTextView.isHidden = true
                deliveryNoteTextViewHeightConst.constant = 0
                viewPostaDetailsHeightConst.constant = 270
                self.showPostalAddress()
            } else if(customerType == "Retail Customer") {
                businessDetailsHeightConst.constant = 0
                businessNameTextFieldHeightConst.constant = 0
                businessDetailLabelTopConst.constant = 3
                businessNameTextFieldTopConst.constant = 8
                deliveryNoteLabel.isHidden = false
                deliveryNoteLabelHeightConst.constant = 21
                deliveryNoteTextView.isHidden = false
                deliveryNoteTextViewHeightConst.constant = 60
                viewPostaDetailsHeightConst.constant = 0
                viewUserDetailsHeightConst.constant = 300
                deliveryNoteTextView.layer.borderWidth = 0;
                deliveryNoteTextView.layer.borderColor = UIColor.clear.cgColor
                self.hidePostalAddress()
            }
        }
        didEnterBackgroundObserver()
        chipsCollectionView.reloadData()
        getProfileDataParam()
    }
    
    override func viewDidLayoutSubviews() {
        editUserDetailsButton.setTitleColor(UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0), for: .normal)
        editPostalAddress.setTitleColor(UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0), for: .normal)
        editDeliveryAddressButton.setTitleColor(UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0), for: .normal)
        changePasswordButton.setTitleColor(UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0), for: .normal)
        switchCustomerButton.setTitleColor(UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0), for: .normal)
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
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                self.totalPriceLabel.text = strTitleTotalPriceButton
            } else {
                self.totalPriceLabel.text = ""
            }
        }
        self.configureCartImage()
        //        if strTottalPrice == "0" || strTottalPrice == "0.00" {
        //            totalPriceLabel.isHidden = true
        //        } else {
        //            totalPriceLabel.isHidden = false
        //            self.totalPriceLabel.text = strTitleTotalPriceButton
        //        }
        //self.totalPriceButton.setTitle(strTitleTotalPriceButton , for: .normal)
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
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - Button Action
    @IBAction func menuButton(_ sender: UIButton) {
        self.view.endEditing(true)
        UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func switchCustmerButtonAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey:  UserDefaultsKeys.outletsListData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let switchCustomerVC = storyboard.instantiateViewController(withIdentifier: "CustomerListViewController") as! CustomerListViewController
        self.navigationController?.pushViewController(switchCustomerVC, animated: false)
    }
    
    //MARK: - HIDE POSTAL ADDRESS
    func hidePostalAddress() {
        postalAddressLabel.isHidden = true
        editPostalAddress.isHidden = true
        postalStreetLabel.isHidden = true
        postalNumberTextField.isHidden = true
        postalSuburbLabel.isHidden = true
        postalSuburbTextField.isHidden = true
        postalCountryLabel.isHidden = true
        postalCountryTextField.isHidden = true
        postalStateLabel.isHidden = true
        postalStateTextField.isHidden = true
        postalPostCodeLabel.isHidden = true
        postalPostCodeTextField.isHidden = true
    }
    
    //MARK: - SHOW POSTAL ADDRESS
    func showPostalAddress() {
        postalAddressLabel.isHidden = false
        editPostalAddress.isHidden = false
        postalStreetLabel.isHidden = false
        postalNumberTextField.isHidden = false
        postalSuburbLabel.isHidden = false
        postalSuburbTextField.isHidden = false
        postalCountryLabel.isHidden = false
        postalCountryTextField.isHidden = false
        postalStateLabel.isHidden = false
        postalStateTextField.isHidden = false
        postalPostCodeLabel.isHidden = false
        postalPostCodeTextField.isHidden = false
    }
    
    func configureUserDetailsTextFieldColor(color: UIColor) {
        firstNameTextField.textColor = color
        lastNameTextField.textColor = color
        businssNameTextField.textColor = color
        phoneTextField.textColor = color
        mobileTextField.textColor = color
    }
    
    func configureDeliveryDetailsTextFieldColor(color: UIColor) {
        deliveryNumberTextField.textColor = color
        deliverySubUrbTextField.textColor = color
        deliveryStateTextField.textColor = color
        deliveryCountryTextField.textColor = color
        deliveryPostCodeTextField.textColor = color
    }
    
    func configurePostalDetailsTextFieldColor(color: UIColor) {
        postalNumberTextField.textColor = color
        postalSuburbTextField.textColor = color
        postalStateTextField.textColor = color
        postalCountryTextField.textColor = color
        postalPostCodeTextField.textColor = color
    }
    
    //MARK: - BUTTON ACTION
    
    @IBAction func cartButton(_ sender: Any) {
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
    
    @IBAction func editUserDetailsButton(_ sender: UIButton) {
        self.configureUserDetailsTextFieldColor(color: UIColor.black)
        editUserDetailsButton.isHidden = true
        saveUserDetailsButtonHeightConst.constant = 30
        saveUserDetailsButton.isHidden = false
        deliveryNoteTextView.layer.borderWidth = 1
        deliveryNoteTextView.layer.borderColor = UIColor.darkGray.cgColor
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Retail Customer") {
                viewUserDetailsHeightConst.constant = 360
            } else  {
                viewUserDetailsHeightConst.constant = 340
            }
        }
        configureUserDetailsViewTextField()
        addPaddingInTextField()
    }
    
    @IBAction func saveUserDetailsButton(_ sender: UIButton) {
        if(validateUserDetails()) {
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
            if (customerType == "Wholesale Customer") {
                appType = KeyConstants.app_TypeDual
            } else {
                appType = KeyConstants.app_TypeRetailer
            }
            guard let firstName = firstNameTextField.text else {return}
            guard let lastName = lastNameTextField.text else  {return}
            guard let businessName = businssNameTextField.text else {return}
            guard let phoneNumber = phoneTextField.text?.replacingOccurrences(of: " ", with: "") else {return}
            guard  let mobileNumber = mobileTextField.text?.replacingOccurrences(of: " ", with: "") else {return}
            guard  let email = emailUserDetailsLabel.text else  {return}
            guard let deliveryNote = deliveryNoteTextView.text else {return}
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
            dictParam = [
                EditProfileDetails.type.rawValue:KeyConstants.appType ,
                EditProfileDetails.app_type.rawValue:appType,
                EditProfileDetails.client_code.rawValue:KeyConstants.clientCode ,
                EditProfileDetails.user_code.rawValue:userID ,
                EditProfileDetails.first_name.rawValue:firstName,
                EditProfileDetails.business_name.rawValue:businessName,
                EditProfileDetails.last_name.rawValue:lastName,
                EditProfileDetails.mobile.rawValue:mobileNumber,
                EditProfileDetails.phone.rawValue:phoneNumber,
                EditProfileDetails.email.rawValue:email,
                EditProfileDetails.delivery_note.rawValue:deliveryNote,
                EditProfileDetails.device_id.rawValue:Constants.deviceId
            ]
            self.saveBusinessDetails(with: dictParam)
        }
    }
    
    @IBAction func editDeliveryAddressButton(_ sender: UIButton) {
        self.configureDeliveryDetailsTextFieldColor(color: UIColor.black)
        self.addPaddingToDeliveryAddressTextField()
        editDeliveryAddressButton.isHidden = true
        saveDeliveryDetailsButtonHeightConst.constant = 30
        saveDeliveryAddressButton.isHidden = false
        viewDeliveryDetailsHeightConst.constant = 270
        configureDeliveryAddressViewTextField()
    }
    
    
    @IBAction func saveDeliveryAddressButton(_ sender: UIButton) {
        if(validateDeliveryDetails()) {
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
            if (customerType == "Wholesale Customer") {
                appType = KeyConstants.app_TypeDual
            } else {
                appType = KeyConstants.app_TypeRetailer
            }
            guard let delieveryAddress = deliveryNumberTextField.text else {return}
            guard let deliverySuburb = deliverySubUrbTextField.text else  {return}
            guard let deliveryState = deliveryStateTextField.text else {return}
            guard let deliveryCountry = deliveryCountryTextField.text else {return}
            guard  let deliveryPostCode = deliveryPostCodeTextField.text else {return}
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
            dictParam = [
                EditBusinessDetails.type.rawValue:KeyConstants.appType ,
                EditBusinessDetails.app_type.rawValue:appType,
                EditBusinessDetails.client_code.rawValue:KeyConstants.clientCode ,
                EditBusinessDetails.user_code.rawValue:userID ,
                EditBusinessDetails.delivery_state.rawValue:deliveryState,
                EditBusinessDetails.delivery_suburb.rawValue:deliverySuburb,
                EditBusinessDetails.delivery_country.rawValue:deliveryCountry,
                EditBusinessDetails.delivery_address.rawValue:delieveryAddress,
                EditBusinessDetails.delivery_post_code.rawValue:deliveryPostCode,
                EditBusinessDetails.device_id.rawValue:Constants.deviceId,
            ]
            self.saveDeliveryDetails(with: dictParam)
        }
    }
    
    @IBAction func editPostalAddress(_ sender: UIButton) {
        self.configurePostalDetailsTextFieldColor(color: UIColor.black)
        self.addPaddingToPostalAdressTextField()
        editPostalAddress.isHidden  = true
        savePostalDetailsButtonHeightConst.constant = 30
        viewPostaDetailsHeightConst.constant = 270
        savePostalAddressButton.isHidden = false
        configurePostalAddressViewTextField()
    }
    
    @IBAction func savePostalAddress(_ sender: UIButton) {
        if(validatePostalDetails()) {
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
            if (customerType == "Wholesale Customer") {
                appType = KeyConstants.app_TypeDual
            } else {
                appType = KeyConstants.app_TypeRetailer
            }
            guard let postalAddress = postalNumberTextField.text else {return}
            guard let postalSuburb = postalSuburbTextField.text else  {return}
            guard let postalState = postalStateTextField.text else {return}
            guard let postalCountry = postalCountryTextField.text else {return}
            guard  let postalPostCode = postalPostCodeTextField.text else {return}
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
            dictParam = [
                EditPostalDetails.type.rawValue:KeyConstants.appType ,
                EditPostalDetails.app_type.rawValue:appType,
                EditPostalDetails.client_code.rawValue:KeyConstants.clientCode ,
                EditPostalDetails.user_code.rawValue:userID ,
                EditPostalDetails.postal_state.rawValue:postalState,
                EditPostalDetails.postal_suburb.rawValue:postalSuburb,
                EditPostalDetails.postal_country.rawValue:postalCountry,
                EditPostalDetails.postal_address.rawValue:postalAddress,
                EditPostalDetails.postal_post_code.rawValue:postalPostCode,
                EditPostalDetails.device_id.rawValue:Constants.deviceId]
            self.savePostalDetails(with: dictParam)
        }
    }
    
    @IBAction func changePasswordButtton(_ sender: UIButton) {
        let changePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController
        self.navigationController?.pushViewController(changePasswordVC!, animated: false)
    }
    
    //MARK: - ADD PADDING TO User Deatils TEXT FIELD
    func addPaddingInTextField(){
        businssNameTextField.addPadding()
        firstNameTextField.addPadding()
        lastNameTextField.addPadding()
        phoneTextField.addPadding()
        mobileTextField.addPadding()
    }
    
    //MARK: - Remove Padding From User Details Text Field
    func removePaddingFromUserDetailsTextField(){
        businssNameTextField.removeLeftPadding()
        firstNameTextField.removeLeftPadding()
        lastNameTextField.removeLeftPadding()
        phoneTextField.removeLeftPadding()
        mobileTextField.removeLeftPadding()
    }
    
    //MARK: - Remove Padding From Delivery Address Text Field
    func removePaddingFromDeliveryAddressTextField(){
        deliveryNumberTextField.removeLeftPadding()
        deliverySubUrbTextField.removeLeftPadding()
        deliveryCountryTextField.removeLeftPadding()
        deliveryStateTextField.removeLeftPadding()
        deliveryPostCodeTextField.removeLeftPadding()
    }
    
    //MARK:- ADD PADDING TO DELIVERY ADDRESS TEXT FIELD
    func addPaddingToDeliveryAddressTextField(){
        deliveryNumberTextField.addPadding()
        deliverySubUrbTextField.addPadding()
        deliveryCountryTextField.addPadding()
        deliveryStateTextField.addPadding()
        deliveryPostCodeTextField.addPadding()
    }
    
    //MARK: - Remove Padding From Postal Address Text Field
    func removePaddingFromPostalAddressTextField(){
        postalNumberTextField.removeLeftPadding()
        postalSuburbTextField.removeLeftPadding()
        postalCountryTextField.removeLeftPadding()
        postalStateTextField.removeLeftPadding()
        postalPostCodeTextField.removeLeftPadding()
    }
    
    //MARK: - ADD PADDING TO POSTAL ADDRESS TEXT FIELD
    func addPaddingToPostalAdressTextField(){
        postalNumberTextField.addPadding()
        postalSuburbTextField.addPadding()
        postalCountryTextField.addPadding()
        postalStateTextField.addPadding()
        postalPostCodeTextField.addPadding()
    }
    
    //MARK: - METHOD TO DISABLE ALL TEXTFIELD
    func disableAllTextField() {
        customerIDTextField.isEnabled = false
        businssNameTextField.isEnabled = false
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        phoneTextField.isEnabled = false
        mobileTextField.isEnabled = false
        deliveryNumberTextField.isEnabled = false
        deliverySubUrbTextField.isEnabled = false
        deliveryCountryTextField.isEnabled = false
        deliveryStateTextField.isEnabled = false
        deliveryPostCodeTextField.isEnabled = false
        postalNumberTextField.isEnabled = false
        postalSuburbTextField.isEnabled = false
        postalCountryTextField.isEnabled = false
        postalStateTextField.isEnabled = false
        postalPostCodeTextField.isEnabled = false
    }
    
    //MARK: - METHOD TO CONFIGURE BUSINESS DETAILS  TEXTFIELD
    func configureUserDetailsViewTextField() {
        businssNameTextField.isEnabled = true
        businssNameTextField.layer.borderWidth = 1
        businssNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        firstNameTextField.isEnabled = true
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        lastNameTextField.isEnabled = true
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        mobileTextField.isEnabled  = true
        mobileTextField.layer.borderWidth = 1
        mobileTextField.layer.borderColor = UIColor.darkGray.cgColor
        phoneTextField.isEnabled = true
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.darkGray.cgColor
        
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Retail Customer") {
                deliveryNoteLabel.isHidden = false
                deliveryNoteLabelHeightConst.constant = 21
                deliveryNoteTextView.isEditable = true
                deliveryNoteTextView.isHidden = false
                deliveryNoteTextViewHeightConst.constant = 60
            }
        }
    }
    
    //MARK: - METHOD TO CONFIGURE DELIVERY DETAILS  TEXTFIELD
    func configureDeliveryAddressViewTextField() {
        deliveryNumberTextField.isEnabled = true
        deliveryNumberTextField.layer.borderWidth = 1
        deliveryNumberTextField.layer.borderColor = UIColor.darkGray.cgColor
        deliverySubUrbTextField.isEnabled = true
        deliverySubUrbTextField.layer.borderWidth = 1
        deliverySubUrbTextField.layer.borderColor = UIColor.darkGray.cgColor
        deliveryCountryTextField.isEnabled = true
        deliveryCountryTextField.layer.borderWidth = 1
        deliveryCountryTextField.layer.borderColor = UIColor.darkGray.cgColor
        deliveryStateTextField.isEnabled  = true
        deliveryStateTextField.layer.borderWidth = 1
        deliveryStateTextField.layer.borderColor = UIColor.darkGray.cgColor
        deliveryPostCodeTextField.isEnabled  = true
        deliveryPostCodeTextField.layer.borderWidth = 1
        deliveryPostCodeTextField.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    //MARK:- METHOD TO CONFIGURE POSTAL DETAILS  TEXTFIELD
    func configurePostalAddressViewTextField() {
        postalNumberTextField.isEnabled = true
        postalNumberTextField.layer.borderWidth = 1
        postalNumberTextField.layer.borderColor = UIColor.darkGray.cgColor
        postalSuburbTextField.isEnabled = true
        postalSuburbTextField.layer.borderWidth = 1
        postalSuburbTextField.layer.borderColor = UIColor.darkGray.cgColor
        postalCountryTextField.isEnabled = true
        postalCountryTextField.layer.borderWidth = 1
        postalCountryTextField.layer.borderColor = UIColor.darkGray.cgColor
        postalStateTextField.isEnabled  = true
        postalStateTextField.layer.borderWidth = 1
        postalStateTextField.layer.borderColor = UIColor.darkGray.cgColor
        postalPostCodeTextField.isEnabled  = true
        postalPostCodeTextField.layer.borderWidth = 1
        postalPostCodeTextField.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    //MARK: - METHOD TO DISABLE BUSINESS DETAILS TEXT FIELD
    func disableUserDetailsViewTextField() {
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Retail Customer") {
                deliveryNoteLabel.isHidden = false
                deliveryNoteLabelHeightConst.constant = 21
                deliveryNoteTextView.isHidden = false
                deliveryNoteTextViewHeightConst.constant = 60
                deliveryNoteTextView.isEditable = false
                deliveryNoteTextView.layer.borderWidth = 0
                deliveryNoteTextView.layer.borderColor = UIColor.clear.cgColor
            }
        }
        businssNameTextField.isEnabled = false
        businssNameTextField.layer.borderWidth = 0
        businssNameTextField.layer.borderColor = UIColor.clear.cgColor
        firstNameTextField.isEnabled = false
        firstNameTextField.layer.borderWidth = 0
        firstNameTextField.layer.borderColor = UIColor.clear.cgColor
        lastNameTextField.isEnabled = false
        lastNameTextField.layer.borderWidth = 0
        lastNameTextField.layer.borderColor = UIColor.clear.cgColor
        mobileTextField.isEnabled  = false
        mobileTextField.layer.borderWidth = 0
        mobileTextField.layer.borderColor = UIColor.clear.cgColor
        phoneTextField.isEnabled = false
        phoneTextField.layer.borderWidth = 0
        phoneTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    //MARK: - METHOD TO DISABLE DELIVERY DETAILS TEXT FIELD
    func disableDeliveryAddressViewTextField() {
        deliveryNumberTextField.isEnabled = false
        deliveryNumberTextField.layer.borderWidth = 0
        deliveryNumberTextField.layer.borderColor = UIColor.clear.cgColor
        deliverySubUrbTextField.isEnabled = false
        deliverySubUrbTextField.layer.borderWidth = 0
        deliverySubUrbTextField.layer.borderColor = UIColor.clear.cgColor
        deliveryCountryTextField.isEnabled = false
        deliveryCountryTextField.layer.borderWidth = 0
        deliveryCountryTextField.layer.borderColor = UIColor.clear.cgColor
        deliveryStateTextField.isEnabled  = false
        deliveryStateTextField.layer.borderWidth = 0
        deliveryStateTextField.layer.borderColor = UIColor.clear.cgColor
        deliveryPostCodeTextField.isEnabled  = false
        deliveryPostCodeTextField.layer.borderWidth = 9
        deliveryPostCodeTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    //MARK: - METHOD TO DISABLE POSTAL DETAILS TEXT FIELD
    func disablePostalAddressViewTextField() {
        postalNumberTextField.isEnabled = false
        postalNumberTextField.layer.borderWidth = 0
        postalNumberTextField.layer.borderColor = UIColor.clear.cgColor
        postalSuburbTextField.isEnabled = false
        postalSuburbTextField.layer.borderWidth = 0
        postalSuburbTextField.layer.borderColor = UIColor.clear.cgColor
        postalCountryTextField.isEnabled = false
        postalCountryTextField.layer.borderWidth = 0
        postalCountryTextField.layer.borderColor = UIColor.clear.cgColor
        postalStateTextField.isEnabled  = false
        postalStateTextField.layer.borderWidth = 0
        postalStateTextField.layer.borderColor = UIColor.clear.cgColor
        postalPostCodeTextField.isEnabled  = false
        postalPostCodeTextField.layer.borderWidth = 9
        postalPostCodeTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    //MARK: - CALL GET PROFILE DATA API
    func getProfileDataParam() {
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
//            GetProfile.type.rawValue:KeyConstants.appType ,
//            GetProfile.app_type.rawValue:appType,
            GetProfile.client_code.rawValue:KeyConstants.clientCode ,
            GetProfile.user_code.rawValue:userID ,
            GetProfile.device_id.rawValue:Constants.deviceId
        ]
        print(JSON(dictParam))
        self.getProfileDetails(with: dictParam)
    }
    
    //MARK: - CONFIGURE UI METHOD
    func configureUI() {
        disableAllTextField()
        if  let data = viewModel.profileData {
            if let customerID = data.user_code {
                customerIDTextField.text = customerID
            }
            if let businessName = data.business_name {
                businssNameTextField.text = businessName
            }
            if let firstName = data.first_name {
                firstNameTextField.text = firstName
            }
            
            if let lastName = data.last_name {
                lastNameTextField.text = lastName
            }
            
            if let phoneNumber = data.phone {
                phoneTextField.text = phoneNumber
            }
            
            if let mobileNumber = data.mobile {
                mobileTextField.text = mobileNumber
            }
            
            if let email = data.email {
                emailUserDetailsLabel.text = email
            }
            
            if let deliveryNumber = data.delivery_address {
                deliveryNumberTextField.text = deliveryNumber
            }
            
            if let deliverySuburb = data.delivery_suburb {
                deliverySubUrbTextField.text = deliverySuburb
            }
            
            if let deliveryState = data.delivery_state {
                deliveryStateTextField.text = deliveryState
            }
            
            if let deliveryCountry = data.delivery_country {
                deliveryCountryTextField.text = deliveryCountry
            }
            
            if let deliveryPostCode = data.delivery_post_code {
                deliveryPostCodeTextField.text = deliveryPostCode
            }
            
            if let postalNumber = data.postal_address {
                postalNumberTextField.text = postalNumber
            }
            
            if let postalSuburb = data.postal_suburb {
                postalSuburbTextField.text = postalSuburb
            }
            
            if let postalState = data.postal_state {
                postalStateTextField.text = postalState
            }
            
            if let deliveryNote = data.delivery_note {
                deliveryNoteTextView.text = deliveryNote
            }
            
            if let postalCountry = data.postal_country {
                postalCountryTextField.text = postalCountry
            }
            
            if let postalPostCode = data.postal_post_code {
                postalPostCodeTextField.text = postalPostCode
            }
        }
        chipsCollectionView.reloadData()
    }
    
    //MARK: - METHOD TO HIDE USER DETAILS BUTTON
    func hideSaveUserDetailsButton(){
        editUserDetailsButton.isHidden = false
        saveUserDetailsButton.isHidden = true
        saveUserDetailsButtonHeightConst.constant = 0
        saveUserDetailsButton.isHidden = true
        viewUserDetailsHeightConst.constant = 290
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Retail Customer") {
                viewUserDetailsHeightConst.constant = 300
            } else {
                viewUserDetailsHeightConst.constant = 290
            }
        }
    }
    
    //MARK: - METHOD TO HIDE DELIVERY DETAILS BUTTON
    func hideSaveDeliveryDetailsButton() {
        editDeliveryAddressButton.isHidden = false
        saveDeliveryAddressButton.isHidden = true
        saveDeliveryDetailsButtonHeightConst.constant = 0
        saveDeliveryAddressButton.isHidden = true
        viewDeliveryDetailsHeightConst.constant = 230
    }
    
    //MARK: - METHOD TO HIDE POSTAL DETAILS BUTTON
    func hidePostalDetailsSaveButton() {
        editPostalAddress.isHidden = false
        savePostalAddressButton.isHidden = true
        savePostalDetailsButtonHeightConst.constant = 0
        viewPostaDetailsHeightConst.constant = 230
        savePostalAddressButton.isHidden = true
    }
    
    //MARK: - Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == businssNameTextField) {
            firstNameTextField.becomeFirstResponder()
        } else if(textField == firstNameTextField) {
            lastNameTextField.becomeFirstResponder()
        } else if (textField == lastNameTextField) {
            phoneTextField.becomeFirstResponder()
        } else if (textField == phoneTextField) {
            mobileTextField.becomeFirstResponder()
        } else if(textField == mobileTextField) {
            deliveryNumberTextField.becomeFirstResponder()
        }  else if(textField == deliveryNumberTextField) {
            deliverySubUrbTextField.becomeFirstResponder()
        }  else if(textField == deliverySubUrbTextField) {
            deliveryCountryTextField.becomeFirstResponder()
        } else if(textField == deliveryCountryTextField) {
            deliveryStateTextField.becomeFirstResponder()
        } else if (textField == deliveryStateTextField) {
            deliveryPostCodeTextField.becomeFirstResponder()
        } else if(textField == deliveryPostCodeTextField) {
            postalNumberTextField.becomeFirstResponder()
        } else if(textField == postalNumberTextField) {
            postalSuburbTextField.becomeFirstResponder()
        } else if(textField == postalSuburbTextField) {
            postalCountryTextField.becomeFirstResponder()
        } else if(textField == postalCountryTextField) {
            postalStateTextField.becomeFirstResponder()
        } else if(textField == postalStateTextField) {
            postalPostCodeTextField.becomeFirstResponder()
        } else  {
            postalPostCodeTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == mobileTextField ) {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if(string != ""){
                if(string != numberFiltered){
                    return false
                }
            }
            let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = updatedText.count
            if string != "" {
                if ( count == 4 || count == 8) {
                    textField.text = updatedText + " "
                }
            }
        }
        if(textField == phoneTextField ) {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if(string != ""){
                if(string != numberFiltered){
                    return false
                }
            }
            let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = updatedText.count
            if string != "" {
                if ( count == 2 || count == 7)
                {
                    textField.text = updatedText + " "
                }
            }
        }
        
        if(textField == phoneTextField || textField == mobileTextField) {
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 20
        }
        
        if(textField == deliveryPostCodeTextField || textField == postalPostCodeTextField) {
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 10
        }
        return true
    }
    
    
    //MARK: - PRESENT POP UP WITH DELEGATE
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
    
    //MARK: - Delete Account Button
    @IBAction func deleteAccount(_ sender: UIButton) {
        self.deleteAccount()
    }
    
    //MARK: - POP UP DELEGATE
    func didTapDone() {
        self.logOut()
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
                //UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
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
    
    //MARK: - VALIDATION METHODS
    func validateUserDetails() -> Bool{
        let businessName  = businssNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespaces)
        let mobile = mobileTextField.text?.trimmingCharacters(in: .whitespaces)
        let deliveryNote = deliveryNoteTextView.text?.trimmingCharacters(in: .whitespaces)
        
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Wholesale Customer") {
                if businessName?.count == 0 {
                    self.presentPopUpVC(message:validateBusinessName,title: "")
                    return false
                }
            }
        }
        
        if firstName?.count == 0 {
            self.presentPopUpVC(message:validateFirstName1,title: "")
            return false
        }
        if lastName?.count == 0 {
            self.presentPopUpVC(message:validateLastName,title: "")
            return false
        }
        if phone?.count == 0 {
            self.presentPopUpVC(message:validatePhoneNumber,title: "")
            return false
        }
        if mobile?.count == 0 {
            self.presentPopUpVC(message:validateMobile,title: "")
            return false
        }
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Retail Customer"){
                if(deliveryNote?.count == 0){
                    self.presentPopUpVC(message: validateDeliveryNote,title: "")
                    return false
                }
            }
        }
        return true
    }
    
    func validateDeliveryDetails() -> Bool {
        let deliveryNumber   = deliveryNumberTextField.text?.trimmingCharacters(in: .whitespaces)
        let deliverySuburb = deliverySubUrbTextField.text?.trimmingCharacters(in: .whitespaces)
        let deliveryCountry = deliveryCountryTextField.text?.trimmingCharacters(in: .whitespaces)
        let deliveryState = deliveryStateTextField.text?.trimmingCharacters(in: .whitespaces)
        let deliveryPostCode = deliveryPostCodeTextField.text?.trimmingCharacters(in: .whitespaces)
        if deliveryNumber?.count == 0 {
            self.presentPopUpVC(message:validateDeliveryNumber,title: "")
            return false
        }
        if deliverySuburb?.count == 0 {
            self.presentPopUpVC(message:validateDeliverySubUrb,title: "")
            return false
        }
        if deliveryCountry?.count == 0 {
            self.presentPopUpVC(message:validateDeliveryCountry,title: "")
            return false
        }
        if deliveryState?.count == 0 {
            self.presentPopUpVC(message:validateDeliveryState,title: "")
            return false
        }
        if deliveryPostCode?.count == 0 {
            self.presentPopUpVC(message:valdateDeliveryPostCode,title: "")
            return false
        }
        return true
    }
    
    func validatePostalDetails() -> Bool{
        let postalNumber   = postalNumberTextField.text?.trimmingCharacters(in: .whitespaces)
        let postalSuburb = postalSuburbTextField.text?.trimmingCharacters(in: .whitespaces)
        let postalCountry = postalCountryTextField.text?.trimmingCharacters(in: .whitespaces)
        let postalState = postalStateTextField.text?.trimmingCharacters(in: .whitespaces)
        let postalPostCode = postalPostCodeTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if postalNumber?.count == 0 {
            self.presentPopUpVC(message:validatePostalNumber,title: "")
            return false
        }
        if postalSuburb?.count == 0 {
            self.presentPopUpVC(message:validatePostalSubUrb,title: "")
            return false
        }
        if postalCountry?.count == 0 {
            self.presentPopUpVC(message:validatePostalCountry,title: "")
            return false
        }
        if postalState?.count == 0 {
            self.presentPopUpVC(message:validatePostalState,title: "")
            return false
        }
        if postalPostCode?.count == 0 {
            self.presentPopUpVC(message:validatePostalCode,title: "")
            return false
        }
        return true
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
            //  self.navigationController?.pushViewController(tbc, animated: false)
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
    
    
    
}

//MARK: - View-Model Interaction
extension AccountDetailsVC {
    //Get-Profile-Details
    private func getProfileDetails(with param: [String: Any]) {
        viewModel.getProfileDetails(with: param, view: self.view) { result in
            switch result{
            case .success(let profileData):
                print(profileData)
                if let profileData = profileData {
                    guard let status = profileData.status else { return }
                    if (status == 1) {
                        if let dictProfileData = profileData.data {
                            self.viewModel.profileData = dictProfileData
                            if let outlets = self.viewModel.profileData?.outlets {
                                if(outlets > 1){
                                    self.editPostalAddress.isHidden = true
                                    self.editUserDetailsButton.isHidden = true
                                    self.changePasswordButton.isHidden = true
                                    self.deleteAccountButton.isHidden = true
                                }
                            }
                            self.configureUI()
                        }
                    } else if(status == 2) {
                        guard let messge = profileData.message else {return}
                        self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                    }
                    else {
                        guard let messge = profileData.message else {return}
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
    
    //Save-Delivery-Details
    private func saveDeliveryDetails(with param: [String: Any]) {
        viewModel.saveDeliveryDetails(with: param, view: self.view) { result in
            switch result{
            case .success(let editProfileData):
                if let editProfileData = editProfileData {
                    guard let status = editProfileData.status else { return }
                    if (status == 1) {
                        self.configureDeliveryDetailsTextFieldColor(color: UIColor.lightGray)
                        self.disableDeliveryAddressViewTextField()
                        self.hideSaveDeliveryDetailsButton()
                        self.removePaddingFromDeliveryAddressTextField()
                        guard let messge = editProfileData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    } else if(status == 2) {
                        guard let messge = editProfileData.message else {return}
                        self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                    }
                    else {
                        guard let messge = editProfileData.message else {return}
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
    
    private func savePostalDetails(with param: [String: Any]) {
        viewModel.savePostalDetails(with: param, view: self.view) { result in
            switch result{
            case .success(let editProfileData):
                if let editProfileData = editProfileData {
                    guard let status = editProfileData.status else { return }
                    if (status == 1) {
                        self.configurePostalDetailsTextFieldColor(color: UIColor.lightGray)
                        self.disablePostalAddressViewTextField()
                        self.hidePostalDetailsSaveButton()
                        self.removePaddingFromPostalAddressTextField()
                        guard let messge = editProfileData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }  else if(status == 2) {
                        guard let messge = editProfileData.message else {return}
                        self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                    } else {
                        guard let messge = editProfileData.message else {return}
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
    
    private func saveBusinessDetails(with param: [String: Any]) {
        viewModel.saveBusinessDetails(with: param, view: self.view) { result in
            switch result {
            case .success(let editProfileData):
                if let editProfileData = editProfileData {
                    guard let status = editProfileData.status else { return }
                    if (status == 1) {
                        self.configureUserDetailsTextFieldColor(color: UIColor.lightGray)
                        self.disableUserDetailsViewTextField()
                        self.hideSaveUserDetailsButton()
                        self.removePaddingFromUserDetailsTextField()
                        guard let messge = editProfileData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    } else if(status == 2) {
                        guard let messge = editProfileData.message else {return}
                        self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                    } else {
                        guard let messge = editProfileData.message else {return}
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
}


//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
extension AccountDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            self.navigationController?.pushViewController(tbc, animated: false)
        } else if indexPath.row == 4 {
            print("Reset List")
            showPopUpToResetListConfirmation()
        } else if indexPath.row == 5 {
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
}

//MARK: -> Logout Confirmation Pop-Up
extension AccountDetailsVC: ShowPopupResetListDelegate {
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

//MARK: -> Delete-Account
extension AccountDetailsVC: DeleteAccountDelegate {
    func deleteAccount() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteAccountPopUpViewController") as? DeleteAccountPopUpViewController
            vc?.delegate = self
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    func success() {
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        let deviceID = UserDefaults.standard.object(forKey: "DeviceIdentifier") as? String ?? ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        dictParam = [
            DeleteParam.clientCode.rawValue:KeyConstants.clientCode,
            DeleteParam.userCode.rawValue:userID,
            DeleteParam.deviceId.rawValue:deviceID
        ]
        
        print(JSON(dictParam))
        //self.deleteAccount(with: dictParam)
    }
    
    //MARK: -> Delete-Account
    private func deleteAccount(with param: [String: Any]) {
        self.view.endEditing(true)
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.deleteAccount) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<DeleteAccountModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { self.showIndicator()
            self.view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { self.hideIndicator()
                self.view.isUserInteractionEnabled = true
            }
            
            switch result{
            case .success(let data):
                if let data = data {
                    guard let status = data.status else { return }
                    if (status == 1) {
                        if let message = data.message {
                            self.presentPopUpVC(message: message, title: "")
                        }
                        self.logoutUser()
                    } else {
                        guard let messge = data.message else {return}
                        self.presentPopUpVC(message:messge, title: "")
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                }else  {
                    self.presentPopUpVC(message: serverNotResponding, title: "")
                }
            }
        }
    }
}

//MARK: -> LogoutDelegate
extension AccountDetailsVC: LogoutDelegate {
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

//MARK: - show-PopUp-ToResetListConfirmationDelegate
extension AccountDetailsVC: PopupResetListConfirmationDelegate {
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

struct AccountChipsData: Codable {
    var id: String?
    var name: String?
    var isExpanded = false
    var isSlected: Bool  = false
}


//MARK: -> Handle-Background-State
extension AccountDetailsVC {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        self.updateTotaPrice()
        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String {
            if(customerType == "Wholesale Customer") {
                businessDetailsHeightConst.constant = 21
                businessNameTextFieldHeightConst.constant = 30
                businessDetailLabelTopConst.constant = 12
                businessNameTextFieldTopConst.constant = 8
                deliveryNoteLabel.isHidden = true
                deliveryNoteLabelHeightConst.constant = 0
                deliveryNoteTextView.isHidden = true
                deliveryNoteTextViewHeightConst.constant = 0
                viewPostaDetailsHeightConst.constant = 270
                self.showPostalAddress()
            } else if(customerType == "Retail Customer") {
                businessDetailsHeightConst.constant = 0
                businessNameTextFieldHeightConst.constant = 0
                businessDetailLabelTopConst.constant = 3
                businessNameTextFieldTopConst.constant = 8
                deliveryNoteLabel.isHidden = false
                deliveryNoteLabelHeightConst.constant = 21
                deliveryNoteTextView.isHidden = false
                deliveryNoteTextViewHeightConst.constant = 60
                viewPostaDetailsHeightConst.constant = 0
                viewUserDetailsHeightConst.constant = 300
                deliveryNoteTextView.layer.borderWidth = 0;
                deliveryNoteTextView.layer.borderColor = UIColor.clear.cgColor
                self.hidePostalAddress()
            }
        }
        chipsCollectionView.reloadData()
        if presentingViewController is AccountDetailsVC {
            getProfileDataParam()
        }
    }
}
