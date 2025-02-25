//  ConfirmPaymentViewController.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 5/25/21.

import UIKit
import SwiftyJSON

class ConfirmPaymentViewController: UIViewController,PopUpDelegate,ConfirmPaymentDelegate {
    
    //MARK: - Outlets
    @IBOutlet var editOrderButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var lblTotalPrice: UILabel!
    @IBOutlet var ConfirmAndPayButton: UIButton!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var viewDelivery: UIView!
    @IBOutlet var deliveryChargeLabel: SemiBoldLabelSize14!
    @IBOutlet var deliveryChargeLabelText: SemiBoldLabelSize14!
    @IBOutlet var deliveryLabelText: LightLabelSize14!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet weak var poNumberTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var cardHolderNameTextField: UITextField!
    @IBOutlet var monthTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var cvvTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var appNameStackView: UIStackView!
    
    
    
    //MARK: - Layout Constants
    @IBOutlet var bottomDeliveryChargeLabel: UILabel!
    @IBOutlet var deliveryChargeLabelTextHeightConst: NSLayoutConstraint!
    
    @IBOutlet var deliveryChargeLabelHeightConst: NSLayoutConstraint!
    @IBOutlet var viewDeliveryPoNumberHeightConst: NSLayoutConstraint!
    @IBOutlet var poLabelTextHeightConst: NSLayoutConstraint!
    
    @IBOutlet var poLabelTextTopConst: NSLayoutConstraint!
    @IBOutlet var poNumberTopConstant: NSLayoutConstraint!
    
    @IBOutlet weak var cardSeparatorView: UIView!
    @IBOutlet var confirmPaymentTableView: UITableView!
    @IBOutlet var viewCardInformationContainer: UIView!
    
    @IBOutlet var viewCardInfoHeightConstant: NSLayoutConstraint!
    @IBOutlet var viewCardInfoTopConst: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!
    
    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerContainerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var bannerTableView: UITableView!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    
    
