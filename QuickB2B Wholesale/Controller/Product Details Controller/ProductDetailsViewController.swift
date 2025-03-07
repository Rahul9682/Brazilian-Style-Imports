//  ProductDetailsViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 24/04/23.

import UIKit
import SDWebImage
import SwiftyJSON

class ProductDetailsViewController: UIViewController{
  
    
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productNameLabel: SemiBoldLabelSize24!
    @IBOutlet weak var proceLabel: SemiBoldLabelSize20!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addQtyLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var addQtyView: UIView!
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var toastLabel: UILabel!
    var toatTimeDuration = 3.0
    var animator: UIViewPropertyAnimator?
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    var tabType: TabType = .none
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var addButttonContainerView: UIView!
    @IBOutlet weak var addIconImageVIew: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var productImageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var productImageTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!
    @IBOutlet weak var measureTextfield: UITextField!
    @IBOutlet weak var crossImage: UIImageView!
    @IBOutlet weak var crossView: UIView!
    
    //MARK: -> Properties
    var arrayOfSpecial = [GetItemsData]()
    var arrayOfproductDetails = [GetItemsData]()
    var productDetails: GetItemsData?
    var viewModel = ProductDetailsViewModel()
    var itemCode = ""
    var delegeteSuccess: DelegeteSuccess?
    var isUpdateQuantity:Bool = false
    var currenycSymbol =  UserDefaults.standard.value(forKey:UserDefaultsKeys.CurrencySymbol) as? String
    var isComingFromBannerClick: Bool = false
    var redColor: UIColor = UIColor(red: 237.0/255, green: 35.0/255, blue: 35.0/255, alpha: 1.0)
    var inMyList = 0
    var isChangeQuantity: Bool = false
    var updateQuantityDelegate: DelegateUpdateQuantity?
    var indexPath: IndexPath?
    var showImage = "0"
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var multiItemCount: UILabel!
    @IBOutlet weak var countView: UIView!
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    
    
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        self.configureCartImage()
        toastView.layer.cornerRadius = Radius.searchViewRadius
        toastView.layer.borderWidth = 0.5
        toastView.layer.borderColor = UIColor.lightGray.cgColor
        toastView.isHidden = true
        toastView.dropShadow()
        
        if isComingFromBannerClick {
            getProductDetails()
        }
        configureUI()
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH ALL PRODUCTS",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
        
        if let image = Constants.rotateImageInPlace(image: UIImage(named: "plus1") ?? UIImage(), byDegrees: 45) {
            crossImage.image = image
            crossImage.alpha = 0.5
        }
        
        measureTextfield.layer.borderWidth = 0.5;
        measureTextfield.layer.cornerRadius = 5;
        measureTextfield.layer.borderColor = UIColor.lightGray.cgColor;
        measureTextfield.textColor = UIColor.black
        
        var itemcount = Constants.getCount(itemCode: self.productDetails?.item_code)
        if itemcount != 0 {
            multiItemCount.isHidden = false
            multiItemCount.text = ("\(itemcount)")
            
        } else {
            multiItemCount.text = ""
            multiItemCount.isHidden = true
        }
        
