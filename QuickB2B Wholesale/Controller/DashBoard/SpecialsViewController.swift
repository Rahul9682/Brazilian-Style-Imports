//  SpecialsViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import SwiftyJSON

class SpecialsViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var specialTitlesContainerView: UIView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!
 
    //MARK: -> Properties
    var viewModel = SpecialsViewModel()
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var floatTotalPrice :Float! = 0.0
    var refreshEnable = true
    var background: BackgroundView?
    var isShowList = UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int
    var tabType: TabType = .special
    var isChangedQuantity: Bool = false
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureUI()
        registerCell()
        configureGridOrList(showList: UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int ?? 0)
        //getHomeData()
        //self.updateTotaPrice()
        //configureGridOrList(showList: isShowList ?? 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        updateTotaPrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                appNameStackView.distribution = .fillEqually
            } else {
                appNameStackView.distribution = .fill
            }
        } else {
            appNameStackView.distribution = .fillEqually
        }
        addObserver()
        getHomeData()
        // self.updateTotaPrice()
        didEnterBackgroundObserver()
    }
    
    func configureCartImage() {
        cartImageIcon.image = Icons.cart
        let cartItems = LocalStorage.getFilteredData()
        totalCartItemsCountTopConst.constant = Constants.totalCartItemsCountTopConst
        totalCartItemsCountTrailingConst.constant = CGFloat(Constants.cartItemsCountLabelTrailingConst())
        if cartItems.count > 0 {
            cartItemsCountLabel.text = "\(cartItems.count)"
        } else {
            cartItemsCountLabel.text = "0"
        }
    }
    
    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabbarView.bounds
        tabBar?.configureTabUI(with: self.tabType)
        
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
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickProduct = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickSpecials = {
            DispatchQueue.main.async {
                let localStorageArray = LocalStorage.getFilteredData()
                if localStorageArray.count == 0 {
                    self.tabType = .home
                    self.configureTabBar()
                    self.presentPopUpVC(message: emptyCart, title: "")
                } else {
                    let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
                    confirmPaymentVC.tabType = .myOrders
                    self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
                }
            }        }
        
        tabBar?.didClickMore = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.tabbarView.addSubview(tabBar!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isChangedQuantity {
            DispatchQueue.main.async {
                self.sendRequestUpdateUserProductList()
            }
        }
        self.isChangedQuantity = false
        removeObserver()
    }
    
    @objc func totalAmountLabelTapped(_ sender: UITapGestureRecognizer) {
        let localStorageArray = LocalStorage.getFilteredData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = .special
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
    
    func configureGridOrList(showList: Int) {
        if showList == 1 {
            tableView.isHidden = true
            collectionView.isHidden = false
            
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
    //    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
    //        switch(gesture.state) {
    //        case .began:
    //            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
    //                break
    //            }
    //            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
    //        case .changed:
    //            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
    //        case .ended:
    //            collectionView.endInteractiveMovement()
    //        default:
    //            collectionView.cancelInteractiveMovement()
    //        }
    //    }
    
    //MARK: -> Helpers
    func configureUI() {
        let appName = UserDefaults.standard.object(forKey:UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        //        collectionView.delegate = self
        //        collectionView.dataSource = self
        //        tableView.delegate = self
        //        tableView.dataSource = self
        specialTitlesContainerView.layer.cornerRadius = Radius.titleViewRadius
        titleLabel.textColor = UIColor.white
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "SpecialProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpecialProductsCollectionViewCell")
        tableView.register(UINib(nibName: "ItemTableViewCellWithImage", bundle: nil), forCellReuseIdentifier: "ItemTableViewCellWithImage")
    }
    
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        let localStorageArray = LocalStorage.getItemsData()
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
    //MARK: Logout API
    func logout() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        db.deleteByClientCode(strClientCode: clientCode)
        self.arrSuppliers = db.readData()
        if(arrSuppliers.count != 0){
            
            if let strAppName = self.arrSuppliers[0]["supplier_name"]{
                UserDefaults.standard.set(strAppName, forKey:UserDefaultsKeys.AppName)
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
            let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
            
        } else {
            let tbc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
    
    @IBAction func cartrButton(_ sender: UIButton) {
        let localStorageArray = LocalStorage.getFilteredData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = .special
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
    //MARK: -> Button Actions
}

//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource
extension SpecialsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOfListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialProductsCollectionViewCell", for: indexPath) as! SpecialProductsCollectionViewCell
        cell.configureSpecialsData(data:viewModel.arrayOfListItems[indexPath.row], showImage: self.viewModel.showImage, showPrice: self.viewModel.showPrice)
        cell.containerVIew.layer.borderColor = UIColor.black.cgColor
        cell.containerVIew.layer.borderWidth = 1
        cell.containerVIew.layer.cornerRadius = 6
        cell.containerVIew.layer.masksToBounds = true
        cell.containerVIew.clipsToBounds = true
        
        cell.addIconImageView.image = Icons.add
        cell.delegeteMyListSuccess = self
        cell.quantityTextField.tag = indexPath.row
        
        cell.didClickProduct = {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
            vc.tabType = self.tabType
            vc.delegeteSuccess = self
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        cell.didClickProductNameLabel = {
            print("Product Name Label Click")
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
            vc.tabType = self.tabType
            vc.delegeteSuccess = self
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        //        vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
        //        vc.tabType = self.tabType
        //        vc.delegeteSuccess = self
        //        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel.showImage == "1" {
            return CGSize(width: (collectionView.bounds.width/2) - 3 , height: 230)
        } else {
            return CGSize(width: (collectionView.bounds.width/2) - 3 , height: 154)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

}

//MARK: ->  UITableViewDelegate, UITableViewDataSource
extension SpecialsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCellWithImage", for: indexPath) as! ItemTableViewCellWithImage
        cell.configureShowImage(isShow: self.viewModel.showImage)
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        cell.quantityTextField.isHidden = false
        cell.inactiveLabel.isHidden = true
        cell.inactiveLabel.text = ""
        cell.quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
        cell.addContainerView.isHidden = true
        cell.delegeteMyListSuccess = self
        cell.quantityTextField.tag = indexPath.row
        
        cell.didClickProduct = {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
            vc.tabType = self.tabType
            vc.delegeteSuccess = self
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        cell.didClickProductNameLabel = {
            print("Product Name Label Click")
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
            vc.tabType = self.tabType
            vc.delegeteSuccess = self
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        cell.didChangeQuantity = { value in
            cell.index = indexPath.row
            let itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
            if(value == "") {
                //                self.updateQuantityInArray(quantity: "0", sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                //
            } else  {
                //                self.updateQuantityInArray(quantity: value , sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
            }
        }
        //        cell.btnShowItemData = {
        //            self.showItemData(row: indexPath.row)
        //        }
        //cell.quantityTextField.delegate = self
        cell.quantityTextField.isEnabled  = true
        // cell.quantityTextField.tag = indexPath.row
        
        if let strUOM = viewModel.arrayOfListItems[indexPath.row].uom {
            cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        if let itemName = viewModel.arrayOfListItems[indexPath.row].item_name {
            if(itemName != "")  {
                cell.itemLabel.text = itemName
            }
        }
        
//        if let thumbImage = viewModel.arrayOfListItems[indexPath.row].thumb_image {
//            if(thumbImage != ""){
//                if let url = URL(string: thumbImage) {
//                    DispatchQueue.main.async {
//                        cell.itemImageView?.sd_setImage(with: url, placeholderImage: nil)
//                    }
//                }
//            } else {
//                cell.itemImageView?.image = nil
//            }
//        }
        if let thumb_image = viewModel.arrayOfListItems[indexPath.row].thumb_image {
            cell.itemImageView?.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else if let image = viewModel.arrayOfListItems[indexPath.row].image {
            cell.itemImageView?.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            cell.itemImageView?.image = Icons.placeholderImage
        }
        
        if let itemPrice = viewModel.arrayOfListItems[indexPath.row].item_price {
            let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
            cell.priceLabel.text =  currencySymbol + String(itemPrice)
        }
        
        if let strQuantity = Constants.getPrice(itemCode: viewModel.arrayOfListItems[indexPath.row].item_code) {
            if (strQuantity == "0.00" || strQuantity == "0") {
                if (viewModel.arrayOfListItems[indexPath.row].special_title == 1)
                {
                    cell.quantityTextField.text = ""
                }
                else
                {
                    if (viewModel.arrayOfListItems[indexPath.row].uom?.count == 0)
                    {
                        cell.quantityTextField.text = "0"
                    }
                    else
                    {
                        cell.quantityTextField.text = ""
                    }
                }
            } else {
                
                let floatQuantity = (strQuantity as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                cell.quantityTextField.text  = strQuantity as String
            }
        }
        
        if let specialItemID = viewModel.arrayOfListItems[indexPath.row].special_item_id {
            if ( specialItemID == 1)
            {
                if let strQuantity = viewModel.arrayOfListItems[indexPath.row].quantity {
                    if (strQuantity == "0.00" || strQuantity == "0") {
                        cell.starImageView.isHidden = false
                    }
                } else {
                    cell.starImageView.isHidden = true
                }
            }
            else
            {
                cell.starImageView.isHidden = true
            }
        }
        
        if let status = viewModel.arrayOfListItems[indexPath.row].status {
            if(status != "Active") {
                cell.inactiveLabel.text = "NA"
                cell.inactiveLabel.isHidden = false
                cell.quantityTextField.isHidden = true
                cell.priceLabel.isHidden  = true
                cell.specialIItemLabel.isHidden = true
                cell.itemLabel.isHidden = false
            } else {
                cell.quantityTextField.layer.borderWidth = 0.5
                cell.quantityTextField.layer.cornerRadius = 5
                cell.quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
                cell.quantityTextField.textColor = UIColor.black
                if let specialItemID = viewModel.arrayOfListItems[indexPath.row].special_item_id {
                    if (specialItemID == 1)
                    {
                        cell.specialIItemLabel.isHidden = true
                        cell.quantityTextField.isHidden = false
                        cell.priceLabel.isHidden = false
                        cell.itemLabel.isHidden = false
                        cell.quantityTextField.isEnabled = true
                    }
                    else
                    {
                        cell.specialIItemLabel.isHidden = true
                        cell.quantityTextField.isHidden = false
                        cell.quantityTextField.isEnabled = true
                        cell.priceLabel.isHidden = false
                        cell.itemLabel.isHidden = false
                    }
                } }}
        else {
            cell.inactiveLabel.text = "NA"
            cell.inactiveLabel.isHidden = false
            cell.quantityTextField.isHidden = true
            cell.priceLabel.isHidden  = true
            cell.specialIItemLabel.isHidden = true
            cell.itemLabel.isHidden = true
        }
        
        if(self.viewModel.showPrice == "0") {
            if let specialItemID = viewModel.arrayOfListItems[indexPath.row].special_item_id {
                if( specialItemID == 1){
                    cell.priceLabel.textColor = AppColors.redTextColor
                    cell.priceLabel.isHidden = false
                    
                } else {
                    cell.priceLabel.textColor = UIColor.black
                    cell.priceLabel.isHidden = true
                }
            }
        } else {
            if let specialItemID = viewModel.arrayOfListItems[indexPath.row].special_item_id {
                
                if( specialItemID == 1){
                    cell.priceLabel.textColor = AppColors.redTextColor
                    if let status = viewModel.arrayOfListItems[indexPath.row].status {
                        if(status != "Active") {
                            cell.priceLabel.isHidden = true
                        } else {
                            cell.priceLabel.isHidden = false
                        }
                    }
                } else {
                    cell.priceLabel.textColor = UIColor.black
                    if let status = viewModel.arrayOfListItems[indexPath.row].status {
                        if(status != "Active") {
                            cell.priceLabel.isHidden = true
                        } else {
                            cell.priceLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        if let specialTitle = viewModel.arrayOfListItems[indexPath.row].special_title {
            if(specialTitle == 1) {
                //viewModel.specialItemIndex = indexPath.row
                cell.specialIItemLabel.text = viewModel.arrayOfListItems[indexPath.row].item_name
                cell.specialIItemLabel.isHidden = false
                cell.itemLabel.isHidden = true
                cell.quantityTextField.isHidden = true
                cell.priceLabel.isHidden = true
                cell.starImageView.isHidden  = true
                cell.itemImageView.isHidden = true
            }
        }
        
        cell.starImageView.tintColor = UIColor.red
        cell.starImageView.image = UIImage(named: "starFill")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.showImage == "1" {
            return 100
        } else {
            return 74
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
//        vc.tabType = self.tabType
//        vc.delegeteSuccess = self
//        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: -> Delegete-Success
extension SpecialsViewController: DelegeteMyListSuccess {
    func updateArray(quantity: String,itemCode:String, index: Int) {
        if quantity != "" {
            self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfListItems
            self.viewModel.arrayOfNewListItems[index].quantity = quantity
            self.viewModel.arrayOfNewListItems[index].item_code = itemCode
            self.viewModel.arrayOfListItems = self.viewModel.arrayOfNewListItems
            self.updateTotaPrice()
            self.sendRequestUpdateUserProductList()
        }
    }
    
    func sendRequestUpdateUserProductList() {
        var arrUpdatedPriceQuantity = [[String:Any]]()
        
        //for i in 0..<viewModel.arrayOfNewListItems.count {
        let localStorageData = LocalStorage.getItemsData()
        for i in 0..<localStorageData.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            if let strQuantity = localStorageData[i].quantity {
                strQuantityy = strQuantity
            }
            if let strItemName = localStorageData[i].item_name {
                strItemNamee = strItemName
            }
            if let strItemCode  = localStorageData[i].item_code {
                strItemCodee = strItemCode
            }
            var dictData = [String:Any]()
            dictData["quantity"] = strQuantityy
            dictData["item_name"] = strItemNamee
            dictData["item_code"] = strItemCodee
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
        
        if(orderFlag == "") {
            orderFlag = "0"
        }
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
            UpdateProductList.type.rawValue:KeyConstants.appType ,
            UpdateProductList.app_type.rawValue:appType,
            UpdateProductList.client_code.rawValue:KeyConstants.clientCode ,
            UpdateProductList.user_code.rawValue:userID ,
            UpdateProductList.orderFlag.rawValue:orderFlag,
            UpdateProductList.cartItems.rawValue:arrUpdatedPriceQuantity,
            UpdateProductList.device_id.rawValue:Constants.deviceId,
        ]
        print("Update",JSON(dictParam))
        //self.isChipSelelect = !isChipSelelect //use for enable selected Chip
        self.updateProductList(with: dictParam)
    }
    
    func isSuceess(success: Bool, text: String, index: Int, measureQty:String) {
        self.isChangedQuantity = true
        if success {
            // if text != "" && text != "0" && text != "0.00" {
            guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
            self.viewModel.arrayOfListItems[index].quantity = text
            Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfListItems[index])
            //            } else {
            //                guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
            //                self.viewModel.arrayOfListItems[index].quantity = "0"
            //            }
        }
        self.updateTotaPrice()
    }
}

//MARK: -> View-Model Interaction
extension SpecialsViewController {
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
    
    func getHomeData() {
        self.getItems(with: self.viewModel.param() as [String : Any])
    }
    
    private func getItems(with param: [String: Any]) {
        self.view.endEditing(true)
        
        viewModel.getHomeData(with: param) { [self] data, error in
            if let getUserItemsData = data {
                if (getUserItemsData.status == 1) {
                    self.viewModel.homeData = getUserItemsData.data
                    
                    if let specialItemList = getUserItemsData.data?.specialInventories {
                        self.viewModel.arrayOfListItems = specialItemList
                    }
                    
                    if let allcategory = getUserItemsData.data?.allCategories {
                        self.viewModel.arrayOfCategory = allcategory
                    }
                    
                    if let show_image = getUserItemsData.show_image {
                        self.viewModel.showImage = show_image
                    }
                    
                    if let customerType = getUserItemsData.customerType {
                        UserDefaults.standard.set(customerType,forKey: UserDefaultsKeys.CustomerType)
                    }
                    
                    if let showPrice  = getUserItemsData.showPrice {
                        UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                        if(showPrice == "0"){
                            //self.totalPriceLabel.isHidden = true
                        } else {
                            //self.totalPriceLabel.isHidden = false
                        }
                        self.viewModel.showPrice = showPrice
                    }
                    
                    if(self.viewModel.showPrice != "0") {
                        self.updateTotaPrice()
                    }
                    
                    if let outletsNumber = getUserItemsData.outlets {
                        if(outletsNumber == 0 ){
                        } else if(outletsNumber == 1) {
                        }
                        else {
                            
                        }
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
                            if let arrItemsData = getUserItemsData.data
                            {
                                // self.viewModel.arrItemsData  = arrItemsData
                            }
                        } else {
                            self.viewModel.isCategoryExist = true
                            //self.showCollectionView()
                            //                            if let arrItemsWithCategoryData = getUserItemsData.data?.allCategories {
                            //                                self.viewModel.arrItemsCategoryData = arrItemsWithCategoryData
                            //                                if let arrItemsDataNew = self.viewModel.arrItemsCategoryData[0].data {
                            //                                    self.viewModel.arrItemsData = arrItemsDataNew
                            //                                }
                            //                                tableView.reloadData()
                            //                            }
                        }
                    }
                    
                    if(self.viewModel.showPrice != "0") {
                        self.updateTotaPrice()
                    }
                    
                } else if(getUserItemsData.status == 2){
                    guard let messge = getUserItemsData.message else {return}
                    self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                }
                else {
                    //self.itemsTableView.isHidden = true
                    //self.addProductButton.isHidden = false
                    //self.labelAddProduct.isHidden = false
                    // self.categoryCollectionView.isHidden = true
                    // self.viewOutlet.isHidden = true
                }
                if self.isShowList == 1 {
                    self.collectionView.reloadData()
                } else {
                    self.tableView.reloadData()
                }
                
                if self.isShowList == 0 {
                    self.configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                } else {
                    self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                }
            }
            if let error = error {
                if self.isShowList == 0 {
                    self.configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                } else {
                    self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                }
                print(error)
            }
        }
    }
}

//MARK: -> Background View
extension SpecialsViewController {
    private func configureBackground(with image: UIImage?, message: String, count: Int) {
        DispatchQueue.main.async { [self] in
            if count == 0 {
                if self.background == nil {
                    self.background = Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)?.first as? BackgroundView
                    self.background?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.background?.frame = self.backgroundView.bounds
                    self.background?.configureUI(with: image, message: message)
                }
                self.collectionView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                self.collectionView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                self.collectionView.reloadData()
            }
            
            if refreshEnable {
                background?.refreshButton.isHidden = true//false
            } else {
                background?.refreshButton.isHidden = true
            }
            
            self.background?.didClickRefreshButton = {
                self.getHomeData()
                self.updateTotaPrice()
                self.configureGridOrList(showList: isShowList ?? 0)
            }
            //self.background?.refreshButton.isHidden = true
        }
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
                tableView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                tableView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                self.tableView.reloadData()
            }
            if refreshEnable {
                background?.refreshButton.isHidden = true//false
            } else {
                background?.refreshButton.isHidden = true
            }
            
            self.background?.didClickRefreshButton = {
                self.getHomeData()
                self.updateTotaPrice()
                self.configureGridOrList(showList: isShowList ?? 0)
            }
            //self.background?.refreshButton.isHidden = true
        }
    }
}

//MARK: - PopUpDelegate
extension SpecialsViewController: PopUpDelegate {
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
            logout()
        } else {
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
            self.pushToOutlets()
        }
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

//MARK: -> Notification Center
extension SpecialsViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("tabChange"), object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        UserDefaults.standard.setValue(true, forKey: "tabChange")
    }
    
    @objc private func notificationReceived(notification: NSNotification) {
        print("tab changed ****")
        self.updateTotaPrice()
        if isShowList == 1 {
            collectionView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
}

//MARK: -> DelegeteSuccess
extension SpecialsViewController: DelegeteSuccess {
    func isSuceess(success: Bool, text: String) {
        self.updateTotaPrice()
        if isShowList == 0 {
            self.tableView.reloadData()
        } else {
            collectionView.reloadData()
        }
    }
}

//MARK: -> Handle-Background-State
extension SpecialsViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        print("handleAppDidBecomeActive")
        addObserver()
        getHomeData()
        self.updateTotaPrice()
    }
}