    //MARK: - Properties
    var viewModel = ConfirmPaymentViewModel()
    var arrItemsCategoryData = [GetItemsWithCategoryData]()
    var arrItemsData = [GetItemsData]()
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var pickerView:UIPickerView?
    let toolBar = UIToolbar()
    var arrSelectedItems = [GetItemsData]()
    var arrMultiListItems = [GetItemsData]()
    var sortedItem = [GetItemsData]()
    var showPrice = ""
    var strFeature = ""
    var strMinOrderValue = ""
    var strPoNumber = ""
    var strShowImage = ""
    var strDeliveryCharge = ""
    var strPickUpDelivery = ""
    var strContactNo = ""
    var floatTotalPrice:Float = 0.0
    var strSelectedRadioButton = ""
    var strComment = ""
    var strDeliveryDate = ""
    var strWeekDay = ""
    var showPO = 0
    var arrMonths = [String]()
    var arrYear = [String]()
    var tag = 0
    var strResetValue = "0"
   // var confirmPaymentCell: ConfirmPaymentItemTableViewCell?
    var bottomCell: ConfirmPaymentTableViewCell?
    var isRouteAssigned = false
    var deliveryAvailableDays:GetDeliveryAvailableData?
    var deliveryAvailabelDates = [String]()
    var cardNumber:String?
    var cardHolderName:String?
    var CVVNumber:String?
    var expiryMonth:String?
    var expiryYear:String?
    var arrayOfBanner = [BannerList]()
    var isEdit: Bool = false
    var ind = 0
    var section = 0
    var tabType: TabType = .none
    var isDelivery: Bool = true
    var show_image = ""
    var deliveryDateByPass = "0"
    var testDeliveryDate = "10/05/2024"
    var isOpenCalendar: Bool = false
    var nextDeliveryDate: String = ""
    var minimumOrderQty: Int?
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    var acmCode  = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID)
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureTabBar()
        if #available(iOS 15.0, *) {
            bannerTableView.sectionHeaderTopPadding = 0
        } else {
            //Fallback on earlier versions
        }
        self.lblTotalPrice.isHidden = true
        self.callGetItems()
        self.arrSuppliers = db.readData()
        bannerTableView.delegate = self
        bannerTableView.dataSource = self
        cardNumberTextField.delegate = self
        cardHolderNameTextField.delegate = self
        monthTextField.delegate = self
        yearTextField.delegate = self
        cvvTextField.delegate = self
        confirmPaymentTableView.delegate = self
        confirmPaymentTableView.dataSource = self
        //confirmPaymentTableView.tableFooterView = viewFooter
        self.configureUI()
        if strComment == "" {
            commentTextField.text = ""
        } else {
            commentTextField.text = strComment
        }
        
        if strPoNumber == "" {
            poNumberTextField.text = ""
        } else {
            poNumberTextField.text = strPoNumber
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //self.view.addGestureRecognizer(tap) // comment for getting tableview banner click
        setNeedsStatusBarAppearanceUpdate()
        
        deliveryLabelText.layer.borderWidth = 0.5
        deliveryLabelText.layer.borderColor = UIColor.lightGray.cgColor
        deliveryLabelText.layer.cornerRadius = 4
        
        poNumberTextField.layer.borderWidth = 0.5
        poNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        poNumberTextField.layer.cornerRadius = 4
        
        commentTextField.layer.borderWidth = 0.5
        commentTextField.layer.borderColor = UIColor.lightGray.cgColor
        commentTextField.layer.cornerRadius = 4
        
        editOrderButton.layer.cornerRadius = 4
        ConfirmAndPayButton.layer.cornerRadius = 4
        cardSeparatorView.backgroundColor = UIColor.lightGray
        if let selectedDate = UserDefaults.standard.object(forKey:"SelectedDate")   {
            if(selectedDate as? String ?? "" == "") {
                deliveryLabelText.text = " Next Delivery"
            } else {
                deliveryLabelText.text = selectedDate as? String ?? ""
            }
        }
        else {
            deliveryLabelText.text = " Next Delivery"
        }
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH ALL PRODUCTS",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureCartItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isOpenCalendar = false
        UserDefaults.standard.removeObject(forKey: "test_date")
    }
    
    
    func configureCartItem() {
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                appNameStackView.distribution = .fillEqually
            } else {
                appNameStackView.distribution = .fill
            }
        } else {
            appNameStackView.distribution = .fillEqually
        }
        self.arrSelectedItems = LocalStorage.getItemsData()
        self.arrMultiListItems = LocalStorage.getShowItData()
        if self.arrSelectedItems.count > 0 {
            // Use filter to remove unwanted items based on the condition
            self.arrSelectedItems = self.arrSelectedItems.filter { !($0.originQty == "0" || $0.originQty == "0.00" || $0.originQty == "0.0" || $0.originQty == "" ) }
        }
        
        if self.arrMultiListItems.count > 0 {
            // Use filter to remove unwanted items based on the condition
            self.arrMultiListItems = self.arrMultiListItems.filter { !($0.originQty == "0" || $0.originQty == "0.00" || $0.originQty == "0.0" || $0.originQty == "" ) }
        }
        let mainArr = self.arrSelectedItems + self.arrMultiListItems
         sortedItem = mainArr.sorted { $0.item_name ?? "" < $1.item_name ?? "" }
        updateTotaPrice()
        self.arrMonths = ["MM","01","02","03","04","05","06","07","08","09","10","11","12"]
        self.arrYear = ["YYYY","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2034","2035","2036","2037","2038","2039"]
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        setNeedsStatusBarAppearanceUpdate()
        didEnterBackgroundObserver()
    }
    
    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabbarView.bounds
        tabBar?.configureTabUI(with: self.tabType)
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
        
        tabBar?.didClickMore = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.tabbarView.addSubview(tabBar!)
    }
    
    func sendRequestUpdateUserProductList() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        var arrUpdatedPriceQuantity = [[String:Any]]()
        var arrMultiItemQuantity = [[String:Any]]()
        var localStorageArray = LocalStorage.getItemsData()
        localStorageArray += LocalStorage.getShowItData()
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
        ]
        print("Update",JSON(dictParam))
        self.updateProductList(with: dictParam)
    }
    
    func updateUserProductList() {
        self.view.endEditing(true)
        var localStorageArray = self.arrSelectedItems
        localStorageArray += self.arrMultiListItems
        var arrUpdatedPriceQuantity = [[String:Any]]()
        for i in 0..<localStorageArray.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            var strmeasureQty = ""
            var stroriginQty = ""
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
                strmeasureQty = measureQty
            }
            
            if let originQty  = localStorageArray[i].originQty {
                stroriginQty = originQty
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
        ]
        print("Update",JSON(dictParam))
        self.updateProductList(with: dictParam)
    }
    
    
    func refreshCartProductList() {
        self.view.endEditing(true)
        var arrUpdatedPriceQuantity = [[String:Any]]()
        var localStorageArray = LocalStorage.getItemsData()
        localStorageArray += LocalStorage.getShowItData()
        for i in 0..<localStorageArray.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            var strmeasureQty = ""
            var stroriginQty = ""
            var strIsMeasure = 0
            var strPriority = 1
            var strId = 0
            if let strQuantity = localStorageArray[i].quantity {
                strQuantityy = "0"
            }
            if let strItemName = localStorageArray[i].item_name {
                strItemNamee = strItemName
            }
            if let strItemCode  = localStorageArray[i].item_code {
                strItemCodee = strItemCode
            }
            if let measureQty  = localStorageArray[i].measureQty {
                strmeasureQty = "0"
            }
            
            if let originQty  = localStorageArray[i].originQty {
                stroriginQty = "0"
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
        ]
        print("Update",JSON(dictParam))
        self.updateProductList(with: dictParam)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func DismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    func saveLocalItemsData(data: [GetItemsData],type: String? = nil) {
        if let showList = type {
            do {
                let encodedData = try JSONEncoder().encode(data)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.showList)
                print("Successfully Saved")
            } catch {
                // Failed to encode Contact to Data
                print("Failed to encode [GetItemsData] to Data")
            }
        } else {
            do {
                let encodedData = try JSONEncoder().encode(data)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.getItemsData)
                print("Successfully Saved")
            } catch {
                // Failed to encode Contact to Data
                print("Failed to encode [GetItemsData] to Data")
            }
        }
    }
    
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        // for i in 0..<self.viewModel.arrayOfListItems.count {
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
        
        floatTotalPrice = totalPrice
        
        if(floatTotalPrice < 0.0){
            floatTotalPrice = 0.0
        }
        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        let strTitleTotalPriceButton = "Total" + " " + currencySymbol + strTottalPrice
        
        
        //        if self.showPrice != "0" {
        //            self.lblTotalPrice.text = strTitleTotalPriceButton
        //            self.lblTotalPrice.isHidden = false
        //        } else {
        //            self.lblTotalPrice.text = ""
        //            self.lblTotalPrice.isHidden = true
        //        }
        
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                self.lblTotalPrice.text = strTitleTotalPriceButton
                self.lblTotalPrice.isHidden = false
            } else {
                self.lblTotalPrice.text = ""
                self.lblTotalPrice.isHidden = true
            }
        } else {
            self.lblTotalPrice.text = ""
            self.lblTotalPrice.isHidden = true
        }
        
        
        
        //bottomCell?.strTottalPrice = currencySymbol + strTottalPrice
    }
    
    func updatePaymentCellTotaPrice() {
        var totalPrice:Float! = 0.0
        // for i in 0..<self.viewModel.arrayOfListItems.count {
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
        floatTotalPrice = totalPrice
        if(floatTotalPrice < 0.0){
            floatTotalPrice = 0.0
        }
        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        let strTitleTotalPriceButton = "Total" + " " + currencySymbol + strTottalPrice
        //self.lblTotalPrice.text = strTitleTotalPriceButton
        //bottomCell?.strTottalPrice = currencySymbol + strTottalPrice
        
        if(self.showPrice == "1") {
            print(isDelivery)
            if isDelivery {
                if let minOrderValue = Float(strMinOrderValue) {
                    if(minOrderValue >= floatTotalPrice) {
                        if(isDelivery)  && !(localStorageArray.isEmpty) {
                            if let deliveryCharge = Float(strDeliveryCharge){
                                // floatTotalPrice = floatTotalPrice + deliveryCharge
                                guard let floatTotalPrice  = Float(strTottalPrice) else { return }
                                let totalPrice =  floatTotalPrice + deliveryCharge
                                bottomCell?.strTottalPrice = currencySymbol + "\(totalPrice)"
                                self.shoeDeliveryCharges()
                            }
                        } else {
                            self.hideDeliveryCharges()
                        }
                    } else {
                        self.hideDeliveryCharges()
                        bottomCell?.strTottalPrice = currencySymbol + strTottalPrice
                    }
                }
            } else {
                self.hideDeliveryCharges()
                bottomCell?.strTottalPrice = currencySymbol + strTottalPrice
            }
        }
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
    
    //MARK: - POP UP DELEGATE
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
            self.logOut()
        }
        else {
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
            self.pushToOutlets()
        }
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
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let tbc = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            UserDefaults.standard.removeObject(forKey: "ClientCode")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
    
    //MARK: - Configure UI Method
    func configureUI(){
        searchContainerView.layer.cornerRadius = Radius.searchViewRadius
        searchContainerView.layer.borderWidth = Radius.searchViewborderWidth
        searchContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        findWeekDayFromDate()
        cardNumberTextField.addBorderLayerr()
        cardHolderNameTextField.addBorderLayerr()
        monthTextField.addBorderLayerr()
        yearTextField.addBorderLayerr()
        cvvTextField.addBorderLayerr()
        viewCardInformationContainer.addBorderLayer()
        if(self.showPrice == "0") {
            self.hideDeliveryChargeWithTotalPrice()
        } else {
            if let minOrderValue = Float(strMinOrderValue) {
                if(minOrderValue >= floatTotalPrice) {
                    if(self.strPickUpDelivery == "Pickup") {
                        self.hideDeliveryCharge()
                    } else {
                        if  let deliveryCharge = Float(strDeliveryCharge){
                            floatTotalPrice = floatTotalPrice + deliveryCharge
                            self.showDeliveryCharge()
                        }
                    }
                } else {
                    self.hideDeliveryCharge()
                }
            }
        }
        
        if(self.strPickUpDelivery == "Pickup") {
            deliveryLabelText.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            let strFullMessage = "Please call" + " " + strContactNo + " " + "to arrange a pick up time"
            deliveryLabelText.text = strFullMessage
            deliveryLabelText.textAlignment = .center
        }  else {
            deliveryLabelText.text = strWeekDay + " " + strDeliveryDate
        }
        
        let floatDeliveryCharge = (strDeliveryCharge as NSString).floatValue
        let strTotalPrice:NSString = NSString(format: "%.2f", floatTotalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let strDeliveryCharge:NSString = NSString(format: "%.2f", floatDeliveryCharge)
        let strDeliveryChargeNew:String = strDeliveryCharge as String
        
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        self.lblTotalPrice.text = "Total" + " " + currencySymbol + strTottalPrice
        let strTotalPricePayButton =  "Pay" + " " + currencySymbol + strTottalPrice
        self.deliveryChargeLabelText.text = currencySymbol + strDeliveryChargeNew
        
        guard  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType)  else {return}
        if(customerType as! String == "Wholesale Customer") {
            ConfirmAndPayButton.setTitle("SUBMIT ORDER", for: .normal)
            self.hideCardView()
        } else {
            ConfirmAndPayButton.setTitle(strTotalPricePayButton, for: .normal)
            self.showCardView()
        }
        
        if(self.showPO == 0) {
            self.hidePONumber()
        } else {
            self.showPONumber()
        }
        
        registerCustomCell()
        //confirmPaymentTableView.reloadData()
    }
    
    //MARK: - Register Cell
    func registerCustomCell() {
        confirmPaymentTableView.register(UINib.init(nibName: "ConfirmPaymentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmPaymentItemTableViewCell")
        confirmPaymentTableView.register(UINib.init(nibName: "ConfirmPaymentHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmPaymentHeaderTableViewCell")
        confirmPaymentTableView.register(UINib.init(nibName: "ConfirmPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmPaymentTableViewCell")
        bannerTableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
    }
    
    //MARK: - METHOD TO FIND WEEKDAY FROM DATE
    func findWeekDayFromDate() {
        if(strDeliveryDate != "Next Delivery" || strDeliveryDate != "") {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd/MM/yyyy"
            guard   let newDate = dateFormatterGet.date(from: strDeliveryDate) else {return}
            dateFormatterGet.dateFormat = "EEEE MMMM d, YYYY"
            let weekDay = Calendar.current.component(.weekday, from: newDate)
            if(weekDay == 1)
            {
                self.strWeekDay = "Sunday";
            }
            if(weekDay == 2)
            {
                self.strWeekDay = "Monday";
            }
            if(weekDay == 3)
            {
                self.strWeekDay = "Tuesday";
            }
            if(weekDay == 4)
            {
                self.strWeekDay = "Wednesday";
            }
            if(weekDay == 5)
            {
                self.strWeekDay = "Thursday";
            }
            if(weekDay == 6)
            {
                self.strWeekDay = "Friday";
            }
            if(weekDay == 7)
            {
                self.strWeekDay = "Saturday";
            }
        }
        
    }
    
    //MARK: - METHOD TO ADD PICKER VIEW
    func addPickerView() {
        self.view.endEditing(true)
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: self.view.frame.size.width, height: 180))
        self.pickerView?.backgroundColor = UIColor.white
        self.pickerView?.showsSelectionIndicator = true
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.setValue(UIColor.black, forKey: "textColor")
        pickerView?.selectRow(1, inComponent: 0, animated: false)
        self.view.addSubview(pickerView!)
        
        toolBar.frame = CGRect(x: 0, y: self.view.frame.size.height-pickerView!.frame.size.height-50, width: self.view.frame.size.width, height: 50)
        toolBar.barStyle = UIBarStyle.blackOpaque
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = UIColor.black
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.view.addSubview(toolBar)
    }
    
    //MARK: - METHOD TO DISMISS PICKERVIEW AND TOOLBAR
    @objc func donePicker() {
        self.pickerView?.removeFromSuperview()
        self.toolBar.removeFromSuperview()
    }
    
    //MARK: - CONFIRM PAYMENT DELEGATE
    func goToDashBoard() {
        LocalStorage.clearItemsData()
        LocalStorage.clearMultiItemsData()
//        guard   let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {return}
//        vc.selectedTabIndex = 0
//        self.navigationController?.pushViewController(vc, animated: false)
 //       self.navigationController?.popViewController(animated: false)
        
        let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        // dashboardVC?.selectedTabIndex = 0
        self.navigationController?.pushViewController(dashboardVC!, animated: false)
    }
    
    //MARK: - METHOD TO HIDE DELIVERY CHARGE
    func hideDeliveryCharge() {
        lblTotalPrice.isHidden = false
        deliveryChargeLabel.isHidden = true
        deliveryChargeLabelText.isHidden = true
        bottomDeliveryChargeLabel.backgroundColor = UIColor.clear
        deliveryChargeLabelHeightConst.constant = 0
        deliveryChargeLabelTextHeightConst.constant = 0
    }
    
    //MARK: - METHOD TO Show DELIVERY CHARGE
    func showDeliveryCharge() {
        lblTotalPrice.isHidden = false
        deliveryChargeLabel.isHidden = false
        deliveryChargeLabelText.isHidden = false
        bottomDeliveryChargeLabel.backgroundColor = UIColor.lightGray
        deliveryChargeLabelHeightConst.constant = 30
        deliveryChargeLabelTextHeightConst.constant = 30
    }
    
    //MARK: - METHOD TO HIDE PO NUMBER
    func hidePONumber() {
        //poNumberTopConstant.constant = 0
        //poNumberHeightConstant.constant = 0
        //poLabelTextTopConst.constant = 0
        //poLabelTextHeightConst.constant  = 0
        //viewDeliveryPoNumberHeightConst.constant = 83
    }
    
    //MARK: - METHOD TO Show PO Number
    func showPONumber() {
        //        poNumberTopConstant.constant = 5
        //        poNumberHeightConstant.constant = 25
        //        poLabelTextTopConst.constant = 5
        //        poLabelTextHeightConst.constant  = 25
        //        viewDeliveryPoNumberHeightConst.constant = 113
    }
    
    //MARK: - METHOD TO HIDE DELIVERY CHARGE WITH TOTAL PRICE
    func hideDeliveryChargeWithTotalPrice(){
        deliveryChargeLabel.isHidden = true
        deliveryChargeLabelText.isHidden = true
        bottomDeliveryChargeLabel.backgroundColor = UIColor.clear
        deliveryChargeLabelHeightConst.constant = 0
        deliveryChargeLabelTextHeightConst.constant = 0
        //lblTotalPrice.isHidden = true
    }
    
    //MARK: - METHOD TO HIDE CARD  VIEW
    func hideCardView() {
        //cardSeparatorView.backgroundColor = UIColor.white
        //viewCardInformationContainer.isHidden = true
        //viewCardInfoTopConst.constant = 0
        //viewCardInfoHeightConstant.constant = 0
        bottomCell?.cardInformationViewHeightConst.constant = 0
        bottomCell?.cardInformationContainerView.isHidden = true
        confirmPaymentTableView.reloadData()
    }
    
    //MARK: - METHOD TO SHOW CARD  VIEW
    func showCardView() {
        //viewCardInformationContainer.isHidden = false
        //viewCardInfoTopConst.constant = 11
        //viewCardInfoHeightConstant.constant = 170
        //bottomCell?.cardInfoMainViewHeightConst.constant = 164
        //bottomCell?.cardInfoMainContainerView.isHidden = false
        bottomCell?.cardInformationViewHeightConst.constant = 164
        bottomCell?.cardInformationContainerView.isHidden = false
        confirmPaymentTableView.reloadData()
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func menuButton(_ sender: UIButton) {
        self.view.endEditing(true)
        //UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        //self.findHamburguerViewController()?.showMenuViewController()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func editOrderButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func confirmAndPayButton(_ sender: UIButton) {
        self.configureConfirmAndPay()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "CommonSearchViewController") as! CommonSearchViewController
        vc.tabType = self.tabType
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func validateQuantity(localStorageArray: [GetItemsData]) {
        if let minimumOrderQty = self.minimumOrderQty {
            let arr =  localStorageArray.filter({ $0.quantity != "0" || $0.quantity != "0.00" || $0.quantity != ""})
            if arr.count < minimumOrderQty {
                if sum(localStorageArray: arr) < Double(minimumOrderQty) {
                    self.presentPopUpVC(message: "The minimum total order quantity is \(minimumOrderQty).", title: "")
                } else {
                    if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                        if(customerType as? String  == "Wholesale Customer") {
                            self.placeOrderPopUp()
                        } else {
                            if self.validation() {
                                self.placeOrderPopUp()
                            }
                        }
                    }
                }
            } else {
                if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                    if(customerType as? String  == "Wholesale Customer") {
                        self.placeOrderPopUp()
                    } else {
                        if self.validation() {
                            self.placeOrderPopUp()
                        }
                    }
                }
            }
        }
    }
    
    func sum(localStorageArray: [GetItemsData]) -> Double {
        var total = 0.0
            for item in localStorageArray {
                if let quantity = item.quantity, let doubleValue = Double(quantity) {
                    total += doubleValue
                } else {
                    print("Invalid quantity value: \(item.quantity ?? "nil")")
                }
            }
            return total
    }
    
    //MARK: -> Configure confirm And Pay Order
    func configureConfirmAndPay() {
        var myArr = [GetItemsData]()
        myArr = arrSelectedItems
        myArr += arrMultiListItems
        if let object = myArr.filter({ $0.quantity == "0" || $0.quantity == "0.00" || $0.quantity == ""}).first {
            self.presentPopUpVC(message: "Item Quantity can not be empty", title: "")
        }
        else {
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            var strCardNumber = ""
            var strCardHolderName = ""
            var strCVV = ""
            var strExpiryYear = ""
            var strExpiryMonth = ""
            var strDeliveryDatee = ""
            var strPONumber = ""
            var strCommentt = ""
            var strPickUpDeliveryy = ""
            
            if(bottomCell?.poNumberTextField.text == "") {
                strPONumber = ""
            }else {
                strPONumber = bottomCell?.poNumberTextField.text ?? ""
            }
            
            if(bottomCell?.commentView.text == "") {
                strCommentt = ""
            } else {
                strCommentt = bottomCell?.commentView.text ?? ""
            }
            
            if(self.strDeliveryDate == "Next Delivery"){
                strDeliveryDatee = "Next Delivery"
            } else {
                if(self.strDeliveryDate != "" ){
                    if deliveryDateByPass == "1" {
                        strDeliveryDatee = self.strDeliveryDate
                    } else {
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "dd/MM/yyyy"
                        if let date = dateFormatterGet.date(from: strDeliveryDate) {
                            dateFormatterGet.dateFormat = "yyyy-MM-dd"
                            let strDate = dateFormatterGet.string(from: date)
                            strDeliveryDatee = strDate
                        }
                    }
                }
            }
            
            if(strPickUpDelivery == "Pickup") {
                strPickUpDeliveryy = "pickup"
            } else {
                strPickUpDeliveryy = "delivery"
            }
            
            if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                if(customerType as! String == "Retail Customer") {
                    if(validation()){
                        if let cvv = bottomCell?.cvvTextField.text {
                            strCVV = cvv
                        }
                        if let cardHolderName = bottomCell?.cardHolderNameTextField.text {
                            strCardHolderName = cardHolderName
                        }
                        if let CardNumber = bottomCell?.cardNumberTextField.text {
                            strCardNumber = CardNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        if let expiryMonth = bottomCell?.monthTextField.text {
                            strExpiryMonth = expiryMonth
                        }
                        if let expiryYear = bottomCell?.yearTextField.text {
                            strExpiryYear = expiryYear
                        }
                        appType = KeyConstants.app_TypeRetailer
                    }
                } else if (customerType as! String == "Wholesale Customer") {
                    appType = KeyConstants.app_TypeDual
                    strCVV = ""
                    strCardHolderName = ""
                    strCardNumber = ""
                    strExpiryYear = ""
                    strExpiryMonth = ""
                }
            }
            var  orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
            if(orderFlag == "") {
                orderFlag = "0"
            } else {
                orderFlag = "1"
            }
            var arrItems = [[String:Any]]()
            var localStorageArray = LocalStorage.getItemsData()
            localStorageArray += LocalStorage.getShowItData()
          
            for i in 0..<localStorageArray.count{
                var dict = [String:Any]()
                if let quantity = localStorageArray[i].quantity {
                    dict["quantity"] = quantity
                }
                if let itemCode = localStorageArray[i].item_code {
                    dict["item_code"] = itemCode
                }
                if let comment = localStorageArray[i].comment {
                    dict["comment"] = comment
                }
                
                if let measureQty = localStorageArray[i].measureQty {
                    dict["measureQty"] = measureQty
                }
                
                if let originQty = localStorageArray[i].originQty {
                    dict["originQty"] = originQty
                }
                
                if let id = localStorageArray[i].id {
                    dict["id"] = id
                }
                
                if let priority = localStorageArray[i].priority {
                    dict["priority"] = priority
                }
                
                if let is_meas_box = localStorageArray[i].is_meas_box {
                    dict["is_meas_box"] = is_meas_box
                }
                
                arrItems.append(dict)
            }
            
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String  ?? ""
            dictParam = [
                ConfirmPaymentParam.type.rawValue:KeyConstants.appType ,
                ConfirmPaymentParam.app_type.rawValue:appType,
                ConfirmPaymentParam.client_code.rawValue:KeyConstants.clientCode ,
                ConfirmPaymentParam.user_code.rawValue:userID ,
                ConfirmPaymentParam.Cvc.rawValue:strCVV,
                ConfirmPaymentParam.CardHolderName.rawValue:strCardHolderName,
                ConfirmPaymentParam.CardNumber.rawValue:strCardNumber,
                ConfirmPaymentParam.ExpiryYear.rawValue:strExpiryYear,
                ConfirmPaymentParam.ExpiryMonth.rawValue:strExpiryMonth,
                ConfirmPaymentParam.device_type.rawValue:"I",
                ConfirmPaymentParam.po_number.rawValue:strPONumber,
                ConfirmPaymentParam.comment.rawValue:strCommentt,
                ConfirmPaymentParam.delivery_type.rawValue:strPickUpDeliveryy,
                ConfirmPaymentParam.orderFlag.rawValue:orderFlag,
                ConfirmPaymentParam.delivery_date.rawValue:strDeliveryDatee,
                ConfirmPaymentParam.cartItems.rawValue:arrItems,
                ConfirmPaymentParam.device_id.rawValue:Constants.deviceId,
                ConfirmPaymentParam.deliveryDateByPass.rawValue: self.deliveryDateByPass,
                ConfirmPaymentParam.acm_code.rawValue: acmCode
            ]
            print("Place Order Request Param:: ",JSON(dictParam))
            if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                if(customerType as! String == "Retail Customer") {
                    if(validation()){
                        self.confirmAndPay(with: dictParam)
                    }
                } else if(customerType as! String == "Wholesale Customer") {
                    self.confirmAndPay(with: dictParam)
                }
            }
        }
    }
    
    
    func TestconfigureConfirmAndPay() {
        if let object = arrSelectedItems.filter({ $0.quantity == "0" || $0.quantity == "0.00" || $0.quantity == ""}).first {
            self.presentPopUpVC(message: "Item Quantity can not be empty", title: "")
        }
        else {
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            var dictParam = [String:Any]()
            var appType = ""
            var strCardNumber = ""
            var strCardHolderName = ""
            var strCVV = ""
            var strExpiryYear = ""
            var strExpiryMonth = ""
            var strDeliveryDatee = ""
            var strPONumber = ""
            var strCommentt = ""
            var strPickUpDeliveryy = ""
            
            if(bottomCell?.poNumberTextField.text == "") {
                strPONumber = ""
            }else {
                strPONumber = bottomCell?.poNumberTextField.text ?? ""
            }
            
            if(bottomCell?.commentView.text == "") {
                strCommentt = ""
            }else {
                strCommentt = bottomCell?.commentView.text ?? ""
            }
            
            if(self.testDeliveryDate == "Next Delivery"){
                strDeliveryDatee = "Next Delivery"
            } else {
                if(self.testDeliveryDate != "" ){
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "dd/MM/yyyy"
                    
                    if let date = dateFormatterGet.date(from: testDeliveryDate) {
                        dateFormatterGet.dateFormat = "yyyy-MM-dd"
                        let strDate = dateFormatterGet.string(from: date)
                        strDeliveryDatee = strDate
                    }
                }
            }
            
            if(strPickUpDelivery == "Pickup") {
                strPickUpDeliveryy = "pickup"
            } else {
                strPickUpDeliveryy = "delivery"
            }
            
            if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                if(customerType as! String == "Retail Customer") {
                    if(validation()){
                        if let cvv = bottomCell?.cvvTextField.text {
                            strCVV = cvv
                        }
                        if let cardHolderName = bottomCell?.cardHolderNameTextField.text {
                            strCardHolderName = cardHolderName
                        }
                        if let CardNumber = bottomCell?.cardNumberTextField.text {
                            strCardNumber = CardNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        if let expiryMonth = bottomCell?.monthTextField.text {
                            strExpiryMonth = expiryMonth
                        }
                        if let expiryYear = bottomCell?.yearTextField.text {
                            strExpiryYear = expiryYear
                        }
                        appType = KeyConstants.app_TypeRetailer
                    }
                } else if (customerType as! String == "Wholesale Customer") {
                    appType = KeyConstants.app_TypeDual
                    strCVV = ""
                    strCardHolderName = ""
                    strCardNumber = ""
                    strExpiryYear = ""
                    strExpiryMonth = ""
                }
            }
            var  orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
            if(orderFlag == "") {
                orderFlag = "0"
            } else {
                orderFlag = "1"
            }
            var arrItems = [[String:Any]]()
            var localStorageArray = LocalStorage.getItemsData()
            for i in 0..<localStorageArray.count{
                var dict = [String:Any]()
                if let quantity = localStorageArray[i].quantity {
                    dict["quantity"] = quantity
                }
                if let itemCode = localStorageArray[i].item_code {
                    dict["item_code"] = itemCode
                }
                if let comment = localStorageArray[i].comment {
                    dict["comment"] = comment
                }
                arrItems.append(dict)
            }
            
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String  ?? ""
            dictParam = [
                ConfirmPaymentParam.type.rawValue:KeyConstants.appType ,
                ConfirmPaymentParam.app_type.rawValue:appType,
                ConfirmPaymentParam.client_code.rawValue:KeyConstants.clientCode ,
                ConfirmPaymentParam.user_code.rawValue:userID ,
                ConfirmPaymentParam.Cvc.rawValue:strCVV,
                ConfirmPaymentParam.CardHolderName.rawValue:strCardHolderName,
                ConfirmPaymentParam.CardNumber.rawValue:strCardNumber,
                ConfirmPaymentParam.ExpiryYear.rawValue:strExpiryYear,
                ConfirmPaymentParam.ExpiryMonth.rawValue:strExpiryMonth,
                ConfirmPaymentParam.device_type.rawValue:"1",
                ConfirmPaymentParam.po_number.rawValue:strPONumber,
                ConfirmPaymentParam.comment.rawValue:strCommentt,
                ConfirmPaymentParam.delivery_type.rawValue:strPickUpDeliveryy,
                ConfirmPaymentParam.orderFlag.rawValue:orderFlag,
                ConfirmPaymentParam.delivery_date.rawValue:testDeliveryDate,
                ConfirmPaymentParam.cartItems.rawValue:arrItems,
                ConfirmPaymentParam.device_id.rawValue:Constants.deviceId,
                ConfirmPaymentParam.deliveryDateByPass.rawValue: self.deliveryDateByPass
            ]
            print("Place Order Request Param:: ",JSON(dictParam))
            if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                if(customerType as! String == "Retail Customer") {
                    if(validation()){
                        self.confirmAndPay(with: dictParam)
                    }
                } else if(customerType as! String == "Wholesale Customer") {
                    self.confirmAndPay(with: dictParam)
                }
            }
        }
    }
    
    //MARK: - METHOD TO VALIDATE CARD NUMBER
    func validation()->Bool {
        if(bottomCell?.cardNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) {
            self.presentPopUpVC(message: validateCardNumber,title: "")
            return false
        }  else if(bottomCell?.cardHolderNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) {
            self.presentPopUpVC(message:vaidateCardHolderName,title: "")
            return false
        } else if(bottomCell?.monthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 || monthTextField.text == "MM") {
            self.presentPopUpVC(message: validateExpiryMonth,title: "")
            return false
        } else if(bottomCell?.yearTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 || bottomCell?.yearTextField.text == "YYYY") {
            self.presentPopUpVC(message: validateExpiryYear,title: "")
            return false
        } else if(bottomCell?.cvvTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) {
            self.presentPopUpVC(message: validateCVV,title: "")
            return false
        }
        return true
    }
}

//MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension ConfirmPaymentViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(tag == 1) {
            return self.arrYear.count
        } else if(tag == 2){
            return  self.arrMonths.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(tag == 1) {
            //yearTextField.text = self.arrYear[row]
            bottomCell?.yearTextField.text = self.arrYear[row]
        } else {
            //monthTextField.text = self.arrMonths[row]
            bottomCell?.monthTextField.text = self.arrMonths[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(tag == 1) {
            return self.arrYear[row]
        } else {
            return self.arrMonths[row]
        }
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ConfirmPaymentViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == bannerTableView {
            return nil
        } else {
            if section == 0 {
                let cell = confirmPaymentTableView.dequeueReusableCell(withIdentifier: "ConfirmPaymentHeaderTableViewCell") as! ConfirmPaymentHeaderTableViewCell
                cell.configureShowPrice(showPrice: self.showPrice)
                return cell.contentView
            } else {
                return nil
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == bannerTableView {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bannerTableView {
            return 1
        } else {
            switch section {
            case 0:
                if sortedItem.count > 0 {
                    return sortedItem.count
                }
                return 0
            case 1:
//                if arrMultiListItems.count > 0 {
//                    return arrMultiListItems.count
//                }
                return 0
            case 2:
                return 1
            default:
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bannerTableView {
            let banner = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
            banner.isTest = false
            banner.delegeteBannerImageClick = self
            banner.configureUI()
            banner.configureUI(with: self.arrayOfBanner)
            return banner
        } else {
            switch indexPath.section {
            case 0 :
               let  confirmPaymentCell = confirmPaymentTableView.dequeueReusableCell(withIdentifier: "ConfirmPaymentItemTableViewCell", for: indexPath) as! ConfirmPaymentItemTableViewCell
                confirmPaymentCell.selectionStyle = .none
                confirmPaymentCell.delegeteGetStringText = self
                //confirmPaymentCell?.quantityTextField.delegate = self
                confirmPaymentCell.configureShowPrice(showPrice: self.showPrice)
             
                confirmPaymentCell.configureUI()
                confirmPaymentCell.configureEdit(isEdit: self.isEdit)
                confirmPaymentCell.configureMeasure(isEdit: self.isEdit, isMeasure: self.sortedItem[indexPath.row].is_meas_box ?? 0)
                confirmPaymentCell.configureShowImage(showImage: self.show_image)
                confirmPaymentCell.congifureMeasureTextfield(measure: self.sortedItem[indexPath.row].is_meas_box ?? 0)
                confirmPaymentCell.didChangeText = {
                    //self.confirmPaymentCell?.index = indexPath.row
                    self.ind = indexPath.row
                    self.section = indexPath.section
                }
                confirmPaymentCell.confiqureDashLine(isMeasure: self.sortedItem[indexPath.row].is_meas_box ?? 0)
                confirmPaymentCell.quantityTextField.text  = ""
                //if let quantity = Constants.getPrice(itemCode: self.sortedItem[indexPath.row].item_code) {
                //let floatQuantity = (quantity as NSString).floatValue.clean
                //let strQuantity = String(floatQuantity)
                //confirmPaymentCell?.quantityTextField.text = strQuantity// as String
                //} else {
                //print("else")
                //confirmPaymentCell?.quantityTextField.text  = ""
                //}
                if let quantity = self.sortedItem[indexPath.row].originQty {
                    let floatQuantity = (quantity as NSString).floatValue
                    let strTotalPrice:NSString = NSString(format: "%.2f", floatQuantity)
                    let strTottalPrice:String = strTotalPrice as String
                    confirmPaymentCell.quantityTextField.text = strTottalPrice
                } else {
                    print("else")
                    confirmPaymentCell.quantityTextField.text  = ""
                }
                
                if let measureQty = self.sortedItem[indexPath.row].measureQty {
                    let floatQuantity = (measureQty as NSString).floatValue
                    let strTotalPrice:NSString = NSString(format: "%.2f", floatQuantity)
                    let strTottalPrice:String = strTotalPrice as String
                    confirmPaymentCell.measureTextField.text = strTottalPrice
                } else {
                    print("else")
                    confirmPaymentCell.measureTextField.text  = ""
                }
                
                if let thumb_image = self.sortedItem[indexPath.row].thumb_image {
                    confirmPaymentCell.productImageIcon.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
                } else if let image = self.sortedItem[indexPath.row].image {
                    confirmPaymentCell.productImageIcon.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
                } else {
                    confirmPaymentCell.productImageIcon.image = Icons.placeholderImage
                }
                
                if let price = self.sortedItem[indexPath.row].item_price {
                    let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
                    if let quantity = self.sortedItem[indexPath.row].quantity {
                        let floatQuantity = (quantity as NSString).floatValue
                        let floatPrice = (price as NSString).floatValue
                        //let totalPrice = floatQuantity * floatPrice //if show total price with quantity the uncomment
                        let totalPrice =  floatPrice // show only price
                        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
                        let strTottalPrice:String = strTotalPrice as String
                        confirmPaymentCell.priceLabel.text  = currencySymbol + strTottalPrice
                    }
                }
                
                if let itemName = self.sortedItem[indexPath.row].item_name {
                    confirmPaymentCell.itemNameLabel.text  = itemName
                }
                
                confirmPaymentCell.didClickRemove = {
                    print("remove item")
                    if self.sortedItem[indexPath.row].priority ==  0 {
                        var i = 0
                        for i in 0..<self.arrMultiListItems.count {
                            if self.arrMultiListItems[i].originQty == self.sortedItem[indexPath.row].originQty &&  self.arrMultiListItems[i].measureQty == self.sortedItem[indexPath.row].measureQty && self.arrMultiListItems[i].item_code == self.sortedItem[indexPath.row].item_code {
                                self.arrMultiListItems[i].quantity = "0"
                                self.arrMultiListItems[i].originQty = "0"
                                self.arrMultiListItems[i].measureQty = "0"
                                self.saveLocalItemsData(data: self.arrMultiListItems,type: "showlist")
                                break
                            }
                        }
                        
                    } else {
                        var i = 0
                        for i in 0..<self.arrSelectedItems.count {
                            if self.arrSelectedItems[i].originQty == self.sortedItem[indexPath.row].originQty &&  self.arrSelectedItems[i].measureQty == self.sortedItem[indexPath.row].measureQty && self.arrSelectedItems[i].item_code == self.sortedItem[indexPath.row].item_code {
                                self.arrSelectedItems[i].quantity = "0"
                                self.arrSelectedItems[i].originQty = "0"
                                self.arrSelectedItems[i].measureQty = "0"
                               
                                self.saveLocalItemsData(data: self.arrSelectedItems)
                                break
                            }
                        }
                        
                    }
                    self.sortedItem.remove(at: indexPath.row)
                    self.sendRequestUpdateUserProductList()
                    self.updateTotaPrice()
                    self.confirmPaymentTableView.reloadData()
                }
                
                return confirmPaymentCell
            case 1:
                //MARK: - Show Multi List
                let  confirmPaymentCell = confirmPaymentTableView.dequeueReusableCell(withIdentifier: "ConfirmPaymentItemTableViewCell", for: indexPath) as! ConfirmPaymentItemTableViewCell
                confirmPaymentCell.selectionStyle = .none
                confirmPaymentCell.delegeteGetStringText = self
                //confirmPaymentCell?.quantityTextField.delegate = self
                confirmPaymentCell.configureShowPrice(showPrice: self.showPrice)
                confirmPaymentCell.configureUI()
                confirmPaymentCell.configureEdit(isEdit: self.isEdit)
                confirmPaymentCell.configureMeasure(isEdit: self.isEdit, isMeasure: self.arrMultiListItems[indexPath.row].is_meas_box ?? 0)
                confirmPaymentCell.configureShowImage(showImage: self.show_image)
                confirmPaymentCell.congifureMeasureTextfield(measure: self.arrMultiListItems[indexPath.row].is_meas_box ?? 0)
                confirmPaymentCell.didChangeText = {
                    //self.confirmPaymentCell?.index = indexPath.row
                    self.ind = indexPath.row
                    self.section = indexPath.section
                }
                
                confirmPaymentCell.quantityTextField.text  = ""
                //if let quantity = Constants.getPrice(itemCode: self.arrSelectedItems[indexPath.row].item_code) {
                //let floatQuantity = (quantity as NSString).floatValue.clean
                //let strQuantity = String(floatQuantity)
                //confirmPaymentCell?.quantityTextField.text = strQuantity// as String
                //} else {
                //print("else")
                //confirmPaymentCell?.quantityTextField.text  = ""
                //}
                if let quantity = self.arrMultiListItems[indexPath.row].originQty {
                    let floatQuantity = (quantity as NSString).floatValue
                    let strTotalPrice:NSString = NSString(format: "%.2f", floatQuantity)
                    let strTottalPrice:String = strTotalPrice as String
                    confirmPaymentCell.quantityTextField.text = strTottalPrice
                } else {
                    print("else")
                    confirmPaymentCell.quantityTextField.text  = ""
                }
                
                if let measureQty = self.arrMultiListItems[indexPath.row].measureQty {
                    let floatQuantity = (measureQty as NSString).floatValue
                    let strTotalPrice:NSString = NSString(format: "%.2f", floatQuantity)
                    let strTottalPrice:String = strTotalPrice as String
                    confirmPaymentCell.measureTextField.text = strTottalPrice
                } else {
                    print("else")
                    confirmPaymentCell.measureTextField.text  = ""
                }
                
                if let thumb_image = self.arrMultiListItems[indexPath.row].thumb_image {
                    confirmPaymentCell.productImageIcon.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
                } else if let image = self.arrMultiListItems[indexPath.row].image {
                    confirmPaymentCell.productImageIcon.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
                } else {
                    confirmPaymentCell.productImageIcon.image = Icons.placeholderImage
                }
                
                if let price = self.arrMultiListItems[indexPath.row].item_price {
                    let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
                    if let quantity = self.arrMultiListItems[indexPath.row].quantity {
                        let floatQuantity = (quantity as NSString).floatValue
                        let floatPrice = (price as NSString).floatValue
                        //let totalPrice = floatQuantity * floatPrice //if show total price with quantity the uncomment
                        let totalPrice =  floatPrice // show only price
                        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
                        let strTottalPrice:String = strTotalPrice as String
                        confirmPaymentCell.priceLabel.text  = currencySymbol + strTottalPrice
                    }
                }
                
                if let itemName = self.arrMultiListItems[indexPath.row].item_name {
                    confirmPaymentCell.itemNameLabel.text  = itemName
                }
                
                confirmPaymentCell.didClickRemove = {
                    print("remove item")
                    //                    self.arrSelectedItems[indexPath.row].quantity = "0"
                    //                    self.saveLocalItemsData(data: self.arrSelectedItems)
                    //                    self.arrSelectedItems.remove(at: indexPath.row)
                    //                    self.updateTotaPrice()
                    //                    self.sendRequestUpdateUserProductList()
                    //                    self.confirmPaymentTableView.reloadData()
                    self.arrMultiListItems[indexPath.row].quantity = "0"
                    self.arrMultiListItems[indexPath.row].originQty = "0"
                    self.arrMultiListItems[indexPath.row].measureQty = "1"
                    self.saveLocalItemsData(data: self.arrMultiListItems, type: "showlist")
                    self.sendRequestUpdateUserProductList()
                    var myArray = [GetItemsData]()
                    myArray.removeAll()
                    for i in 0..<self.arrMultiListItems.count {
                        if let quantity = self.arrMultiListItems[i].quantity {
                            if quantity != "0.00" && quantity != "0" && quantity != ""  {
                                myArray.append(self.arrMultiListItems[i])
                            }
                        }
                    }
                    self.saveLocalItemsData(data: myArray,type: "showlist")
                    self.arrMultiListItems.remove(at: indexPath.row)
                    self.updateTotaPrice()
                    self.confirmPaymentTableView.reloadData()
                }
                return confirmPaymentCell
            case 2:
                //MARK: - Delivery View Cell
                bottomCell = confirmPaymentTableView.dequeueReusableCell(withIdentifier: "ConfirmPaymentTableViewCell", for: indexPath) as! ConfirmPaymentTableViewCell
                bottomCell?.selectionStyle = .none
                bottomCell?.cardHolderNameTextField.delegate = self
                bottomCell?.cardNumberTextField.delegate = self
                bottomCell?.monthTextField.delegate = self
                bottomCell?.yearTextField.delegate = self
                bottomCell?.cvvTextField.delegate = self
                bottomCell?.poNumberTextField.delegate = self
                bottomCell?.commentView.delegate = self
                bottomCell?.cardNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
                let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
                bottomCell?.deliverYChargeLabelText.text = currencySymbol + self.strDeliveryCharge
                self.updatePaymentCellTotaPrice()
                
                bottomCell?.poNumberText = { poNumber in
                    self.strPoNumber = poNumber
                }
                
                //MARK: -> didClickDelivery
                bottomCell?.didClickDelivery =  {
                    self.isDelivery = true
                    //self.strPickUpDelivery = "delivery"
                    self.strPickUpDelivery = "Delivery"
                    self.selectDeliveryButton()
                }
                //MARK: -> didClickPickUp
                bottomCell?.didClickPickUp =  {
                    self.strPickUpDelivery = "Pickup"
                    self.isDelivery = false
                    self.selectPickUpButton()
                }
                
                bottomCell?.didClickPickDate = {
                    self.showCalendar()
                }
                
                bottomCell?.cardNumberText = { cardNumber in
                    self.cardNumber = cardNumber
                }
                
                bottomCell?.cardHolderNameText = { cardHolderName in
                    self.cardHolderName = cardHolderName
                }
                
                bottomCell?.CVVNumberText = { cVVNumber in
                    self.CVVNumber = cVVNumber
                }
                
                if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                    if(customerType as? String  == "Wholesale Customer") {
                        bottomCell?.hideCardView()
                    } else {
                        self.strPickUpDelivery = "Delivery"
                        bottomCell?.showCardView()
                    }
                }
                
                bottomCell?.didClickSubmit = {
                    if(self.strPickUpDelivery == "Delivery") {
                        if(self.isRouteAssigned) {
                            if(self.bottomCell?.deliveryDateLabelText.text == "Next Delivery" || self.bottomCell?.deliveryDateLabelText.text == "") {
                                self.presentPopUpVC(message: validateDeliveryDate,title: "")
                            }
                        }
                    }
                    if self.arrSelectedItems.count > 0  || self.arrMultiListItems.count > 0 {
                        for i in 0..<self.arrSelectedItems.count {
                            Constants.checkItems(localData: LocalStorage.getItemsData(), data: self.arrSelectedItems[i])
                        }
                        for i in 0..<self.arrMultiListItems.count {
                            Constants.checkItems(localData: LocalStorage.getItemsData(), data: self.arrMultiListItems[i])
                        }
                        self.updateTotaPrice()
                        var myArray = [GetItemsData]()
                        var myArray2 = [GetItemsData]()
                        myArray.removeAll()
                        myArray2.removeAll()
                        for i in 0..<self.arrSelectedItems.count {
                            if let quantity = self.arrSelectedItems[i].quantity {
                                if quantity != "0.00" && quantity != "0" && quantity != ""  {
                                    print("append")
                                    myArray.append(self.arrSelectedItems[i])
                                }
                            }
                        }
                        
                        for i in 0..<self.arrMultiListItems.count {
                            if let quantity = self.arrMultiListItems[i].quantity {
                                if quantity != "0.00" && quantity != "0" && quantity != ""  {
                                    print("append")
                                    myArray2.append(self.arrMultiListItems[i])
                                }
                            }
                        }
                        self.saveLocalItemsData(data: myArray2, type: "showList")
                        self.saveLocalItemsData(data: myArray)
                        
                        var myArray3 = [GetItemsData]()
                        myArray3 = self.arrSelectedItems
                        myArray += self.arrMultiListItems
                        if let object = myArray.filter({ $0.quantity == "0" || $0.quantity == "0.00" || $0.quantity == ""}).first {
                            self.presentPopUpVC(message: "Item Quantity can not be empty", title: "")
                        } else {
                            
                            self.validateQuantity(localStorageArray: LocalStorage.getFilteredData() + LocalStorage.getFilteredMultiData())
//                            if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
//                                if(customerType as? String  == "Wholesale Customer") {
//                                    self.placeOrderPopUp()
//                                } else {
//                                    if self.validation() {
//                                        self.placeOrderPopUp()
//                                    }
//                                }
//                            }
                        }
                    } else {
                        self.presentPopUpVC(message: emptyCart, title: "")
                    }
                }
                
                //MARK: -> Save Changes
                bottomCell?.didClickEdit = {
                    if self.isEdit {
                        print("Save Changes")
                        
                        for i in 0..<self.arrSelectedItems.count {
                            Constants.checkItems(localData: LocalStorage.getItemsData(), data: self.arrSelectedItems[i])
                        }
        
                        var myArray1 = [GetItemsData]()
                        myArray1.removeAll()
                        for i in 0..<self.arrMultiListItems.count {
                            if let originQty = self.arrMultiListItems[i].originQty, let measureQty = self.arrMultiListItems[i].measureQty {
                                if originQty != "0.00" && originQty != "0" && originQty != "",measureQty != "0.00" && measureQty != "0" && measureQty != ""   {
                                    let floatQuantity = (originQty  as NSString).floatValue.clean
                                    let strQuantity = String(floatQuantity)
                                    let floatOriginQty = (measureQty as NSString).floatValue.clean
                                    let strOriginQty = String(floatOriginQty)
                                    if let quan = Double(strOriginQty), let measureQty = Double(strQuantity) {
                                        let totalQuantity = quan * measureQty
                                        self.arrMultiListItems[i].quantity = "\(totalQuantity)"
                                    } else {
                                        print("Invalid values for quantity or measureQty")
                                    }
                                    myArray1.append(self.arrMultiListItems[i])
                                }
                            }
                        }

                        LocalStorage.saveMultiData(data: myArray1)
                        self.updateTotaPrice()
                        self.updatePaymentCellTotaPrice()
                        DispatchQueue.main.async {
                            self.updateUserProductList()
                        }
                    }
                    self.isEdit = !self.isEdit
                    self.bottomCell?.configureEditButton(isEdit:  self.isEdit)
                    self.confirmPaymentTableView.beginUpdates()
                    self.confirmPaymentTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.none)
                    self.confirmPaymentTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableView.RowAnimation.none)
                    self.confirmPaymentTableView.endUpdates()
                    self.bottomCell?.configureSubmitButtonTitle()
                }
                return bottomCell ?? UITableViewCell()
            default:
               return UITableViewCell()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == bannerTableView {
            let showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
            if  showAppBanner == 1 && self.arrayOfBanner.count > 0 {
                bannerContainerViewHeightConst.constant = Constants.bannerHeight
                return Constants.bannerHeight
            } else {
                bannerContainerViewHeightConst.constant = 0
                return 0
            }
        } else {
            switch indexPath.section {
                
            case 0:
                return UITableView.automaticDimension
                
            case 1 :
                return UITableView.automaticDimension
                
            case 2:
                return 600
            default:
                return  10
            }
            
        }
    }
        
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == bannerTableView {
            return 0
        } else {
            switch section {
            case 0:
                return 34
            case 1 :
                return 0
            case 2:
                return 0
            default:
                return 0
            }
        }
    }
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        if(self.strPickUpDelivery == "Pickup"){
    //            return 415
    //        } else {
    //            return 435
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        return viewFooter
    //    }
}

//MARK: -> View Model Interaction
extension ConfirmPaymentViewController {
    private func confirmAndPay(with param: [String: Any]) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.confirmOrderV3) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<ConfirmOrderModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { self.showIndicator()
            self.view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { self.hideIndicator()
                self.view.isUserInteractionEnabled = true
            }
            switch result{
            case .success(let deletedItemData):
                if let deletedItemData = deletedItemData {
                    guard let status = deletedItemData.status else { return }
                    if (status == 1) {
                        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.SelectedDate)
                        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.ponumber)
                        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.comment)
                        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.orderFlag)
                        //sendRequestUpdateUserProductList()
                        refreshCartProductList()
                        DispatchQueue.main.async {
                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowThankYouPopUpViewController") as? ShowThankYouPopUpViewController else {return}
                            vc.modalPresentationStyle = .overFullScreen
                            vc.delegate = self
                            self.present(vc, animated: false, completion: nil)
                        }
                    } else if(status == 2) {
                        //                        DispatchQueue.main.async {
                        //                            guard let messge = deletedItemData.message else {return}
                        //                            self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                        //                        }
                        var itemsName = ""
                        if let invalidItems = deletedItemData.data {
                            for i in 0..<invalidItems.count {
                                itemsName = itemsName + (invalidItems[i].item_name ?? "") + ","
                            }
                        }
                        let message =  " " + (deletedItemData.message ?? "") + itemsName
                        DispatchQueue.main.async {
                            self.presentPopUpVC(message: message, title: "")
                        }
                        self.isEdit = true
                        self.bottomCell?.configureEditButton(isEdit:  self.isEdit)
                        self.confirmPaymentTableView.beginUpdates()
                        self.confirmPaymentTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.none)
                        //self.confirmPaymentTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableView.RowAnimation.none)
                        self.confirmPaymentTableView.endUpdates()
                        self.bottomCell?.configureSubmitButtonTitle()
                    } else if(status == 3) {
                        let message = deletedItemData.message ?? ""
                        
                        if let next_delivery_date = deletedItemData.data?[0].next_delivery_date {
                            self.nextDeliveryDate = next_delivery_date
                        }
                        showNextDeliveryConfirmationMessage(message: message)
                    } else {
                        DispatchQueue.main.async {
                            guard let messge = deletedItemData.message else {return}
                            self.presentPopUpVC(message:messge,title: "")
                        }
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                    }
                }else  {
                    DispatchQueue.main.async {
                        self.presentPopUpVC(message: serverNotResponding, title: "")
                    }
                    
                }
            }
        }
    }
    
    //MARK: - Get-User-Items
    private func getItems(with param: [String: Any]) {
        self.view.endEditing(true)
        viewModel.getItems(with: param) { [self] result in
            switch result {
            case .success(let getUserItemsData):
                if let getUserItemsData = getUserItemsData {
                    guard let status = getUserItemsData.status else { return }
                    if (status == 1) {
                      //  self.callSaveCart()
                        if let showImage = getUserItemsData.show_image {
                            self.show_image = showImage
                        } 
                        if let displayAllItem = getUserItemsData.displayAllItemsInApp {
                            UserDefaults.standard.set(displayAllItem, forKey: "displayAllItem")
                        }
                        
//                        if let multiList = getUserItemsData.multi_items {
//                            if !multiList.isEmpty {
//                                LocalStorage.clearMultiItemsData()
//                                LocalStorage.saveMultiData(data: multiList)
//                            }
//                        }
                        
                        if let minimumOrderQty = getUserItemsData.minimum_order_qty {
                          
                            self.minimumOrderQty = minimumOrderQty
                        }
                        
                        if let bannerLists = getUserItemsData.bannerLists {
                            self.arrayOfBanner = bannerLists
                            let showBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
                            if showBanner == 1 &&  self.arrayOfBanner.count > 0 {
                                self.bannerContainerViewHeightConst.constant =  Constants.bannerHeight
                            } else {
                                self.bannerContainerViewHeightConst.constant =  0
                            }
                        } else {
                            self.bannerContainerViewHeightConst.constant =  0
                        }
                        
                        if let customerType = getUserItemsData.customer_type {
                            UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                            if(customerType == "Wholesale Customer") {
                                self.strPickUpDelivery = "Delivery"
                                self.hideDeliveryButtonView()
                            } else {
                                if let showPickUp = getUserItemsData.show_pickup {
                                    if(showPickUp == 0) {
                                        self.hideDeliveryButtonView()
                                    } else {
                                        self.showDeliveryButtonView()
                                    }
                                }
                            }
                        } else {
                            if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                                if(customerType as? String  == "Wholesale Customer") {
                                    self.strPickUpDelivery = "Delivery"
                                    self.hideDeliveryButtonView()
                                    self.hideCardView()
                                } else {
                                    self.showCardView()
                                }
                            }
                            
                        }
                        
                        if let routeAssigned = getUserItemsData.route_assigned {
                            if(routeAssigned == 0) {
                                self.isRouteAssigned = false
                                self.routeNotAssigned()
                            } else {
                                self.isRouteAssigned = true
                                self.routeAssigned()
                            }
                        }
                        
                        if let arrDeliveryAvailableDates =  getUserItemsData.delivery_available_dates {
                            self.deliveryAvailabelDates = arrDeliveryAvailableDates
                        }
                        
                        if let deliveryAvailableDays = getUserItemsData.delivery_available {
                            self.deliveryAvailableDays = deliveryAvailableDays
                        }
                        
                        if let deliveryCharge = getUserItemsData.delivery_charge {
                            self.strDeliveryCharge = deliveryCharge
                            self.bottomCell?.deliveryCharge = deliveryCharge
                        }
                        
                        if let showPrice = getUserItemsData.show_price {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                            self.showPrice = showPrice
                        }
                        self.updateTotaPrice()
                        
                        if let currencySymbol = getUserItemsData.currency_symbol {
                            if(currencySymbol != ""){
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            } else {
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            }
                        }
                        
                        if let minOrderValue = getUserItemsData.min_order_value {
                            self.strMinOrderValue = minOrderValue
                        }
                        
                        if(self.showPrice == "0") {
                            self.hideDeliveryChargeWithTotalPrice()
                        } else {
                            if let minOrderValue = Float(strMinOrderValue) {
                                if(minOrderValue >= floatTotalPrice) {
                                    if(self.strPickUpDelivery == "Pickup") {
                                        self.hideDeliveryCharges()
                                    } else {
                                        if  let deliveryCharge = Float(strDeliveryCharge){
                                            floatTotalPrice = floatTotalPrice + deliveryCharge
                                            self.shoeDeliveryCharges()
                                        }
                                    }
                                } else {
                                    self.hideDeliveryCharges()
                                }
                            }
                        }
                        
                        if let showPO = getUserItemsData.show_po {
                            if(showPO == 0) {
                                self.showPO = 0
                                self.hidePONumber()
                            } else {
                                self.showPO = 1
                                self.showPONumber()
                            }
                        }
                        
                        //                        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                        //                            if(customerType as! String == "Retail Customer") {
                        //                                if let showPickUp = getUserItemsData.show_pickup {
                        //                                    if(showPickUp == 1) {
                        //                                        if let radioButtonSelected = UserDefaults.standard.object(forKey:UserDefaultsKeys.selectedRadioButtonType) {
                        //                                            if(radioButtonSelected as? String == "delivery") {
                        //                                                self.selectDeliveryButton()
                        //                                            }
                        //                                            if(radioButtonSelected as? String == "pickup") {
                        //                                                self.selectPickUpButton()
                        //                                            }
                        //                                        } else {
                        //                                            self.selectDeliveryButton()
                        //                                        }
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        
                        if let contactNo = getUserItemsData.pickup_contact {
                            self.strContactNo = contactNo
                            bottomCell?.deliveryMessageLabel.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                            let strFullMessage = "Please call" + " " + self.strContactNo + " " + "to arrange a pick up time"
                            //deliveryChargeLabelText.text = strFullMessage
                            bottomCell?.deliveryMessageLabel.text = strFullMessage
                        }
                        //
                        //                        if isOpenCalendar {
                        //                            self.showCalendar()
                        //                        }
                    } else if(status == 2){
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
                }
                self.updateTotaPrice()
                self.confirmPaymentTableView.reloadData()
                self.bannerTableView.reloadData()
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
    
    //MARK: - callGetItems
    func callGetItems(){
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
//            GetUserItems.type.rawValue:KeyConstants.appType ,
//            GetUserItems.app_type.rawValue:appType,
            GetUserItems.client_code.rawValue:KeyConstants.clientCode ,
            GetUserItems.user_code.rawValue:userID ,
            GetUserItems.reset.rawValue:strResetValue,
            GetUserItems.device_id.rawValue:Constants.deviceId
        ]
        self.getItems(with: dictParam)
    }
    
    //Update-Product-List
    private func updateProductList(with param: [String: Any]) {
        viewModel.updateProductList(with: param, view: self.view) { result in
            switch result{
            case .success(let deletedItemData):
                print(deletedItemData)
                // self.productListCollectionView.reloadData()
                if let status = deletedItemData?.status {
                    if status == 1 {
                    }
                }
            case .failure(let error):
                print(error)
            case .none:
                break
            }
        }
    }
}

//MARK: -> DelegateGetText
extension ConfirmPaymentViewController: DelegeteGetStringText {
    
    func DelegeteGetStringText(quantity: String, index: Int, measure: String) {
//        switch self.section {
//        case 0 :
//            arrSelectedItems[ind].originQty = quantity
//            arrSelectedItems[ind].measureQty = measure
//        case 1 :
//            arrMultiListItems[ind].originQty = quantity
//            arrMultiListItems[ind].measureQty = measure
//        default:
//            print("hii")
//        }
        
        
        if sortedItem[ind].priority == 0 {
            var i = 0
            for i in 0..<arrMultiListItems.count {
                if arrMultiListItems[i].originQty == sortedItem[ind].originQty &&  arrMultiListItems[i].measureQty == sortedItem[ind].measureQty && arrMultiListItems[i].item_code == sortedItem[ind].item_code {
                    arrMultiListItems[i].originQty = quantity
                    arrMultiListItems[i].measureQty = measure
                    arrMultiListItems[i].quantity = calculateQuan(originQty: quantity, measureQty: measure, is_meas_box:  arrMultiListItems[i].is_meas_box ?? 0)
                    break
                }
            }
            
        } else {
            var i = 0
            for i in 0..<arrSelectedItems.count {
                if arrSelectedItems[i].originQty == sortedItem[ind].originQty &&  arrSelectedItems[i].measureQty == sortedItem[ind].measureQty && arrSelectedItems[i].item_code == sortedItem[ind].item_code {
                    arrSelectedItems[i].originQty = quantity
                    arrSelectedItems[i].measureQty = measure
                    arrSelectedItems[i].quantity = calculateQuan(originQty: quantity, measureQty: measure, is_meas_box:  arrSelectedItems[i].is_meas_box ?? 0)
                    break
                }
            }
            
        }
         sortedItem[ind].originQty = quantity
         sortedItem[ind].measureQty = measure
         sortedItem[ind].quantity = calculateQuan(originQty: quantity, measureQty: measure, is_meas_box:  sortedItem[ind].is_meas_box ?? 0)
    }
    
    func calculateQuan(originQty: String, measureQty: String, is_meas_box: Int  ) -> String {
        let floatQuantity = (measureQty  as NSString).floatValue.clean
        let strQuantity = String(floatQuantity)
        
        let floatOriginQty = (originQty as NSString).floatValue.clean
        let strOriginQty = String(floatOriginQty)
        
        if is_meas_box == 0 {
            if let quan = Double(strOriginQty) {
               let  quantity = "\(quan)"
                return quantity
            } else {
                print("Invalid values for quantity or measureQty")
            }
        } else {
            if let quan = Double(strOriginQty), let measureQty = Double(strQuantity) {
                let totalQuantity = quan * measureQty
                let quantity = "\(totalQuantity)"
                return quantity
            } else {
                print("Invalid values for quantity or measureQty")
            }
        }
        return ""
    }
}

extension ConfirmPaymentViewController {
    func selectDeliveryButton() {
        //self.strDeliveryPickUP = "Delivery"
        //myListReviewOrderCollectionViewCell?.viewDelivery.isHidden = false
        //myListReviewOrderCollectionViewCell?.deliveryMessagelabel.isHidden = true
        bottomCell?.deliveryDateView.isHidden = false
        bottomCell?.deliveryMessageLabel.isHidden = true
        bottomCell?.deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
        bottomCell?.piockUpButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
        UserDefaults.standard.set("delivery", forKey:UserDefaultsKeys.selectedRadioButtonType)
        bottomCell?.deliveryChargeStackViewHeightConst.constant = 24
        self.updatePaymentCellTotaPrice()
        self.bottomCell?.configureSubmitButtonTitle()
    }
    
    //MARK: - METHOD TO SELECT PICKUP BUTTON
    func selectPickUpButton() {
        //  self.strDeliveryPickUP = "Pickup"
        // myListReviewOrderCollectionViewCell?.viewDelivery.isHidden = true
        // deliveryMessgeHeightConst.constant = 21
        //myListReviewOrderCollectionViewCell?.deliveryMessagelabel.isHidden = false
        bottomCell?.deliveryDateView.isHidden = true
        bottomCell?.deliveryMessageLabel.isHidden = false
        bottomCell?.deliveryButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
        bottomCell?.piockUpButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
        UserDefaults.standard.set("pickup",forKey:UserDefaultsKeys.selectedRadioButtonType)
        bottomCell?.deliveryChargeStackViewHeightConst.constant = 0
        self.updatePaymentCellTotaPrice()
        self.bottomCell?.configureSubmitButtonTitle()
    }
    
    //MARK: - hideDeliveryButtonView
    func hideDeliveryButtonView() {
        bottomCell?.deliveryButtonView.isHidden = true
        bottomCell?.deliveryButtonViewHeightConst.constant = 0
        bottomCell?.deliveryMessageLabel.isHidden = true
    }
    //MARK: - showDeliveryButtonView
    func showDeliveryButtonView() {
        bottomCell?.deliveryButtonView.isHidden = false
        bottomCell?.deliveryButtonViewHeightConst.constant = 56
        bottomCell?.deliveryMessageLabel.isHidden = true
    }
    
    //MARK: - METHOD TO Show DELIVERY CHARGE
    func shoeDeliveryCharges() {
        bottomCell?.deliveryChargeStackView.isHidden = false
        bottomCell?.deliveryChargeStackViewHeightConst.constant = 24
    }
    
    func hideDeliveryCharges() {
        bottomCell?.deliveryChargeStackView.isHidden = true
        bottomCell?.deliveryChargeStackViewHeightConst.constant = 0
    }
    
    //MARK: - METHOD WHEN ROUTE NOT ASSIGNED
    func routeNotAssigned() {
        bottomCell?.calendarImageView.isHidden = true
        bottomCell?.deliveryDateLabelText.text = "Next Delivery"
        bottomCell?.selectDeliveryDateButton.isUserInteractionEnabled = false
    }
    
    //MARK: - METHOD WHEN ROUTE WAS ASSIGNED
    func routeAssigned() {
        bottomCell?.calendarImageView.isHidden = false
        if let strSelectedDate = UserDefaults.standard.object(forKey:UserDefaultsKeys.SelectedDate)        {
            bottomCell?.deliveryDateLabelText.text = strSelectedDate as? String
        }
        bottomCell?.selectDeliveryDateButton.isUserInteractionEnabled = true
    }
}

//MARK: - Show Calendar Method
extension ConfirmPaymentViewController: CalendarDelegate {
    func passDate(strDate: String) {
        if(strDate != "") {
            bottomCell?.deliveryDateLabelText.text = strDate
            self.strDeliveryDate = strDate
        }
    }
    
    //MARK: - Show Calendar Method
    func showCalendar() {
        DispatchQueue.main.async {
            let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
            calendarVC?.deliveryAvailableDays = self.deliveryAvailableDays
            calendarVC?.deliveryAvailabelDates = self.deliveryAvailabelDates
            calendarVC?.delegate = self
            calendarVC?.view.backgroundColor = UIColor.clear
            calendarVC?.modalPresentationStyle = .overCurrentContext
            self.present(calendarVC!, animated: false, completion: nil)
        }
    }
}

//MARK: -> UITextFieldDelegate
extension ConfirmPaymentViewController: UITextFieldDelegate {
    
    //MARK: - TEXT FIELD DELEGATES
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == bottomCell?.cardNumberTextField) {
            bottomCell?.cardHolderNameTextField.becomeFirstResponder()
        } else if (textField == cardHolderNameTextField) {
            bottomCell?.monthTextField.becomeFirstResponder()
        } else if(textField == monthTextField) {
            bottomCell?.cvvTextField.becomeFirstResponder()
        }else {
            bottomCell?.cvvTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var isSelected = false
        if(textField == bottomCell?.yearTextField){
            tag = 1
            self.view.endEditing(true)
            self.pickerView?.removeFromSuperview()
            self.toolBar.removeFromSuperview()
            self.addPickerView()
            isSelected = false
        }
        if(textField == bottomCell?.monthTextField) {
            tag = 2
            self.view.endEditing(true)
            self.pickerView?.removeFromSuperview()
            self.toolBar.removeFromSuperview()
            self.addPickerView()
            isSelected = false
        }
        
        else {
            if(pickerView != nil) {
                self.pickerView?.removeFromSuperview()
                self.toolBar.removeFromSuperview()
            }
            isSelected = true
        }
        return isSelected
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == bottomCell?.cardNumberTextField) {
            //            let currentText = textField.text ?? ""
            //            guard let stringRange = Range(range, in: currentText) else { return false }
            //            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            //            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            //            let compSepByCharInSet = string.components(separatedBy: aSet)
            //            let numberFiltered = compSepByCharInSet.joined(separator: "")
            //            if(string != numberFiltered) {
            //                return false
            //            }
            //            let count = updatedText.count
            //            if string != "" {
            //                if ( count == 4 || count == 9  || count == 14)
            //                {
            //                    textField.text = updatedText + " "
            //                }
            //                return updatedText.count <= 19
            //            }
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            // Limit to 16 characters
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return allowedCharacters.isSuperset(of: characterSet) && updatedText.count <= 19
        }
        
        if( textField == bottomCell?.cvvTextField ) {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if(string != numberFiltered){
                return false
            }
            return updatedText.count <= 3
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == bottomCell?.cardHolderNameTextField) {
            self.view.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == bottomCell?.yearTextField){
            bottomCell?.yearTextField.resignFirstResponder()
            tag = 1
            bottomCell?.yearTextField.resignFirstResponder()
            self.pickerView?.removeFromSuperview()
            self.toolBar.removeFromSuperview()
            self.addPickerView()
            
        }
        if (textField == bottomCell?.monthTextField){
            bottomCell?.monthTextField.resignFirstResponder()
            tag = 2
            bottomCell?.monthTextField.resignFirstResponder()
            self.pickerView?.removeFromSuperview()
            self.toolBar.removeFromSuperview()
            self.addPickerView()
        }
    }
}