        if productDetails?.is_meas_box == 0 {
            addView.isHidden = true
            countView.isHidden = true
        } else {
            addView.isHidden = false
            countView.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                updateTotaPrice()
                self.proceLabel.isHidden = false
                appNameStackView.distribution = .fillEqually
            } else {
                self.proceLabel.isHidden = true
                appNameStackView.distribution = .fill
            }
        } else {
            appNameStackView.distribution = .fillEqually
        }
        didEnterBackgroundObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Call Update Inventory Api
        print("viewWillDisappear")
       // if isUpdateQuantity {
            DispatchQueue.main.async {
                self.sendRequestUpdateUserProductList()
            }
      //  }
    }
    
    //MARK: -> Helpers
    private func configureUI() {
        favouriteButton.isHidden = true
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        searchContainerView.layer.cornerRadius = Radius.searchViewRadius
        searchContainerView.layer.borderWidth = Radius.searchViewborderWidth
        searchContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        addQtyLabel.textColor = UIColor.black
        quantityTextField.delegate = self
        measureTextfield.delegate = self
        productDescriptionLabel.isHidden = true
        proceLabel.textColor = UIColor.black
        
        if let productDetails = productDetails {
            self.arrayOfproductDetails.append(productDetails)
            titleLabel.text = productDetails.item_name
            productNameLabel.text = productDetails.item_name
            
            if let showUnit = productDetails.is_meas_box {
                if showUnit == 1 {
                    measureTextfield.isHidden = false
                    crossImage.isHidden = false
                    crossView.isHidden = false
                } else {
                    measureTextfield.isHidden = true
                    crossImage.isHidden = true
                    crossView.isHidden = true
                }
            }
            
            
            if let unit =  Constants.getMeasure(itemCode: productDetails.item_code){
//                let floatQuantity = (unit as NSString).floatValue
//                let strTotalPrice:NSString = NSString(format: "%.2f", floatQuantity)
//                let strTottalPrice:String = strTotalPrice as String
                measureTextfield.text = unit
            } else {
                measureTextfield.text = ""
            }
            
            if showImage == "1" {
                productImageHeightConst.constant = 260
                productImageTopConst.constant = 30
            } else {
                productImageHeightConst.constant = 0
                productImageTopConst.constant = 0
            }
            
            if let price = productDetails.item_price {
                if let currenycSymbol = currenycSymbol {
                    proceLabel.text = currenycSymbol + price
                } else {
                    proceLabel.text = price
                }
            }
            
            if productDetails.image_description != "" {
                productDescriptionLabel.isHidden = false
                productDescriptionLabel.text = productDetails.image_description
            } else {
                productDescriptionLabel.isHidden = true
                productDescriptionLabel.text = productDetails.image_description
            }
            
            if let itemImage = productDetails.image {
                productImage.sd_setImage(with: URL(string: itemImage), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
            } else {
                productImage.image = Icons.placeholderImage
            }
            
            if let itemCode = productDetails.item_code {
                self.viewModel.itemCode = itemCode
            }
            
            if let quantity = Constants.getPrice(itemCode: productDetails.item_code) {
                if quantity == "0" ||  quantity == "" {
                    quantityTextField.text = ""
                } else {
                    let floatQuantity = (quantity as NSString).floatValue
                    let strTotalPrice:NSString = NSString(format: "%.2f", floatQuantity)
                    let strTottalPrice:String = strTotalPrice as String
                    quantityTextField.text = strTottalPrice
                    //quantityTextField.text = quantity
                }
            } else {
                quantityTextField.text = ""
            }
            
            if let uom = productDetails.uom {
                //quantityTextField.placeholder = uom
                quantityTextField.attributedPlaceholder = NSAttributedString(string: uom,attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor])
            } else {
                quantityTextField.placeholder = ""
            }
            
            measureTextfield.attributedPlaceholder = NSAttributedString(string: "QTY" ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor])
            
            
            if let specialItemID = productDetails.special_item_id {
                if (specialItemID == 1) {
                    proceLabel.textColor = AppColors.redTextColor
                    favouriteButton.isHidden = false
                }
                else {
                    proceLabel.textColor = UIColor.black
                    favouriteButton.isHidden = true
                }
            }
            
            if let status = productDetails.status {
                if(status != "Active") {
                    quantityTextField.text = "NA"
                    quantityTextField.isUserInteractionEnabled = false
                    quantityTextField.borderStyle = .none
                    quantityTextField.textColor = UIColor.red
                    measureTextfield.text = "NA"
                    measureTextfield.isUserInteractionEnabled = false
                    measureTextfield.borderStyle = .none
                    measureTextfield.textColor = UIColor.red
                    
                } else {
                    measureTextfield.layer.borderWidth = 0.5
                    quantityTextField.layer.borderWidth = 0.5
                    quantityTextField.layer.cornerRadius = 5
                    measureTextfield.layer.cornerRadius = 5
                    quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
                    measureTextfield.layer.borderColor = UIColor.lightGray.cgColor
                    quantityTextField.textColor = UIColor.black
                    measureTextfield.textColor = UIColor.black
                    if let specialItemID = productDetails.special_item_id {
                        if (specialItemID == 1) {
                            quantityTextField.isHidden = false
                            quantityTextField.text = Constants.getPrice(itemCode: productDetails.item_code)
                            quantityTextField.isUserInteractionEnabled = true
                        } else {
                            quantityTextField.isHidden = false
                            quantityTextField.text = Constants.getPrice(itemCode: productDetails.item_code)
                            quantityTextField.isUserInteractionEnabled = true
                        }
                    }
                }
            }
            else {
                quantityTextField.text = "NA"
                quantityTextField.isUserInteractionEnabled = false
                quantityTextField.borderStyle = .none
                quantityTextField.textColor = UIColor.red
            }
            
            if let inMyList = productDetails.inMyList {
                self.inMyList = inMyList
                self.configureAddIconImage(inMyList: inMyList)
            }
        }
        
        if productDetails?.is_meas_box == 0 {
            addView.isHidden = true
            countView.isHidden = true
        } else {
            addView.isHidden = false
            countView.isHidden = false
        }
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
                self.configureTabBar()
                self.presentPopUpVC(message: emptyCart, title: "")
            } else {
                let stb = UIStoryboard(name: "Main", bundle: nil)
                let confirmPaymentVC = stb.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func totalAmountLabelTapped(_ sender: UITapGestureRecognizer) {
        var localStorageArray = LocalStorage.getFilteredData()
        localStorageArray += LocalStorage.getFilteredMultiData()
        
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let confirmPaymentVC = stb.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
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
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                self.totalPriceLabel.text = strTitleTotalPriceButton
            } else {
                self.totalPriceLabel.text = ""
            }
        }
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
    
    func presentProductPopUpVC(message:String,title:String) {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC
            vc?.strMessage = message
            vc?.strTitle = title
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
//    func configureAddIconImage(inMyList: Int) {
//        print("inMy ",inMyList)
//        if inMyList == 0 {
//            //addIconImageVIew.image = Icons.add
//            addIconImageVIew.isHidden = true
//            addButttonContainerView.isHidden = true
//            addButton.isHidden = true
//        } else {
//            addIconImageVIew.image = Icons.remove
//            addIconImageVIew.isHidden = false
//            addButttonContainerView.isHidden = false
//            addButton.isHidden = false
//        }
//    }
    
    func configureAddIconImage(inMyList: Int) {
        print("inMy ",inMyList)
        if inMyList == 0 {
            addIconImageVIew.image = Icons.add
            addIconImageVIew.isHidden = false
            addButttonContainerView.isHidden = false
            addButton.isHidden = false
        } else {
            //addIconImageVIew.image = Icons.remove
            addIconImageVIew.isHidden = true
            addButttonContainerView.isHidden = true
            addButton.isHidden = true
        }
    }
    
    //MARK: - Show Custom PopUp
    func presentProductPopUpVC1(message:String,title:String) {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC
            vc?.strMessage = message
            vc?.strTitle = title
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    //MARK: -> Button Actions
    
    
    
    @IBAction func addToMultiItem(_ sender: Any) {
        measureTextfield.becomeFirstResponder()
        if let selectedItem = Constants.getCartItem(itemCode: productDetails?.item_code ?? "") {
            var mutatedItem = selectedItem
            if mutatedItem.originQty != "0" && mutatedItem.originQty != "0.0" && mutatedItem.originQty != "0.00" && mutatedItem.measureQty != "0" && mutatedItem.measureQty != "0.0" && mutatedItem.measureQty != "0.00" && mutatedItem.originQty != "" && mutatedItem.measureQty != "" {
                mutatedItem.priority = 0
                mutatedItem.id = 0
                var data = LocalStorage.getShowItData()
                    data.append(mutatedItem)
                LocalStorage.saveMultiData(data: data)
                LocalStorage.deleteGetItemsIndex(itemCode: productDetails?.item_code ?? "")
              viewDidLoad()
            }
        }
        
    }
    
    @IBAction func showMultiItemAction(_ sender: Any) {
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "ShowListPopUpViewController") as? ShowListPopUpViewController
        nextVC?.refreshDelegate = self
        nextVC?.itemCode = self.productDetails?.item_code ?? ""
        nextVC?.modalPresentationStyle = .overFullScreen
        self.present(nextVC!, animated: false, completion: nil)
    }
    
   
    @IBAction func backButton(_ sender: UIButton) {
        if isUpdateQuantity {
            if let delegeteSuccess = delegeteSuccess {
                delegeteSuccess.isSuceess(success: true, text: "")
            }
        } else {
            if let delegeteSuccess = delegeteSuccess {
                delegeteSuccess.isSuceess(success: false, text: "")
            }
        }
        let text = quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let indexPath = indexPath {
            print("called")
            updateQuantityDelegate?.didUpdateQuantity(updatedQuantity: text, inMyList: self.inMyList, indexPath: indexPath)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        //        //addProduct(param: self.viewModel.AddProductParam() as [String : Any])
        //        if self.productDetails?.inMyList == 1 {
        //            deleteItemWithId(itemCode: self.viewModel.itemCode)
        //        }
        
        ///22/Mar
        if self.inMyList == 0 {
            print("add")
            addProduct(param: self.viewModel.AddProductParam() as [String : Any])
        } else {
            print("remove")
            deleteItemWithId(itemCode: self.viewModel.itemCode)
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "CommonSearchViewController") as! CommonSearchViewController
        vc.tabType = self.tabType
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func cartButton(_ sender: UIButton) {
        var localStorageArray = LocalStorage.getFilteredData()
        localStorageArray += LocalStorage.getFilteredMultiData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let confirmPaymentVC = stb.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
}

//MARK: ->View-Model-Interaction
extension ProductDetailsViewController {
    //Add-Product
    func addProduct(param:[String:Any]) {
        viewModel.addProduct(with: param, view: self.view) { result in
            switch result{
            case .success(let addProductData):
                if let addProductData = addProductData {
                    guard let status = addProductData.status  else { return }
                    if (status == 1) {
                        guard let messge = addProductData.message else {return}
                        // self.presentProductPopUpVC(message:messge,title: "")
//                        if self.inMyList == 0 {
//                            //self.productDetails?.inMyList = 1
//                            self.inMyList = 1
//                        } else  if self.inMyList == 1 {
//                            //self.productDetails?.inMyList = 0
//                            self.inMyList = 0
//                        }
                        self.inMyList = 1
                        self.configureAddIconImage(inMyList: self.inMyList)
                        DispatchQueue.main.async {
                            self.showAnimatedView(forDuration: self.toatTimeDuration, message: messge)
                        }
                    } else if (status == 2) {
                        guard let messge = addProductData.message else {return}
                        // self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                        DispatchQueue.main.async {
                            self.showAnimatedView(forDuration: self.toatTimeDuration, message: messge)
                        }
                    } else {
                        guard let messge = addProductData.message else {return}
                        self.presentProductPopUpVC1(message:messge,title: "")
                        DispatchQueue.main.async {
                            self.showAnimatedView(forDuration: self.toatTimeDuration, message: messge)
                        }
                    }
                }
                
            case .failure(let error):
                if(error == .networkError) {
                    // self.presentProductPopUpVC1(message: validateInternetConnection, title: validateInternetTitle)
                    DispatchQueue.main.async {
                        self.showAnimatedView(forDuration: self.toatTimeDuration, message: error.rawValue)
                    }
                } else {
                    //self.presentProductPopUpVC1(message: serverNotResponding, title: "")
                    DispatchQueue.main.async {
                        self.showAnimatedView(forDuration: self.toatTimeDuration, message: error.rawValue)
                    }
                }
            case .none:
                break
            }
        }
    }
    
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
    
    //Delete-Item
    func deleteItem(with param: [String: Any],itemCode:String) {
        viewModel.deleteItem (with: param, view: self.view,itemCode: itemCode) { result in
            switch result{
            case .success(let deletedItemData):
                if let deletedItemData = deletedItemData {
                    guard let status = deletedItemData.status else { return }
                    if (status == 1) {
                        self.inMyList = 0
//                        if self.inMyList == 0 {
//                            //self.productDetails?.inMyList = 1
//                            self.inMyList = 1
//                        } else  if self.inMyList == 1 {
//                            //self.productDetails?.inMyList = 0
//                            self.inMyList = 0
//                        }
                        self.configureAddIconImage(inMyList: self.inMyList)
                        guard let messge = deletedItemData.message else {return}
                       // self.presentPopUpVC(message:messge,title: "")
                        DispatchQueue.main.async {
                            self.showAnimatedView(forDuration: self.toatTimeDuration, message: messge)
                        }
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
}

//MARK: - PopUpDelegate
extension ProductDetailsViewController: PopUpDelegate {
    func presentPopUpWithDelegate(strMessage:String,buttonTitle:String) {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
            vc.strMessage = strMessage
            vc.buttonTitle = buttonTitle
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func didTapDone() {
        var userId = ""
        var userDefaultId = ""
        if let userid = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String {
            userId = userid
        }
        if let userdefaultId = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String {
            userDefaultId = userdefaultId
        }
        
        //userDefaultId = userId
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let  outletVC = storyBoard.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController else {return}
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
                UserDefaults.standard.set(strUserLoginId, forKey: UserDefaultsKeys.UserDefaultLoginID)
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

//MARK: -> Delegete-Success
extension ProductDetailsViewController {
    func updateArray(quantity: String,itemCode:String) {
        if quantity != "" {
            if arrayOfproductDetails.count > 0 {
                self.arrayOfproductDetails[0].quantity = quantity
                self.arrayOfproductDetails[0].item_code = itemCode
            } else {
                self.arrayOfSpecial[0].quantity = quantity
                self.arrayOfSpecial[0].item_code = itemCode
            }
            //self.updateTotaPrice()
            self.sendRequestUpdateUserProductList()
        }
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
            UpdateProductList.device_type.rawValue:Constants.deviceType,
        ]
        print("Update",JSON(dictParam))
        self.updateProductList(with: dictParam)
    }
}

//MARK: -> View-Model Interaction
extension ProductDetailsViewController {
    //MARK: - Update-Product-List
    private func updateProductList(with param: [String: Any]) {
        viewModel.updateProductList(with: param, view: self.view) { result in
            switch result{
            case .success(let deletedItemData):
                print(deletedItemData)
                // self.productListCollectionView.reloadData()
                if let status = deletedItemData?.status {
                    if status == 1 {
                        // if self.viewModel.isComingFromReviewOrderButton {
                        //self.goToConfirmPaymentPage()
                        // }
                        self.isUpdateQuantity = true
                    }
                    //self.callGetItems()
                }
            case .failure(let error):
                print(error)
            case .none:
                break
            }
        }
    }
    
    private func getProductDetails() {
        viewModel.getProductDetails(with: itemCode, view: self.view) { result in
            switch result{
            case .success(let deletedItemData):
                if let productDetails = deletedItemData?.data {
                    self.productDetails = productDetails
                    self.configureUI()
                }
            case .failure(let error):
                print(error)
            case .none:
                break
            }
        }
    }
    
    func showAnimatedView(forDuration duration: TimeInterval, message: String) {
        // Make sure the view is hidden before animating
        self.toastLabel.text = message
        toastView.isHidden = false
        // Set the initial state (optional)
        toastView.alpha = 0.0
        toastView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            // Set the final state
            self.toastView.alpha = 1.0
            self.toastView.transform = .identity
        }, completion: { _ in
            // Animation completed, schedule hiding the view after the specified duration
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.hideAnimatedView()
            }
        })
    }
    
    func hideAnimatedView() {
        UIView.animate(withDuration: 0.3, animations: {
            // Set the final state (hide the view)
            self.toastView.alpha = 0.0
            self.toastView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            // Animation completed, hide the view and reset its state
            self.toastView.isHidden = true
            self.toastView.alpha = 1.0
            self.toastView.transform = .identity
        })
    }
}

//MARK: -> Handle-Background-State
extension ProductDetailsViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        print("handleAppDidBecomeActive")
        updateTotaPrice()
    }
}


//MARK: -> UITextFieldDelegate
extension ProductDetailsViewController: UITextFieldDelegate {
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        // get the current text, or use an empty string if that failed
    //        let currentText = textField.text ?? ""
    //        // attempt to read the range they are trying to change, or exit if we can't
    //        guard let stringRange = Range(range, in: currentText) else { return false }
    //        // add their new text to the existing text
    //        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    //        // make sure the result is under 16 characters
    //        return updatedText.count <= 4
    //    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // Combine the current text with the replacement text
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        // Regular expression to match the allowed format
        let regex = try! NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d{0,2})?$")
        let range = NSRange(location: 0, length: updatedText.utf16.count)
        if regex.firstMatch(in: updatedText, options: [], range: range) == nil {
            return false // Don't allow the change
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
        
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        // if text != "" {
        if var productDetails = productDetails {
            if measureTextfield.isHidden != true {
                if measureTextfield.text != ""  &&  quantityTextField.text != "" {
                    productDetails.originQty = quantityTextField.text ?? ""
                    productDetails.measureQty = measureTextfield.text ?? ""
                    Constants.checkItems(localData: viewModel.arrayOfLocalStorageItems, data: productDetails)
                    self.isUpdateQuantity = true
                    self.updateTotaPrice()
                    viewDidLoad()
                } else {
                    if measureTextfield.text == ""  &&  quantityTextField.text == "" {
                        productDetails.originQty = ""
                        productDetails.measureQty = ""
                        Constants.checkItems(localData: viewModel.arrayOfLocalStorageItems, data: productDetails)
                        self.isUpdateQuantity = true
                        self.updateTotaPrice()
                        viewDidLoad()
                    }
                }
            } else {
                productDetails.originQty = quantityTextField.text ?? ""
                productDetails.measureQty = ""
                Constants.checkItems(localData: viewModel.arrayOfLocalStorageItems, data: productDetails)
                self.isUpdateQuantity = true
                self.updateTotaPrice()
                viewDidLoad()
            }
            
        }
    }
    
}


extension ProductDetailsViewController: RefreshDelegate {
    func refresh() {
      viewDidLoad()
    }
    
}