//MARK: - UITextView Delegate
extension ConfirmPaymentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
    }
}

//MARK: - Delegete-BannerImage-Click
extension ConfirmPaymentViewController: DelegeteBannerImageClick {
    func didClickBannerImage(ind: Int) {
        let linkItemType = self.arrayOfBanner[ind].linkItemType
        if linkItemType == "category" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isComeFromBanner)
            vc.categoryId = self.arrayOfBanner[ind].linkItemTypeID ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "specials" {
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "SpecialsViewController") as! SpecialsViewController
//            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "product" {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.tabType = self.tabType
            vc.isComingFromBannerClick = true
            vc.itemCode = self.arrayOfBanner[ind].linkItemTypeID ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//extension ConfirmPaymentViewController: UITextFieldDelegate {
//    //MARK: -TEXT FIELD DELEGATES
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if(textField == cardNumberTextField) {
//            cardHolderNameTextField.becomeFirstResponder()
//        } else if (textField == cardHolderNameTextField) {
//            monthTextField.becomeFirstResponder()
//        } else if(textField == monthTextField) {
//            cvvTextField.becomeFirstResponder()
//        }else {
//            cvvTextField.resignFirstResponder()
//        }
//        return true
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isSelected = false
//        if(textField == yearTextField){
//            tag = 1;
//            self.view.endEditing(true)
//            self.pickerView?.removeFromSuperview()
//            self.toolBar.removeFromSuperview()
//            self.addPickerView()
//            isSelected = false
//
//        }
//        if(textField == monthTextField) {
//            tag = 2
//            self.view.endEditing(true)
//            self.pickerView?.removeFromSuperview()
//            self.toolBar.removeFromSuperview()
//            self.addPickerView()
//            isSelected = false
//        }
//
//        if (textField == confirmPaymentCell?.quantityTextField) {
//            confirmPaymentTableView.beginUpdates()
//            confirmPaymentTableView.sectionFooterHeight = 0
//            confirmPaymentTableView.endUpdates()
//            isSelected = true
//        }
//
//        else {
//            if(pickerView != nil) {
//                self.pickerView?.removeFromSuperview()
//                self.toolBar.removeFromSuperview()
//            }
//            isSelected = true
//
//        }
//        return isSelected
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if(textField == cardNumberTextField) {
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            if(string != numberFiltered) {
//                return false
//            }
//
//            let count = updatedText.count
//            if string != "" {
//                if ( count == 4 || count == 9  || count == 14)
//                {
//                    textField.text = updatedText + " "
//                }
//
//                return updatedText.count <= 19
//            }
//        }
//
//        if( textField == cvvTextField ) {
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            if(string != numberFiltered){
//                return false
//            }
//            return updatedText.count <= 3
//        }
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if(textField == cardHolderNameTextField) {
//            self.view.endEditing(true)
//        }
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (textField == yearTextField){
//            yearTextField.resignFirstResponder()
//            tag = 1;
//            yearTextField.resignFirstResponder()
//            self.pickerView?.removeFromSuperview()
//            self.toolBar.removeFromSuperview()
//            self.addPickerView()
//
//        }
//        if (textField == monthTextField){
//            monthTextField.resignFirstResponder()
//            tag = 2;
//            monthTextField.resignFirstResponder()
//            self.pickerView?.removeFromSuperview()
//            self.toolBar.removeFromSuperview()
//            self.addPickerView()
//        }
//    }
//
////    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
////        if(textField == confirmPaymentCell?.quantityTextField) {
////            confirmPaymentTableView.beginUpdates()
////            confirmPaymentTableView.sectionFooterHeight = 100
////            confirmPaymentTableView.endUpdates()
////            return true
////        }
////        return false
////    }
//}

//MARK: -> UIScrollViewDelegate
extension ConfirmPaymentViewController: UIScrollViewDelegate {
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
    //        if showAppBanner == 1 {
    //            if scrollView.contentOffset.y > 0 {
    //                bannerContainerView.isHidden = true
    //                setView(view:  bannerContainerView, hidden: true)
    //                bannerContainerViewHeightConst.constant = 0
    //            } else {
    //                bannerContainerView.isHidden = false
    //                setView(view:  bannerContainerView, hidden: false)
    //                bannerContainerViewHeightConst.constant = Constants.bannerHeight
    //            }
    //        }
    //    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
        if showAppBanner == 1 && self.arrayOfBanner.count > 0 {
            if scrollView.contentOffset.y > 0 {
                bannerContainerView.isHidden = true
                setView(view:  bannerContainerView, hidden: true)
                bannerContainerViewHeightConst.constant = 0
            } else {
                bannerContainerView.isHidden = false
                setView(view:  bannerContainerView, hidden: false)
                bannerContainerViewHeightConst.constant = Constants.bannerHeight
            }
        }
    }
    
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseIn, animations: {
            view.isHidden = hidden
        })
    }
}

//MARK: -> LogoutDelegate
extension ConfirmPaymentViewController: LogoutDelegate {
    func placeOrderPopUp(){
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderPopUpViewController") as? ConfirmOrderPopUpViewController
            vc?.messageTitle = "Are you sure want to place order ?"
            vc?.confirmButtonTitle = "Place Order"
            vc?.delegate = self
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    func successLogout() {
        //ConfirmPorder
        self.isEdit = false
        self.bottomCell?.configureEditButton(isEdit:  self.isEdit)
        for i in 0..<self.arrSelectedItems.count {
            Constants.checkItems(localData: LocalStorage.getItemsData(), data: self.arrSelectedItems[i])
        }
        self.updateTotaPrice()
        self.updatePaymentCellTotaPrice()
        self.configureConfirmAndPay()  // change heere for place oreder without cutt off time
        //        TestconfigureConfirmAndPay()// change heere for place oreder with cutt off time
    }
}

//MARK: -> Handle-Background-State
extension ConfirmPaymentViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        if presentingViewController is ConfirmPaymentViewController {
            print("handleAppDidBecomeActive")
            self.callGetItems()
            self.arrSelectedItems  =  LocalStorage.getItemsData()
            if self.arrSelectedItems.count > 0 {
                for i in 0...self.arrSelectedItems.count {
                    if let index = arrSelectedItems.firstIndex(where: {$0.quantity == "0"}) {
                        self.arrSelectedItems.remove(at: index)
                    }
                }
            }
            updateTotaPrice()
            self.arrMonths = ["MM","01","02","03","04","05","06","07","08","09","10","11","12"]
            self.arrYear = ["YYYY","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2034","2035","2036","2037","2038","2039"]
            let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
            appNameLabel.text = appName
            setNeedsStatusBarAppearanceUpdate()
            self.refreshBanner()
        }
    }
}

//MARK: -> TextFieldDidChange
extension ConfirmPaymentViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text?.filter({ $0.isNumber }) {
            let formattedText = formatText(text)
            textField.text = formattedText
        }
    }
    
    func formatText(_ text: String) -> String {
        var formattedText = ""
        var index = text.startIndex
        while index < text.endIndex {
            let endIndex = text.index(index, offsetBy: min(4, text.distance(from: index, to: text.endIndex)))
            let segment = text[index..<endIndex]
            formattedText += segment
            if endIndex != text.endIndex {
                formattedText += " "
            }
            index = endIndex
        }
        return formattedText
    }
}

//MARK: - ConfirmationPopupSuccessDelegate
extension ConfirmPaymentViewController: ConfirmationPopupSuccessDelegate {
    func showNextDeliveryConfirmationMessage(message: String) {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationPopUpViewController") as! ConfirmationPopUpViewController
            vc.isApplyButtonBGColor = true
            vc.titleMessage = message
            vc.okButtonTitle = "Place Order"
            vc.cancelButtonTitle = "Cancel"
            vc.successDelegate = self
            vc.didClickCrossButton = {
                self.isOpenCalendar = false
                self.strDeliveryDate = ""
                self.testDeliveryDate = ""
                self.bottomCell?.deliveryDateLabelText.text  = ""
                self.refreshCallGetItems()
                self.refreshBanner()
            }
            
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func isSuccess(success: Bool) {
        if success {
            self.strDeliveryDate = self.nextDeliveryDate
            self.testDeliveryDate = self.nextDeliveryDate
            self.deliveryDateByPass = "1"
            configureConfirmAndPay()
        } else {
            self.strDeliveryDate = ""
            self.testDeliveryDate = ""
            self.bottomCell?.deliveryDateLabelText.text  = ""
            self.refreshBanner()
            self.isOpenCalendar = true
            self.refreshCallGetItems()
        }
    }
}

//MARK: - refreshCallGetItems
extension ConfirmPaymentViewController {
    func refreshCallGetItems(){
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
            GetUserItems.type.rawValue:KeyConstants.appType ,
            GetUserItems.app_type.rawValue:appType,
            GetUserItems.client_code.rawValue:KeyConstants.clientCode ,
            GetUserItems.user_code.rawValue:userID ,
            GetUserItems.reset.rawValue:strResetValue,
            GetUserItems.device_id.rawValue:Constants.deviceId
        ]
        self.refreshGetItems(with: dictParam)
    }
    
    
    //MARK: - Get-User-Items
    private func refreshGetItems(with param: [String: Any]) {
        self.view.endEditing(true)
        viewModel.getItems(with: param) { [self] result in
            switch result {
            case .success(let getUserItemsData):
                if let getUserItemsData = getUserItemsData {
                    guard let status = getUserItemsData.status else { return }
                    if (status == 1) {
                        if let showImage = getUserItemsData.show_image {
                            self.show_image = showImage
                        }
                        
                        if let bannerLists = getUserItemsData.bannerLists {
                            self.arrayOfBanner = bannerLists
                            let showBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
                            if showBanner == 1 &&  self.arrayOfBanner.count > 0 {
                                self.bannerContainerViewHeightConst.constant =  Constants.bannerHeight
                            } else {
                                self.bannerContainerViewHeightConst.constant =  0
                            }
                        } else {
                            self.bannerContainerViewHeightConst.constant =  0
                        }
                        
                        if let customerType = getUserItemsData.customer_type {
                            UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                            if(customerType == "Wholesale Customer") {
                                self.strPickUpDelivery = "Delivery"
                                self.hideDeliveryButtonView()
                            } else {
                                if let showPickUp = getUserItemsData.show_pickup {
                                    if(showPickUp == 0) {
                                        self.hideDeliveryButtonView()
                                    } else {
                                        self.showDeliveryButtonView()
                                    }
                                }
                            }
                        } else {
                            if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                                if(customerType as? String  == "Wholesale Customer") {
                                    self.strPickUpDelivery = "Delivery"
                                    self.hideDeliveryButtonView()
                                    self.hideCardView()
                                } else {
                                    self.showCardView()
                                }
                            }
                        }
                        
                        if let routeAssigned = getUserItemsData.route_assigned {
                            if(routeAssigned == 0) {
                                self.isRouteAssigned = false
                                self.routeNotAssigned()
                            } else {
                                self.isRouteAssigned = true
                                self.routeAssigned()
                            }
                        }
                        
                        if let arrDeliveryAvailableDates =  getUserItemsData.delivery_available_dates {
                            self.deliveryAvailabelDates = arrDeliveryAvailableDates
                        }
                        
                        if let deliveryAvailableDays = getUserItemsData.delivery_available {
                            self.deliveryAvailableDays = deliveryAvailableDays
                        }
                        
                        if let deliveryCharge = getUserItemsData.delivery_charge {
                            self.strDeliveryCharge = deliveryCharge
                            self.bottomCell?.deliveryCharge = deliveryCharge
                        }
                        
                        if let showPrice = getUserItemsData.show_price {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                            self.showPrice = showPrice
                        }
                        self.updateTotaPrice()
                        
                        if let currencySymbol = getUserItemsData.currency_symbol {
                            if(currencySymbol != ""){
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            } else {
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            }
                        }
                        
                        if let minOrderValue = getUserItemsData.min_order_value {
                            self.strMinOrderValue = minOrderValue
                        }
                        
                        if(self.showPrice == "0") {
                            self.hideDeliveryChargeWithTotalPrice()
                        } else {
                            if let minOrderValue = Float(strMinOrderValue) {
                                if(minOrderValue >= floatTotalPrice) {
                                    if(self.strPickUpDelivery == "Pickup") {
                                        self.hideDeliveryCharges()
                                    } else {
                                        if  let deliveryCharge = Float(strDeliveryCharge){
                                            floatTotalPrice = floatTotalPrice + deliveryCharge
                                            self.shoeDeliveryCharges()
                                        }
                                    }
                                } else {
                                    self.hideDeliveryCharges()
                                }
                            }
                        }
                        
                        if let showPO = getUserItemsData.show_po {
                            if(showPO == 0) {
                                self.showPO = 0
                                self.hidePONumber()
                            } else {
                                self.showPO = 1
                                self.showPONumber()
                            }
                        }
                        
                        //                        if let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                        //                            if(customerType as! String == "Retail Customer") {
                        //                                if let showPickUp = getUserItemsData.show_pickup {
                        //                                    if(showPickUp == 1) {
                        //                                        if let radioButtonSelected = UserDefaults.standard.object(forKey:UserDefaultsKeys.selectedRadioButtonType) {
                        //                                            if(radioButtonSelected as? String == "delivery") {
                        //                                                self.selectDeliveryButton()
                        //                                            }
                        //                                            if(radioButtonSelected as? String == "pickup") {
                        //                                                self.selectPickUpButton()
                        //                                            }
                        //                                        } else {
                        //                                            self.selectDeliveryButton()
                        //                                        }
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        
                        if let contactNo = getUserItemsData.pickup_contact {
                            self.strContactNo = contactNo
                            bottomCell?.deliveryMessageLabel.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                            let strFullMessage = "Please call" + " " + self.strContactNo + " " + "to arrange a pick up time"
                            //deliveryChargeLabelText.text = strFullMessage
                            bottomCell?.deliveryMessageLabel.text = strFullMessage
                        }
                        
                        if isOpenCalendar {
                            self.showCalendar()
                        }
                    } else if(status == 2){
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
                }
                self.updateTotaPrice()
                self.confirmPaymentTableView.reloadData()
                self.bannerTableView.reloadData()
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
    
    func refreshBanner() {
        let showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
        if showAppBanner == 1 && self.arrayOfBanner.count > 0 {
            self.bannerContainerView.isHidden = false
            self.setView(view:  self.bannerContainerView, hidden: false)
            self.bannerContainerViewHeightConst.constant = Constants.bannerHeight
        } else {
            self.bannerContainerView.isHidden = true
            self.setView(view:  self.bannerContainerView, hidden: true)
            self.bannerContainerViewHeightConst.constant = 0
        }
        self.bannerTableView.reloadData()
        self.confirmPaymentTableView.reloadData()
        self.confirmPaymentTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}


extension ConfirmPaymentViewController {
    //MARK: - Save Cart Items
    func callSaveCart() {
        LocalStorage.clearItemsData()
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
        //
        WebService().load(resource: resource) { [self] result in
            switch result{
            case .success(let cartData):
                if let cartData = cartData {
                    guard let status = cartData.status else { return }
                    if (status == 1) {
                        LocalStorage.clearItemsData()
                        LocalStorage.clearMultiItemsData()
                        if let cartData =  cartData.data {
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
                           // let notificationCenter = NotificationCenter.default
                           // notificationCenter.post(name: Notification.Name("cartSucess"), object: nil, userInfo: nil)
                        }
                        self.configureCartItem()
                   
                        
                    
                    } else {
                    }
                }
            case .failure(let error):
                print("error")
            }
        }
    }
}
