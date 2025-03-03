//  ProductsViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import SwiftyJSON

class ProductsViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelButtonContainerView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var banerTableView: UITableView!
    @IBOutlet weak var bannerContainerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var outletsContainerView: UIView!
    @IBOutlet weak var outletsContainerWidthConst: NSLayoutConstraint!
    @IBOutlet weak var outletsContainerTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var OutletTableContainerView: UIView!
    @IBOutlet weak var outletsTableView: UITableView!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
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
    var viewModel = ProductsViewModel()
    var searching = false
    var refreshEnable = true
    var background: BackgroundView?
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var searchUserText = ""
    var categoryId: String = ""
    var selectedChipIndex: Int?
    var isClickCart: Bool = false
    var bannerImage = UserDefaults.standard.value(forKey: "bannerLists") as! [BannerList]?
    var isComingFromCommonSearch: Bool = UserDefaults.standard.bool(forKey: "isComingFromCommonSearch")
    var showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
    var isSelectedChip: Bool = false //Use for Banner Height 0.
    var page = 1
    var recordPerPage = 20
    var hasMoreItems: Bool = false
    var count = 0
    var isLoading: Bool = false
    var showList = UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int
    //var showList = 0
    var tabType: TabType = .myProduct
    var isChangedQuantity: Bool = false
    var scrollContent:Int = 0
    var isShowOutletsTable: Bool = false
    var alert:UIAlertController!
    var snakeBarMsg = "Search Products"
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    var isClickProductDetails: Bool = false
    var showAllItem: Bool = false
    let acmCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID)
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        self.searchTextField.text = ""
        self.searchUserText = ""
        if let isComeFromBanner = UserDefaults.standard.object(forKey: UserDefaultsKeys.isComeFromBanner) as? Bool {
            if !(isComeFromBanner) {
                self.categoryId = ""
            }
        } else {
            self.categoryId = ""
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.selectedChipIndex = 0
        let layout = productListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0) // Add bottom inset of 20
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        configureNavigation()
        configureUI()
        registerCell()
        configureGridOrList(showList: UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int ?? 0)
        //configureGridOrList(showList: 0)
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        
        self.tableViewHeightConstraint.constant = CGFloat(LocalStorage.getOutletsListData().count * 38)
        self.OutletTableContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        self.OutletTableContainerView.layer.borderWidth = Radius.searchViewborderWidth
        //self.outLetContainerViewHeightConstraint.constant = CGFloat(LocalStorage.getOutletsListData().count * 38 + 90 )
        self.OutletTableContainerView.layer.cornerRadius = Radius.searchViewRadius
        if let business_name = UserDefaults.standard.string(forKey: "BusinessName") {
            UserNameLabel.text = business_name
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tabType == .myList {
            snakeBarMsg = "My List"
        } else {
            snakeBarMsg = "Search Products"
        }
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
        self.configureCartImage()
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
                
            }
            outletHeaderLabel.isHidden = true
        }
        // self.configureOutletsView(noOfOutltes: 1)
        self.toggleOutletsListView(isShow: isShowOutletsTable)
        if let isComeFromBanner = UserDefaults.standard.object(forKey: UserDefaultsKeys.isComeFromBanner) as? Bool {
            if !(isComeFromBanner) {
                self.categoryId = ""
            }
        } else {
            self.categoryId = ""
        }
        addObserver()
        if !(isClickProductDetails) {
            self.showSnakeBar(message: self.snakeBarMsg)
            self.page = 1
            getCategories()
            if self.showList == 0 {
                self.tableView.setContentOffset(.zero, animated: false)
            } else {
                self.productListCollectionView.setContentOffset(.zero, animated: false)
            }
        }
        if searchTextField.text != "" {
            cancelButtonContainerView.isHidden = false
            self.selectedChipIndex = nil
        } else {
            cancelButtonContainerView.isHidden = true
        }
        didEnterBackgroundObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        //self.searchTextField.text = ""
        //self.searchUserText = ""
        self.categoryId = ""
        if self.isChangedQuantity {
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
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountDetailsVC") as! AccountDetailsVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        self.outletsTableView.reloadData()
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
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
    
    //MARK: -> Helpers
    private func configureNavigation() {
        let SearchView = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as? SearchView
        SearchView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        SearchView?.frame = self.searchView.bounds
        SearchView?.configureUI(totalAmount: "$37.20")
    }
    
    private func configureUI() {
        let appName = UserDefaults.standard.object(forKey:UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        self.viewModel.arrSuppliers = viewModel.db.readData()
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.prefetchDataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        outletsTableView.delegate = self
        outletsTableView.dataSource = self
        
        outletsContainerView.layer.cornerRadius = Radius.searchViewRadius
        outletsContainerView.layer.borderWidth = Radius.searchViewborderWidth
        outletsContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        
        //        productListCollectionView.delegate = self
        //        productListCollectionView.dataSource = self
        //        productListCollectionView.prefetchDataSource = self
        //        tableView.delegate = self
        //        tableView.dataSource = self
        //        tableView.prefetchDataSource = self
        
        searchTextField.delegate = self
        viewModel.strResetValue = "0"
        self.viewModel.showPrice = "0"
        self.viewModel.showImage = "0"
        cancelButtonContainerView.isHidden = true
        banerTableView.delegate = self
        banerTableView.dataSource = self
        searchView.layer.cornerRadius = Radius.searchViewRadius
        searchView.layer.borderWidth = Radius.searchViewborderWidth
        searchView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH ALL PRODUCTS",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
    }
    
    private func registerCell() {
        chipsCollectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
        productListCollectionView.register(UINib(nibName: "SpecialProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpecialProductsCollectionViewCell")
        tableView.register(UINib(nibName: "MyProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "MyProductListTableViewCell")
        tableView.register(UINib(nibName: "ItemTableViewCellWithImage", bundle: nil), forCellReuseIdentifier: "ItemTableViewCellWithImage")
        banerTableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
        outletsTableView.register(UINib(nibName: "OutletsTableViewCell", bundle: nil), forCellReuseIdentifier: "OutletsTableViewCell")
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = productListCollectionView.indexPathForItem(at: gesture.location(in: productListCollectionView)) else {
                break
            }
            productListCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            productListCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            productListCollectionView.endInteractiveMovement()
        default:
            productListCollectionView.cancelInteractiveMovement()
        }
    }
    
    
    @objc func tableViewLongPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizer.State.began:
            if indexPath != nil {
                let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell?
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            cell?.alpha = 1
                        })
                    } else {
                        cell?.isHidden = true
                    }
                })
            }
        case UIGestureRecognizer.State.changed:
            if searching {
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    viewModel.arrayOfFilteredData.insert(viewModel.arrayOfFilteredData.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            } else {
                if viewModel.arrayOfListItems.count > 0 {
                    if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                        viewModel.arrayOfListItems.insert( viewModel.arrayOfListItems.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                        tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                        Path.initialIndexPath = indexPath
                    }
                }           }
        default:
            print("default:")
        }
    }
    
    func configureGridOrList(showList: Int) {
        searching = false
        tableView.reloadData()
        if showList == 1 {
            tableView.isHidden = true
            productListCollectionView.isHidden = false
            //            productListCollectionView.delegate = self
            //            productListCollectionView.dataSource = self
            //            productListCollectionView.prefetchDataSource = self
            productListCollectionView.reloadData()
        } else {
            tableView.isHidden = false
            productListCollectionView.isHidden = true
            //            tableView.delegate = self
            //            tableView.dataSource = self
            //            tableView.prefetchDataSource = self
            tableView.reloadData()
        }
    }
    
    //MARK: -> Background View
    private func configureBackground(with image: UIImage?, message: String, count: Int) {
        DispatchQueue.main.async { [self] in
            if count == 0 {
                if isSelectedChip {
                    bannerContainerViewHeightConst.constant = Constants.bannerHeight
                } else {
                    bannerContainerViewHeightConst.constant = 0
                }
                if self.background == nil {
                    self.background = Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)?.first as? BackgroundView
                    self.background?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.background?.frame = self.backgroundView.bounds
                    self.background?.configureUI(with: image, message: message)
                }
                self.productListCollectionView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                bannerContainerViewHeightConst.constant = Constants.bannerHeight
                
                self.productListCollectionView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                self.productListCollectionView.reloadData()
            }
            
            if refreshEnable {
                background?.refreshButton.isHidden = true//false
            } else {
                background?.refreshButton.isHidden = true
            }
            
            self.background?.didClickRefreshButton = {
                self.categoryId = ""
                self.searchUserText = ""
                self.selectedChipIndex = 0
                searchTextField.text = ""
                self.getCategories()
            }
        }
    }
    
    private func configureBackgroundList(with image: UIImage?, message: String, count: Int) {
        DispatchQueue.main.async { [self] in
            if count == 0 {
                if isSelectedChip {
                    bannerContainerViewHeightConst.constant = Constants.bannerHeight
                } else {
                    bannerContainerViewHeightConst.constant = 0
                }
                if self.background == nil {
                    self.background = Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)?.first as? BackgroundView
                    self.background?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.background?.frame = self.backgroundView.bounds
                    self.background?.configureUI(with: image, message: message)
                }
                tableView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                bannerContainerViewHeightConst.constant = Constants.bannerHeight
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
                self.categoryId = ""
                self.searchUserText = ""
                searchTextField.text = ""
                self.selectedChipIndex = 0
                self.getCategories()
            }
        }
    }
    
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        //for i in 0..<self.viewModel.arrayOfListItems.count {
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
        //self.totalPriceButton.setTitle(strTitleTotalPriceButton , for: .normal)
        //        if strTottalPrice == "0" || strTottalPrice == "0.00" {
        //            totalPriceLabel.isHidden = true
        //        } else {
        //            totalPriceLabel.isHidden = false
        //            self.totalPriceLabel.text = strTitleTotalPriceButton
        //}
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
    
    //MARK: - GO TO SHOW DATA METHODS
    func showItemData(row:Int, searching: Bool){
        if searching {
            DispatchQueue.main.async {
                let imageUrl = self.viewModel.arrayOfFilteredData[row].image ?? ""
                let itemCode = self.viewModel.arrayOfFilteredData[row].item_code ?? ""
                let description = self.viewModel.arrayOfFilteredData[row].image_description ?? ""
                let itemName = self.viewModel.arrayOfFilteredData[row].item_name ?? ""
                let specialTitle = self.viewModel.arrayOfFilteredData[row].special_title ?? 0
                if(specialTitle != 1) {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowItemDataViewController") as? ShowItemDataViewController else {return}
                    vc.viewModel.imgUrl = imageUrl
                    vc.viewModel.itemCode = itemCode
                    vc.viewModel.itemDescription = description
                    vc.viewModel.itemName = itemName
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }
            }
        } else {
            DispatchQueue.main.async {
                let imageUrl = self.viewModel.arrayOfListItems[row].image ?? ""
                let itemCode = self.viewModel.arrayOfListItems[row].item_code ?? ""
                let description = self.viewModel.arrayOfListItems[row].image_description ?? ""
                let itemName = self.viewModel.arrayOfListItems[row].item_name ?? ""
                let specialTitle = self.viewModel.arrayOfListItems[row].special_title ?? 0
                if(specialTitle != 1) {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowItemDataViewController") as? ShowItemDataViewController else {return}
                    vc.viewModel.imgUrl = imageUrl
                    vc.viewModel.itemCode = itemCode
                    vc.viewModel.itemDescription = description
                    vc.viewModel.itemName = itemName
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    
    //MARK: - GO TO CONFIRM PAYMENT PAGE
    func goToConfirmPaymentPage() {
        // let nav :HamburguerNavigationController = self.mainNavigationController()
        let confirmPaymentVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
        //nav.setViewControllers([confirmPaymentVC], animated: false)
        confirmPaymentVC.arrSelectedItems = self.viewModel.arrayOfItemsToSend
        confirmPaymentVC.showPrice = self.viewModel.showPrice
        //        confirmPaymentVC.strFeature = "Yes"
        //        confirmPaymentVC.strPoNumber = myListReviewOrderCollectionViewCell?.poNumberTextFiedl.text ?? ""
        confirmPaymentVC.strShowImage = self.viewModel.showImage
        //        confirmPaymentVC.strComment = myListReviewOrderCollectionViewCell?.commentTextView.text ?? ""
        //        confirmPaymentVC.strDeliveryDate = myListReviewOrderCollectionViewCell?.deliveryDateLabel.text ?? ""
        //        confirmPaymentVC.strContactNo = self.viewModel.strContactNumber
        confirmPaymentVC.strPickUpDelivery = self.viewModel.strDeliveryPickUP
        confirmPaymentVC.strMinOrderValue = self.viewModel.strMinOrderValue
        confirmPaymentVC.strDeliveryCharge = self.viewModel.strDeliveryCharge
        confirmPaymentVC.floatTotalPrice = self.viewModel.floatTotalPrice
        confirmPaymentVC.showPO = self.viewModel.showPO
        self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
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
    
    func toggleOutletsListView(isShow: Bool) {
        if isShow {
            OutletTableContainerView.isHidden = false
        } else {
            OutletTableContainerView.isHidden = true
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
    
    //MARK: -> Button Actions
    @IBAction func changeOutletButton(_ sender: UIButton) {
        print("Change Outlets")
        let arrayOfOutlets = LocalStorage.getOutletsListData()
        print(arrayOfOutlets.count)
        self.isShowOutletsTable = !self.isShowOutletsTable
        self.toggleOutletsListView(isShow: isShowOutletsTable)
    }
    
    
    @IBAction func switchCustomer(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey:  UserDefaultsKeys.outletsListData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let switchCustomerVC = storyboard.instantiateViewController(withIdentifier: "CustomerListViewController") as! CustomerListViewController
        self.navigationController?.pushViewController(switchCustomerVC, animated: false)
    }
    

    @IBAction func searchTextDidChange(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        //self.searchText(with: text)
        if text.count > 0 {
            cancelButtonContainerView.isHidden = false
        } else {
            cancelButtonContainerView.isHidden = true
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        searchUserText = ""
        searchTextField.text = ""
        cancelButtonContainerView.isHidden = true
        self.page = 1
        if viewModel.arrayOfChips.count > 0 {
            if let id = viewModel.arrayOfChips[0].id {
                // getItecmsById(categoryID: id)
                self.categoryId = id
                viewModel.arrayOfChips[0].isSlected = true
                getItems()
            }
        }
        
        let isShowBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
        if isShowBanner == 1 && self.viewModel.arrayOfBanner.count > 0  {
            scrollContent = 0
            bannerContainerViewHeightConst.constant = Constants.bannerHeight
            banerTableView.isHidden = false
            self.banerTableView.beginUpdates()
            self.banerTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.banerTableView.endUpdates()
        }
        
        if showList == 0 {
            let topRow = IndexPath(row: 0, section: 0)
            //self.tableView.scrollToRow(at: topRow,  at: .top, animated: false)
        } else {
            self.productListCollectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    @IBAction func cartButton(_ sender: UIButton) {
        //        self.viewModel.isClickCart = true
        //        sendRequestUpdateUserProductList()
        //          //goToConfirmPaymentPage()
        
        var localStorageArray = LocalStorage.getFilteredData()
         localStorageArray += LocalStorage.getFilteredMultiData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
}

//MARK: ->  UITableViewDelegate, UITableViewDataSource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == banerTableView  {
            return 1
        } else  if tableView == outletsTableView {
            return LocalStorage.getOutletsListData().count
        } else {
            if !searching {
                return viewModel.arrayOfListItems.count
            } else {
                return viewModel.arrayOfFilteredData.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == banerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
            cell.configureUI()
            cell.delegeteBannerImageClick = self
            cell.configureUI(with: self.viewModel.arrayOfBanner)
            return cell
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCellWithImage", for: indexPath) as! ItemTableViewCellWithImage
            cell.configureShowImage(isShow: self.viewModel.showImage)
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            cell.quantityTextField.isHidden = false
            cell.inactiveLabel.isHidden = true
            cell.inactiveLabel.text = ""
            cell.quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
            cell.delegeteMyListSuccess = self
            cell.quantityTextField.tag = indexPath.row
            cell.measureTexfield .tag = indexPath.row
           // cell.measureLabel.text = "\(Constants.getCount(itemCode: self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""))"
            
            cell.didClickProduct = {
                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                if self.searching {
                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                } else {
                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                }
                vc.tabType = self.tabType
                vc.delegeteSuccess = self
                self.isClickProductDetails = true
                vc.updateQuantityDelegate = self
                vc.showImage = self.viewModel.showImage
                vc.indexPath = indexPath
                self.navigationController?.pushViewController(vc, animated: false)
            }
           
            cell.didClickShowList = {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowListPopUpViewController") as? ShowListPopUpViewController
                nextVC?.refreshDelegate = self
                if self.searching {
                    nextVC?.itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code ?? ""
                } else {
                    nextVC?.itemCode  = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
                }
                nextVC?.modalPresentationStyle = .overFullScreen
                self.present(nextVC!, animated: false, completion: nil)
            }
            
            cell.didClickAdd = {
                print("didClickAddItemToCart")
                var itemCode = ""
                if self.searching {
                    itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code ?? ""
                } else {
                    itemCode  = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
                }
                
                if let selectedItem = Constants.getCartItem(itemCode: itemCode) {
                    var mutatedItem = selectedItem
                    if mutatedItem.originQty != "0" && mutatedItem.originQty != "0.0" && mutatedItem.originQty != "0.00" && mutatedItem.measureQty != "0" && mutatedItem.measureQty != "0.0" && mutatedItem.measureQty != "0.00" && mutatedItem.originQty != "" && mutatedItem.measureQty != "" {
                        mutatedItem.priority = 0
                        mutatedItem.id = 0
                        var data = LocalStorage.getShowItData()
                        data.append(mutatedItem)
                        LocalStorage.saveMultiData(data: data)
                        LocalStorage.deleteGetItemsIndex(itemCode: itemCode)
                        self.tableView.reloadData()
                        
                    }
                }
            }
            
            cell.didClickProductNameLabel = {
                print("Click Product Name Label")
                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                if self.searching {
                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                } else {
                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                }
                vc.tabType = self.tabType
                vc.delegeteSuccess = self
                self.isClickProductDetails = true
                vc.updateQuantityDelegate = self
                vc.showImage = self.viewModel.showImage
                vc.indexPath = indexPath
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
            if self.searching {
                if self.viewModel.arrayOfFilteredData[indexPath.row].inMyList == 0 {
                    cell.addIcon.image = Icons.add
                } else {
                    cell.addIcon.image = UIImage()
                }
            } else {
                if self.viewModel.arrayOfListItems.count != 0 {
                    if self.viewModel.arrayOfListItems[indexPath.row].inMyList == 0 {
                        cell.addIcon.image = Icons.add
                    } else {
                        cell.addIcon.image = UIImage()
                    }
                }
            }
            
            cell.addItemButton = {
                if self.searching {
                    if let itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code {
                        self.viewModel.itemCode = itemCode
                        if self.viewModel.arrayOfFilteredData[indexPath.row].inMyList == 0 {
                            self.addProduct(param: self.viewModel.AddProductParam() as [String : Any], itemCode: itemCode)
                        } else {
                            print("call Delete Api")
                           // self.deleteItemWithId(itemCode: itemCode)
                        }
                    }
                } else {
                    if let itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code {
                        self.viewModel.itemCode = itemCode
                        //self.addProduct(param: self.viewModel.AddProductParam() as [String : Any], itemCode: itemCode)
                        if self.viewModel.arrayOfListItems[indexPath.row].inMyList == 0 {
                            self.addProduct(param: self.viewModel.AddProductParam() as [String : Any], itemCode: itemCode)
                        } else {
                            print("call Delete Api")
                           // self.deleteItemWithId(itemCode: itemCode)
                        }
                    }
                }
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
            
            
            if searching {
                if let strUOM = viewModel.arrayOfFilteredData[indexPath.row].uom {
                    cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                }
                cell.measureTexfield.attributedPlaceholder = NSAttributedString(string: "QTY",
                                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                if let itemName = viewModel.arrayOfFilteredData[indexPath.row].item_name {
                    if(itemName != "")
                    {
                        cell.itemLabel.text = itemName
                    }
                }
                
//                if let thumbImage = viewModel.arrayOfFilteredData[indexPath.row].thumb_image {
//                    if(thumbImage != ""){
//                        if let url = URL(string: thumbImage) {
//                            DispatchQueue.main.async {
//                                cell.itemImageView?.sd_setImage(with: url, placeholderImage: nil)
//                            }
//                        }
//                    } else {
//                        cell.itemImageView?.image = nil
//                    }
//                }
                if let thumb_image = viewModel.arrayOfFilteredData[indexPath.row].thumb_image {
                    cell.itemImageView?.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
                } else if let image = viewModel.arrayOfFilteredData[indexPath.row].image {
                    cell.itemImageView?.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
                } else {
                    cell.itemImageView?.image = Icons.placeholderImage
                }
                
                if let itemPrice = viewModel.arrayOfFilteredData[indexPath.row].item_price {
                    let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
                    cell.priceLabel.text =  currencySymbol + String(itemPrice)
                }
                
                if let strMeasure = Constants.getMeasure(itemCode: viewModel.arrayOfFilteredData[indexPath.row].item_code) {
                    let floatQuantity = (strMeasure as NSString).floatValue.clean
                    let strQuantity = String(floatQuantity)
                    cell.measureTexfield.text  = strQuantity as String
                } else {
                    cell.measureTexfield.text  = ""
                }
                
                if let strQuantity = Constants.getPrice(itemCode:  viewModel.arrayOfFilteredData[indexPath.row].item_code) {
                    if (strQuantity == "0.00" || strQuantity == "0") {
                        if (viewModel.arrayOfFilteredData[indexPath.row].special_title == 1)
                        {
                            cell.quantityTextField.text = "";
                        }
                        else
                        {
                            if (viewModel.arrayOfFilteredData[indexPath.row].uom?.count == 0)
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
                } else {
                    cell.quantityTextField.text  = ""
                }
                
                if let specialItemID = viewModel.arrayOfFilteredData[indexPath.row].special_item_id {
                    if ( specialItemID == 1) {
                        if let strQuantity = viewModel.arrayOfFilteredData[indexPath.row].quantity {
                            if (strQuantity == "0.00" || strQuantity == "0") {
                                cell.starImageView.isHidden = false
                            } else {
                                cell.starImageView.isHidden = true
                            }
                        } else {
                            cell.starImageView.isHidden = true
                        }
                    }
                    else {
                        cell.starImageView.isHidden = true
                    }
                }
                
                
                if let isMeasure = viewModel.arrayOfFilteredData[indexPath.row].is_meas_box {
                    cell.configureIsMeasureShow(isMeasure: isMeasure)
                }
                
                if let status = viewModel.arrayOfFilteredData[indexPath.row].status {
                    if(status != "Active") {
                        cell.inactiveLabel.text = "NA"
                        cell.inactiveLabel.isHidden = false
                        cell.quantityTextField.isHidden = true
                        cell.priceLabel.isHidden  = true
                        cell.specialIItemLabel.isHidden = true
                        cell.itemLabel.isHidden = false
                    } else {
                        cell.quantityTextField.layer.borderWidth = 0.5;
                        cell.quantityTextField.layer.cornerRadius = 5;
                        cell.quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                        cell.quantityTextField.textColor = UIColor.black
                        if let specialItemID = viewModel.arrayOfFilteredData[indexPath.row].special_item_id {
                            if (specialItemID == 1) {
                                cell.specialIItemLabel.isHidden = true
                                cell.quantityTextField.isHidden = false
                                cell.priceLabel.isHidden = false
                                cell.itemLabel.isHidden = false
                                cell.quantityTextField.isEnabled = true
                            }
                            else {
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
                    if let specialItemID = viewModel.arrayOfFilteredData[indexPath.row].special_item_id {
                        if( specialItemID == 1){
                            cell.priceLabel.textColor = AppColors.redTextColor
                            cell.priceLabel.isHidden = false
                            
                        } else {
                            cell.priceLabel.textColor = UIColor.black
                            cell.priceLabel.isHidden = true
                        }
                    }
                } else {
                    if let specialItemID = viewModel.arrayOfFilteredData[indexPath.row].special_item_id {
                        
                        if( specialItemID == 1){
                            cell.priceLabel.textColor = AppColors.redTextColor
                            if let status = viewModel.arrayOfFilteredData[indexPath.row].status {
                                if(status != "Active") {
                                    cell.priceLabel.isHidden = true
                                } else {
                                    cell.priceLabel.isHidden = false
                                }
                            }
                        } else {
                            cell.priceLabel.textColor = UIColor.black
                            if let status = viewModel.arrayOfFilteredData[indexPath.row].status {
                                if(status != "Active") {
                                    cell.priceLabel.isHidden = true
                                } else {
                                    cell.priceLabel.isHidden = false
                                }
                            }
                        }
                    }
                }
                
                var  multiItemCount = Constants.getCount(itemCode: self.viewModel.arrayOfFilteredData[indexPath.row].item_code)
                 if multiItemCount != 0 {
                     cell.measureLabel.isHidden = false
                     cell.measureLabel.text = ("\(multiItemCount)")
                     
                 } else {
                     cell.measureLabel.text = ""
                     cell.measureLabel.isHidden = true
                 }
                
                if let specialTitle = viewModel.arrayOfFilteredData[indexPath.row].special_title {
                    if(specialTitle == 1) {
                        //viewModel.specialItemIndex = indexPath.row
                        cell.specialIItemLabel.text = viewModel.arrayOfFilteredData[indexPath.row].item_name
                        cell.specialIItemLabel.isHidden = false
                        cell.itemLabel.isHidden = true
                        cell.quantityTextField.isHidden = true
                        cell.priceLabel.isHidden = true
                        cell.starImageView.isHidden  = true
                        cell.itemImageView.isHidden = true
                    }
                }
            } else {
                if viewModel.arrayOfListItems.count > 0 {
                    if let strUOM = viewModel.arrayOfListItems[indexPath.row].uom {
                        cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    }
                    
                    cell.measureTexfield.attributedPlaceholder = NSAttributedString(string: "QTY",
                                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    
                    
                    if let itemName = viewModel.arrayOfListItems[indexPath.row].item_name {
                        if(itemName != "")
                        {
                            cell.itemLabel.text = itemName
                        }
                    }
                    
                    
                    var  multiItemCount = Constants.getCount(itemCode: self.viewModel.arrayOfListItems[indexPath.row].item_code)
                     if multiItemCount != 0 {
                         cell.measureLabel.isHidden = false
                         cell.measureLabel.text = ("\(multiItemCount)")
                         
                     } else {
                         cell.measureLabel.text = ""
                         cell.measureLabel.isHidden = true
                     }
                    
//                    if let thumbImage = viewModel.arrayOfListItems[indexPath.row].thumb_image {
//                        if(thumbImage != ""){
//                            if let url = URL(string: thumbImage) {
//                                DispatchQueue.main.async {
//                                    cell.itemImageView?.sd_setImage(with: url, placeholderImage: nil)
//                                }
//                            }
//                        } else {
//                            cell.itemImageView?.image = nil
//                        }
//                    }
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
                                cell.quantityTextField.text = "";
                            }
                            else
                            {
                                if (viewModel.arrayOfListItems[indexPath.row].uom?.count == 0)
                                {
                                    cell.quantityTextField.text = "0";
                                }
                                else
                                {
                                    cell.quantityTextField.text = "";
                                }
                            }
                        } else {
                            
                            let floatQuantity = (strQuantity as NSString).floatValue.clean
                            let strQuantity = String(floatQuantity)
                            cell.quantityTextField.text  = strQuantity as String
                        }
                    } else {
                        cell.quantityTextField.text  = ""
                    }
                    
                    if let strMeasure = Constants.getMeasure(itemCode: viewModel.arrayOfListItems[indexPath.row].item_code) {
                        let floatQuantity = (strMeasure as NSString).floatValue.clean
                        let strQuantity = String(floatQuantity)
                        cell.measureTexfield.text  = strQuantity as String
                    } else {
                        cell.measureTexfield.text  = ""
                    }
                    
                    if let isMeasure = viewModel.arrayOfListItems[indexPath.row].is_meas_box {
                        cell.configureIsMeasureShow(isMeasure: isMeasure)
                    }
                    
                    if let specialItemID = viewModel.arrayOfListItems[indexPath.row].special_item_id {
                        if ( specialItemID == 1)
                        {
                            if let strQuantity = viewModel.arrayOfListItems[indexPath.row].quantity {
                                if (strQuantity == "0.00" || strQuantity == "0") {
                                    cell.starImageView.isHidden = false
                                } else {
                                    cell.starImageView.isHidden = true
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
                            cell.quantityTextField.layer.borderWidth = 0.5;
                            cell.quantityTextField.layer.cornerRadius = 5;
                            cell.quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
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
                }
            }
            
            cell.starImageView.tintColor = UIColor.red
            cell.starImageView.image = UIImage(named: "starFill")
            return cell
        }
    }
    
    //    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    //        let dragItem = UIDragItem(itemProvider: NSItemProvider())
    //        if searching {
    //            dragItem.localObject =  self.viewModel.arrayOfFilteredData[indexPath.row]
    //        } else {
    //            dragItem.localObject =  self.viewModel.arrayOfListItems[indexPath.row]
    //        }
    //        return [ dragItem ]
    //    }
    //
    //    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        // Update the model
    //        if searching {
    //            let mover = self.viewModel.arrayOfFilteredData.remove(at: sourceIndexPath.row)
    //            self.viewModel.arrayOfFilteredData.insert(mover, at: destinationIndexPath.row)
    //        } else {
    //            let mover = self.viewModel.arrayOfListItems.remove(at: sourceIndexPath.row)
    //            self.viewModel.arrayOfListItems.insert(mover, at: destinationIndexPath.row)
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == banerTableView {
            let banner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
            if banner == 1 {
                if banner == 1 && self.viewModel.arrayOfListItems.count > 0 && !self.isSelectedChip && self.page <= 2 {
                    print("Case 1")
                    bannerContainerViewHeightConst.constant = Constants.bannerHeight
                    return Constants.bannerHeight
                } else if isSelectedChip && self.page <= 2 {
                    print("Case 2")
                    bannerContainerViewHeightConst.constant = Constants.bannerHeight
                    return Constants.bannerHeight
                } else if banner == 1 && self.viewModel.arrayOfListItems.count > 0 && self.scrollContent == 0 && self.page > 2 {
                    print("scrollContent",self.scrollContent)
                    print("Case 3")
                    bannerContainerViewHeightConst.constant = Constants.bannerHeight
                    return Constants.bannerHeight
                }  else {
                    print("else case")
                    bannerContainerViewHeightConst.constant = 0
                    return 0
                }
            } else {
                bannerContainerViewHeightConst.constant = 0
                return 0
            }
        } else if tableView == outletsTableView {
            return 38
        }  else {
            if self.viewModel.showImage == "1" {
                return 130
            } else {
                return 96
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            //            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            //            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            //            vc.tabType = self.tabType
            //            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
            //            vc.delegeteSuccess = self
            //            self.navigationController?.pushViewController(vc, animated: false)
        } else if tableView == outletsTableView {
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
                requestForRegisterUserDevice()
            }
        }
    }
}

//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == chipsCollectionView {
            return viewModel.arrayOfChips.count
        } else {
            if !searching {
                return viewModel.arrayOfListItems.count
            } else {
                return viewModel.arrayOfFilteredData.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == chipsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipsCollectionViewCell", for: indexPath) as! ChipsCollectionViewCell
            cell.configureUI()
            //viewModel.arrayOfChips[selectedChipIndex].isSlected = true
            cell.configureData(chipsData: viewModel.arrayOfChips[indexPath.row])
            if indexPath.row == viewModel.arrayOfChips.count - 1 {
                cell.rightSeparatorView.backgroundColor = UIColor.white
            } else {
                cell.rightSeparatorView.backgroundColor = UIColor.black
            }
            return  cell
        } else {
            
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialProductsCollectionViewCell", for: indexPath) as! SpecialProductsCollectionViewCell
            cellB.configureUI()
            cellB.delegeteMyListSuccess = self
            cellB.quantityTextField.tag = indexPath.row
            cellB.measureTextField.tag = indexPath.row
            var multiItemCount = 0
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                cellB.quantityTextFieldWidth.constant = 140
//                cellB.measureTextFieldWidth.constant = 140
//            } else {
//                cellB.quantityTextFieldWidth.constant = 48
//                cellB.measureTextFieldWidth.constant = 48
//            }
            if searching {
                if viewModel.arrayOfFilteredData.count > 0 {
                    cellB.configureProductListData(data:viewModel.arrayOfFilteredData[indexPath.row], showPrice: self.viewModel.showPrice, showImage: self.viewModel.showImage, showAllItem: self.showAllItem)
                    multiItemCount = Constants.getCount(itemCode: self.viewModel.arrayOfFilteredData[indexPath.row].item_code)
                }
            } else {
                if viewModel.arrayOfListItems.count > 0 {
                    cellB.configureProductListData(data:viewModel.arrayOfListItems[indexPath.row],showPrice: self.viewModel.showPrice, showImage: self.viewModel.showImage,  showAllItem: self.showAllItem)
                    multiItemCount = Constants.getCount(itemCode: self.viewModel.arrayOfListItems[indexPath.row].item_code)
                }
            }
            if multiItemCount != 0 {
                cellB.multiItemCount.isHidden = false
                cellB.multiItemCount.text = ("\(multiItemCount)")
                
            } else {
                cellB.multiItemCount.text = ""
                cellB.multiItemCount.isHidden = true
            }
            
            cellB.didClickAdd = {
                if self.searching {
                    if let itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code {
                        self.viewModel.itemCode = itemCode
                        if self.viewModel.arrayOfFilteredData[indexPath.row].inMyList == 0 {
                            self.addProduct(param: self.viewModel.AddProductParam() as [String : Any], itemCode: itemCode)
                        } else {
                            print("call Delete Api")
                            self.deleteItemWithId(itemCode: itemCode)
                        }
                    }
                } else {
                    if let itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code {
                        self.viewModel.itemCode = itemCode
                        if self.viewModel.arrayOfListItems[indexPath.row].inMyList == 0 {
                            self.addProduct(param: self.viewModel.AddProductParam() as [String : Any], itemCode: itemCode)
                        } else {
                            print("call Delete Api")
                            self.deleteItemWithId(itemCode: itemCode)
                        }
                    }
                }
            }
            
            
            cellB.didClickShowList = {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowListPopUpViewController") as? ShowListPopUpViewController
                nextVC?.itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
                nextVC?.refreshDelegate = self
                nextVC?.modalPresentationStyle = .overFullScreen
                self.present(nextVC!, animated: false, completion: nil)
            }
            
            cellB.didClickAddItemToCart = {
                print("didClickAddItemToCart")
                var itemCode = ""
                if self.searching {
                    itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code ?? ""
                } else {
                    itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
                }
                if let selectedItem = Constants.getCartItem(itemCode: itemCode) {
                    var mutatedItem = selectedItem
                    if mutatedItem.originQty != "0" && mutatedItem.originQty != "0.0" && mutatedItem.originQty != "0.00" && mutatedItem.measureQty != "0" && mutatedItem.measureQty != "0.0" && mutatedItem.measureQty != "0.00" && mutatedItem.originQty != "" && mutatedItem.measureQty != "" {
                        mutatedItem.priority = 0
                        mutatedItem.id = 0
                        var data = LocalStorage.getShowItData()
                            data.append(mutatedItem)
                        LocalStorage.saveMultiData(data: data)
                        LocalStorage.deleteGetItemsIndex(itemCode: itemCode ?? "")
                        self.productListCollectionView.reloadData()
                        
                    }
                }
                
            }
            
            cellB.didClickProduct = {
                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                self.isClickProductDetails = true
                vc.delegeteSuccess = self
                vc.showImage = self.viewModel.showImage
                if self.searching {
                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                } else {
                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                }
                vc.tabType = self.tabType
                vc.updateQuantityDelegate = self
                vc.indexPath = indexPath
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
            cellB.didClickProductNameLabel = {
                print("Click Product Name Label")
                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                self.isClickProductDetails = true
                vc.delegeteSuccess = self
                vc.showImage = self.viewModel.showImage
                if self.searching {
                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                } else {
                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                }
                vc.tabType = self.tabType
                vc.updateQuantityDelegate = self
                vc.indexPath = indexPath
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
            return cellB
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == chipsCollectionView {
            if self.selectedChipIndex != indexPath.row {
                self.isSelectedChip = true
                self.searchTextField.text = ""
                self.searchUserText = ""
                cancelButtonContainerView.isHidden = true
                for i in 0...viewModel.arrayOfChips.count - 1 {
                    if let selectedChipIndex = selectedChipIndex {
                        viewModel.arrayOfChips[selectedChipIndex].isSlected = false
                    }
                }
                self.selectedChipIndex = indexPath.row
                viewModel.arrayOfChips[indexPath.row].isSlected = true
                
                if let id = viewModel.arrayOfChips[indexPath.row].id {
                    // getItecmsById(categoryID: id)
                    self.page = 1
                    self.categoryId = id
                    getItems()
                }
                collectionView.reloadData()
                
                if showList == 0 {
                    let topRow = IndexPath(row: 0, section: 0)
                    //self.tableView.scrollToRow(at: topRow,  at: .top, animated: false)
                } else {
                    self.productListCollectionView.setContentOffset(.zero, animated: false)
                }
            }
        } else {
            //            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            //            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            //            vc.delegeteSuccess = self
            //            if searching {
            //                vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
            //            } else {
            //                vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
            //            }
            //            vc.tabType = self.tabType
            //            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == chipsCollectionView {
            if let categoryName = self.viewModel.arrayOfChips[indexPath.row].name {
                let label = UILabel(frame: CGRect.zero)
                label.text = categoryName
                label.sizeToFit()
                if label.text?.count == 1 {
                    return CGSize(width:40 ,height:14);
                } else {
                    return CGSize(width:label.frame.size.width + 4,height:14)
                }
            }
            return CGSize(width:120,height:14)
        } else {
            if viewModel.showImage == "1" {
                return  CGSize(width: (productListCollectionView.bounds.width/2) - 3.0, height: 230)
            } else {
                return CGSize(width: (productListCollectionView.bounds.width/2) - 3.0 , height: 154)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == chipsCollectionView {
            return 6
        } else {
            return 0
        }
    }
    
    //Space betweeen cells vertically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productListCollectionView {
            return 4
        } else {
            return 0
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    //        if collectionView == productListCollectionView {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        if collectionView == productListCollectionView {
    //            print("Start index :- \(sourceIndexPath.item)")
    //            print("End index :- \(destinationIndexPath.item)")
    //            if !searching {
    //                let tmp = viewModel.arrayOfListItems[sourceIndexPath.item]
    //                viewModel.arrayOfListItems[sourceIndexPath.item] = viewModel.arrayOfListItems[destinationIndexPath.item]
    //                viewModel.arrayOfListItems[destinationIndexPath.item] = tmp
    //                productListCollectionView.reloadData()
    //            } else {
    //                let tmp = viewModel.arrayOfFilteredData[sourceIndexPath.item]
    //                viewModel.arrayOfFilteredData[sourceIndexPath.item] = viewModel.arrayOfFilteredData[destinationIndexPath.item]
    //                viewModel.arrayOfFilteredData[destinationIndexPath.item] = tmp
    //                productListCollectionView.reloadData()
    //            }
    //        }
    //    }
}

//MARK: -> Delegete-Success
extension ProductsViewController: DelegeteMyListSuccess {
    func updateArray(quantity: String,itemCode:String, index: Int) {
        if quantity != "" {
            self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfListItems
            self.viewModel.arrayOfNewListItems[index].quantity = quantity
            self.viewModel.arrayOfNewListItems[index].item_code = itemCode
            self.viewModel.arrayOfListItems = self.viewModel.arrayOfNewListItems
            
            if let index = viewModel.arrayOfItemsToSend.firstIndex(where: {$0.item_code == itemCode}) {
                viewModel.arrayOfItemsToSend[index].quantity = quantity
            }
            
            self.updateTotaPrice()
            self.sendRequestUpdateUserProductList()
        }
    }
    
    //    func sendRequestUpdateUserProductList() {
    //        var arrUpdatedPriceQuantity = [[String:Any]]()
    //        self.viewModel.arrayOfNewListItems.removeAll()
    //        print(self.viewModel.arrayOfNewListItems)
    //        print(self.viewModel.arrayOfListItems)
    //        self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfListItems
    //
    //        for i in 0..<viewModel.arrayOfNewListItems.count {
    //            var strQuantityy = ""
    //            var strItemNamee = ""
    //            var strItemCodee = ""
    //            if let strQuantity = self.viewModel.arrayOfNewListItems[i].quantity {
    //                strQuantityy = strQuantity
    //            }
    //            if let strItemName = self.viewModel.arrayOfNewListItems[i].item_name {
    //                strItemNamee = strItemName
    //            }
    //            if let strItemCode  = self.viewModel.arrayOfNewListItems[i].item_code {
    //                strItemCodee = strItemCode
    //            }
    //            var dictData = [String:Any]()
    //            dictData["quantity"] = strQuantityy
    //            dictData["item_name"] = strItemNamee
    //            dictData["item_code"] = strItemCodee
    //            arrUpdatedPriceQuantity.insert(dictData, at: i)
    //        }
    //        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
    //        var dictParam = [String:Any]()
    //        var appType = ""
    //        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
    //        if (customerType == "Wholesale Customer") {
    //            appType = KeyConstants.app_TypeDual
    //        } else {
    //            appType = KeyConstants.app_TypeRetailer
    //        }
    //
    //        var  orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
    //
    //        if(orderFlag == "") {
    //            orderFlag = "0"
    //        }
    //
    //        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
    //        dictParam = [
    //            UpdateProductList.type.rawValue:KeyConstants.appType ,
    //            UpdateProductList.app_type.rawValue:appType,
    //            UpdateProductList.client_code.rawValue:clientCode ,
    //            UpdateProductList.user_code.rawValue:userID ,
    //            UpdateProductList.orderFlag.rawValue:orderFlag,
    //            UpdateProductList.cartItems.rawValue:arrUpdatedPriceQuantity,
    //            UpdateProductList.device_id.rawValue:Constants.deviceId,
    //        ]
    //        print(dictParam)
    //        //self.isChipSelelect = !isChipSelelect //use for enable selected Chip
    //        self.updateProductList(with: dictParam)
    //    }
    
    func sendRequestUpdateUserProductList() {
        var arrUpdatedPriceQuantity = [[String:Any]]()
        var localStorageItems = LocalStorage.getItemsData()
        localStorageItems += LocalStorage.getShowItData()
        
//        var uniqueItem = [GetItemsData]()
//
//        for localStorageItem in localStorageItems {
//            if let itemCode = localStorageItem.item_code {
//                // Check if the uniqueItemCodes array already contains this item code
//                let isUnique = !uniqueItem.contains { $0.item_code == itemCode }
//                
//                if isUnique {
//                    uniqueItem.append(localStorageItem)
//                }
//            }
//        }
//
//        print(uniqueItem)
//        
//        for item in uniqueItem {
//            if let lastIndex = localStorageItems.lastIndex(where: { $0.item_code == item.item_code && $0.priority == 1 }) {
//                localStorageItems[lastIndex].priority = 1
//            }
//        }
        
        for i in 0..<localStorageItems.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            var strmeasureQty = ""
            var stroriginQty = ""
            var strIsMeasure = 0
            var strPriority = 1
            var strId = 0
            if let strQuantity = localStorageItems[i].quantity {
                strQuantityy = strQuantity
            }
            if let strItemName = localStorageItems[i].item_name {
                strItemNamee = strItemName
            }
            if let strItemCode  = localStorageItems[i].item_code {
                strItemCodee = strItemCode
            }
            if let measureQty  = localStorageItems[i].measureQty {
                strmeasureQty = measureQty
            }
            
            if let originQty  = localStorageItems[i].originQty {
                stroriginQty = originQty
            }
            
            if let isMeasure  = localStorageItems[i].is_meas_box {
                strIsMeasure = isMeasure
            }
            
            if let priority  = localStorageItems[i].priority {
                strPriority = priority
            }
            
            if let id  = localStorageItems[i].id {
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
        self.updateProductList(with: dictParam)
    }
    
    func isSuceess(success: Bool, text: String, index: Int, measureQty:String){
        //        if success {
        //            if text != "" {
        //                guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
        //                self.updateArray(quantity: text, itemCode: itemCode, index: index)
        //            } else {
        //                guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
        //                self.updateArray(quantity: "0", itemCode: itemCode, index: index)
        //            }
        //        }
        
        if success {
            self.isChangedQuantity = true
            if searching {
                //                if text != "" && text != "0" && text != "0.00"  {
                guard let itemCode = self.viewModel.arrayOfFilteredData[index].item_code else { return }
                self.viewModel.arrayOfListItems[index].originQty = text
                self.viewModel.arrayOfListItems[index].measureQty = measureQty
                self.viewModel.arrayOfListItems[index].priority = 1
                Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfFilteredData[index])
                //                } else {
                //                    guard let itemCode = self.viewModel.arrayOfFilteredData[index].item_code else { return }
                //                    self.viewModel.arrayOfListItems[index].quantity = "0"
                //                }
            } else {
                // if text != "" && text != "0" && text != "0.00"  {
                guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
                self.viewModel.arrayOfListItems[index].originQty = text
                self.viewModel.arrayOfListItems[index].measureQty = measureQty
                self.viewModel.arrayOfListItems[index].priority = 1
                
                Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfListItems[index])
                //                } else {
                //                    guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
                //                    self.viewModel.arrayOfListItems[index].quantity = "0"
                //                }
            }
        }
        self.updateTotaPrice()
        self.productListCollectionView.reloadData()
        // self.tableView.reloadData()
    }
}

//MARK: -> Searching
//extension ProductsViewController {
//    func searchText(with searchText: String?) {
//        self.searchUserText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let arrayOfGarageData = viewModel.arrayOfListItems
//        self.viewModel.arrayOfFilteredData = arrayOfGarageData.filter {
//            return $0.item_name!.localizedCaseInsensitiveContains(searchText ?? "")
//        }
//
//        if searchText?.count == 0 {
//            searching = false
//            refreshEnable = false
//            if showList == 1 {
//                configureBackgroundList(with: Icons.noDataFound, message: "", count: arrayOfGarageData.count)
//            } else {
//                configureBackground(with: Icons.noDataFound, message: "", count: arrayOfGarageData.count)
//            }
//        } else {
//            searching = true
//            refreshEnable = true
//            //            configureBackground(with: Icons.noDataFound, message:  "", count: self.viewModel.arrayOfFilteredData.count)
//            if showList == 1  {
//                configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfFilteredData.count)
//            } else {
//                configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfFilteredData.count)
//            }
//        }
//        productListCollectionView.reloadData()
//        tableView.reloadData()
//    }
//}


//MARK: -> UITextFieldDelegate
extension ProductsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != searchTextField {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            // make sure the result is under 16 characters
            return updatedText.count <= 4
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextField {
            self.searchUserText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if self.searchUserText.count > 0 {
                if viewModel.arrayOfChips.count > 0 {
                    if let index = viewModel.arrayOfChips.firstIndex(where: {$0.isSlected == true}) {
                        viewModel.arrayOfChips[index].isSlected = false
                    }
                }
                print("TextField did end editing method called\(textField.text!)")
                self.categoryId = ""
                self.page = 1
                getItems()
                
            }
        }
    }
}

//MARK: - View-Model Ineraction
extension ProductsViewController {
    //MARK: - METHOD TO HIT GET ITEMS API
    func getItems() {
        if let searchText = UserDefaults.standard.value(forKey:UserDefaultsKeys.CommonSearchText) as? String {
            self.searchUserText = searchText
            self.searchTextField.text = searchText
            self.categoryId = ""
            self.cancelButtonContainerView.isHidden = false
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.CommonSearchText)
            for i in 0..<self.viewModel.arrayOfChips.count {
                self.viewModel.arrayOfChips[i].isSlected = false
            }
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
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        if self.categoryId != "" {
            dictParam = [
                GetUserItems.client_code.rawValue:KeyConstants.clientCode ,
                GetUserItems.category_id.rawValue: self.categoryId,
                GetUserItems.search.rawValue: self.searchUserText,
                GetUserItems.device_id.rawValue:Constants.deviceId,
//                GetUserItems.app_type.rawValue:KeyConstants.app_Type,
//                GetUserItems.type.rawValue:KeyConstants.appType,
                GetUserItems.user_code.rawValue:userID,
                GetUserItems.page.rawValue:self.page,
                GetUserItems.acm_code.rawValue: self.acmCode
            ]
        } else {
            dictParam = [
                GetUserItems.client_code.rawValue:KeyConstants.clientCode ,
                GetUserItems.search.rawValue: self.searchUserText,
                GetUserItems.device_id.rawValue:Constants.deviceId,
//                GetUserItems.app_type.rawValue:KeyConstants.app_Type,
//                GetUserItems.type.rawValue:KeyConstants.appType,
                GetUserItems.user_code.rawValue:userID,
                GetUserItems.page.rawValue:self.page,
                GetUserItems.acm_code.rawValue: self.acmCode
            ]
        }
        
        if self.searchUserText == "" {
            //use to remove key if not have value
            if let index = dictParam.index(forKey: "search") {
                dictParam.remove(at: index)
            }
        }
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isComeFromBanner)
        print(JSON(dictParam))
        self.searchItemByCategory(page: self.page, with: dictParam)
    }
    
    private func searchItemByCategory(page: Int,with param: [String: Any]) {
        self.view.endEditing(true)
        //viewModel.arrayOfListItems.removeAll()
        viewModel.searchItemByCategory(page: page, with: param) { [self] result in
            switch result {
            case .success(let getUserItemsData):
                if let getUserItemsData = getUserItemsData {
                    guard let status = getUserItemsData.status else { return }
                    if let arrItemsData = getUserItemsData.data?.data, let showAllItem = getUserItemsData.showAllItem {
                        self.showAllItem = showAllItem
                        UserDefaults.standard.set(showAllItem, forKey: "displayAllItem")
                        self.pagination(with: arrItemsData)
                        //self.viewModel.arrayOfListItems = arrItemsData
                    } else {
                        if self.page == 1 {
                            viewModel.arrayOfListItems = []
                        }
                    }
                    
                    if let bannerLists = getUserItemsData.data?.bannerLists {
                        self.viewModel.arrayOfBanner = bannerLists
                    }
                    
                   
//                    if let multiList = getUserItemsData.data?.multi_items {
//                        if !multiList.isEmpty {
//                            LocalStorage.clearMultiItemsData()
//                            LocalStorage.saveMultiData(data: multiList)
//                        }
//                    }
                    
                    if let showAppBanner = getUserItemsData.showAppBanner {
                        UserDefaults.standard.set(showAppBanner, forKey:UserDefaultsKeys.showAppBanner)
                    }
                    
                    if let showItemInGrid = getUserItemsData.showItemInGridView {
                        UserDefaults.standard.set(showItemInGrid, forKey:UserDefaultsKeys.showItemInGrid)
                    }
                    //self.addProductButton.isHidden = true
                    //labelAddProduct.isHidden = true
                    if (status == 1) {
                        bannerContainerViewHeightConst.constant = Constants.bannerHeight
                        if let showImage = getUserItemsData.show_image {
                            self.viewModel.showImage = showImage
                        }
                        if let customerType = getUserItemsData.customer_type {
                            UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                            if(customerType == "Wholesale Customer") {
                                //self.viewModel.strDeliveryPickUP = "Delivery"
                                //self.hideDeliveryOrPickUpView()
                            } else {
                                if let showPickUp = getUserItemsData.show_pickup {
                                    //if(showPickUp == 0) {
                                    //        self.hideDeliveryOrPickUpView()
                                    //        } else {
                                    //            self.showDeliveryOrPickUpView()
                                    //}
                                }
                            }
                        } else {
                            if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                                if(customerType as? String  == "Wholesale Customer") {
                                    self.viewModel.strDeliveryPickUP = "Delivery"
                                    //self.hideDeliveryOrPickUpView()
                                }
                            }
                        }
                        
                        if let showPrice  = getUserItemsData.showPrice {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                            if(showPrice == "0"){
                                //self.totalPriceView.isHidden = true
                                //self.totalPriceLabel.isHidden = true
                                //self.totalPriceViewHeightConst.constant = 0
                                //self.totalPriceButton.isHidden = true
                            } else {
                                //self.totalPriceView.isHidden = false
                                //self.searchView.totalAmountLabel.isHidden = false
                                // self.totalPriceViewHeightConst.constant = 30
                                // self.totalPriceButton.isHidden = false
                                //self.totalPriceLabel.isHidden = false
                            }
                            self.viewModel.showPrice = showPrice
                        }
                        
                        if(self.viewModel.showPrice  != "0") {
                            self.updateTotaPrice()
                        }
                        
                        if let currencySymbol = getUserItemsData.currency_symbol {
                            if(currencySymbol != ""){
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            } else {
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            }
                        }
                        
                        //                                                if let categoryExist = getUserItemsData.category_exists {
                        //                                                    if(categoryExist == 0) {
                        //                                                        viewModel.isCategoryExist = false
                        //                                                        self.hideCollectionView()
                        //                                                        if let arrItemsData = getUserItemsData.data
                        //                                                        {
                        //                                                            self.viewModel.arrItemsData  = arrItemsData
                        //                                                        }
                        //                                                    } else {
                        //                                                        viewModel.isCategoryExist = true
                        //                                                        self.showCollectionView()
                        //                                                        if let arrItemsWithCategoryData = getUserItemsData.data_with_category {
                        //                                                            self.viewModel.arrItemsCategoryData = arrItemsWithCategoryData
                        //                                                            if let arrItemsDataNew = self.viewModel.arrItemsCategoryData[0].data {
                        //                                                                self.viewModel.arrItemsData = arrItemsDataNew
                        //                                                            }
                        //                                                            productListCollectionView.reloadData()
                        //                                                        }
                        //                                                    }
                        //                                                }
                        
                        if let minOrderValue = getUserItemsData.min_order_value {
                            self.viewModel.strMinOrderValue = minOrderValue
                        }
                        //
                        if let showPO  = getUserItemsData.show_po {
                            if(showPO == 0) {
                                self.viewModel.showPO = 0
                                //self.hidePoNumber()
                            } else {
                                self.viewModel.showPO = 1
                                //self.showPONumber()
                            }
                        }
                        //                                                if let routeAssigned = getUserItemsData.route_assigned {
                        //                                                    if(routeAssigned == 0) {
                        //                                                        viewModel.isRouteAssigned = false
                        //                                                        self.routeNotAssigned()
                        //                                                    } else {
                        //                                                        viewModel.isRouteAssigned = true
                        //                                                        self.routeAssigned()
                        //                                                    }
                        //                                                }
                        //
                        //                                                if let arrDeliveryAvailableDates =  getUserItemsData.delivery_available_dates {
                        //                                                    self.viewModel.deliveryAvailabelDates = arrDeliveryAvailableDates
                        //                                                }
                        //                                                if let deliveryAvailableDays = getUserItemsData.delivery_available {
                        //                                                    self.viewModel.deliveryAvailableDays = deliveryAvailableDays
                        //
                        //                                                }
                        if(self.viewModel.showPrice != "0") {
                            self.updateTotaPrice()
                        }
                        
                        if let deliveryCharge = getUserItemsData.delivery_charge {
                            self.viewModel.strDeliveryCharge = deliveryCharge
                        }
                        
                        if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                            if(customerType as! String == "Retail Customer") {
                                if getUserItemsData.show_pickup != nil {
                                    //                                    if(showPickUp == 1) {
                                    //                                        if let radioButtonSelected = UserDefaults.standard.object(forKey:UserDefaultsKeys.selectedRadioButtonType)
                                    //                                        {
                                    //                                            if(radioButtonSelected as? String == "delivery") {
                                    //                                                self.selectDeliveryButton()
                                    //                                            }
                                    //                                            if(radioButtonSelected as? String == "pickup") {
                                    //                                                self.selectPickUpButton()
                                    //                                            }
                                    //
                                    //                                        } else {
                                    //                                            self.selectDeliveryButton()
                                    //                                        }
                                    //                                    }
                                }
                            }
                        }
                        
                        //                        if let contactNo = getUserItemsData.pickup_contact {
                        //                            self.viewModel.strContactNumber = contactNo
                        //                            deliveryMessageLabel.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                        //                            let strFullMessage = "Please call" + " " + self.viewModel.strContactNumber + " " + "to arrange a pick up time"
                        //                            deliveryMessageLabel.text = strFullMessage
                        //                        }
                        //self.itemsTableView.dataSource = self
                        //self.itemsTableView.delegate = self
                        //self.itemsTableView.reloadData()
                    } else if(status == 2){
                        guard let messge = getUserItemsData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                    else {
                        //self.itemsTableView.isHidden = true
                        //self.addProductButton.isHidden = false
                        //self.labelAddProduct.isHidden = false
                        //self.chipsCollectionView.isHidden = true
                        //self.viewOutlet.isHidden = true
                    }
                }
                
                DispatchQueue.main.async {
                    self.banerTableView.reloadData()
                    self.chipsCollectionView.reloadData()
                    self.outletsTableView.reloadData()
                }
                
                if self.showList == 0 {
                    configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                } else {
                    configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                }
            case .failure(let error):
                if(error == .networkError) {
                    self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                } else  {
                    self.presentPopUpVC(message: serverNotResponding, title: "")
                }
                if self.showList == 0 {
                    configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                } else {
                    configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                }
            case .none:
                break
            }
        }
        if self.showList == 0 {
            self.tableView.reloadData()
            //self.tableView.setContentOffset(.zero, animated: false)
        } else {
            self.productListCollectionView.reloadData()
            //self.productListCollectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    //MARK: -> getCategories
    private func getCategories() {
        let appName = UserDefaults.standard.object(forKey:UserDefaultsKeys.AppName) as? String ?? ""
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        // appNameLabel.text = appName
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        let dictParam = [
            GetCategoryData.type.rawValue:KeyConstants.appType ,
            GetCategoryData.user_code.rawValue:userID,
            GetCategoryData.client_code.rawValue:KeyConstants.clientCode,
            GetCategoryData.device_id.rawValue:Constants.deviceId,
        ]
        
        self.getCategories(with: dictParam)
    }
    
    //MARK: -> getItecmsById
    private func getItecmsById(categoryID: String) {
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        var appType = ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
//            GetItemsByCategoryData.type.rawValue:KeyConstants.appType ,
//            GetItemsByCategoryData.app_type.rawValue:appType,
            GetItemsByCategoryData.client_code.rawValue:KeyConstants.clientCode ,
            GetItemsByCategoryData.user_code.rawValue:userID ,
            GetItemsByCategoryData.category_id.rawValue:categoryID,
            GetItemsByCategoryData.device_id.rawValue:Constants.deviceId
        ]
        self.getCategoriesbyId(with: dictParam)
    }
    
    //Get-Categories
    private func getCategories(with param: [String: Any]) {
        viewModel.getCategories(with: param, view: self.view) { result in
            switch result {
            case .success(let categoryData):
                if let categoryData = categoryData {
                    guard let status = categoryData.status  else { return }
                    if (status == 1) {
                        if let arrCategoryData = categoryData.categories {
                            print(arrCategoryData)
                            self.viewModel.arrayOfChips = arrCategoryData
                            print(self.viewModel.arrayOfChips)
                            self.chipsCollectionView.reloadData()
                            if self.viewModel.arrayOfChips.count > 0 {
                                if let allCategoryId = UserDefaults.standard.value(forKey: "AllCategoryId") as? Int {
                                    if let index = self.viewModel.arrayOfChips.firstIndex(where: {$0.id == "\(allCategoryId)"}) {
                                        self.selectedChipIndex = index
                                        self.viewModel.arrayOfChips[index].isSlected = true
                                        self.categoryId = self.viewModel.arrayOfChips[index].id ?? ""
                                        self.chipsCollectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .left, animated: false)
                                    }
                                    UserDefaults.standard.removeObject(forKey: "AllCategoryId")
                                } else {
                                    if let isComeFromBanner = UserDefaults.standard.object(forKey: UserDefaultsKeys.isComeFromBanner) as? Bool {
                                        if !(isComeFromBanner) {
                                            if let ind = self.selectedChipIndex {
                                                self.viewModel.arrayOfChips[ind].isSlected = true
                                                self.categoryId = self.viewModel.arrayOfChips[ind].id ?? ""
                                            }
                                        } else {
                                            if let index = self.viewModel.arrayOfChips.firstIndex(where: {$0.id == self.categoryId}) {
                                                self.selectedChipIndex = index
                                                self.viewModel.arrayOfChips[index].isSlected = true
                                                let indexPath = IndexPath(item: index, section: 0)
                                                // Scroll to the item with or without animation
                                                self.chipsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                                            }
                                        }
                                    } else {
                                        if let ind = self.selectedChipIndex {
                                            self.viewModel.arrayOfChips[ind].isSlected = true
                                            self.categoryId = self.viewModel.arrayOfChips[ind].id ?? ""
                                        }
                                    }
                                    
                                }
                                self.getItems()
                            }
                        }
                    } else if(status == 2) {
                        if self.showList == 0 {
                            self.configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                        } else {
                            self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                        }
                        DispatchQueue.main.async {
                            guard let messge = categoryData.message else {return}
                            self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                        }
                    }
                    else {
                        if self.showList == 0 {
                            self.configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                        } else {
                            self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                        }
                        guard let messge = categoryData.message else {return}
                        DispatchQueue.main.async {
                            self.presentPopUpVC(message:messge,title: "")
                        }
                    }
                }
                
            case .failure(let error):
                if self.showList == 0 {
                    self.configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                } else {
                    self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                }
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
    
    //Add-Product
    func addProduct(param:[String:Any], itemCode: String) {
        viewModel.addProduct(with: param, view: self.view) { result in
            switch result{
            case .success(let addProductData):
                if let addProductData = addProductData {
                    guard let status = addProductData.status  else { return }
                    if (status == 1) {
                        if self.searching {
                            if let index = self.viewModel.arrayOfFilteredData.firstIndex(where: { $0.item_code == itemCode }) {
                                if self.viewModel.arrayOfFilteredData[index].inMyList == 0 {
                                    self.viewModel.arrayOfFilteredData[index].inMyList = 1
                                } else {
                                    self.viewModel.arrayOfFilteredData[index].inMyList = 0
                                }
                            }
                        } else {
                            if let index = self.viewModel.arrayOfListItems.firstIndex(where: { $0.item_code == itemCode }) {
                                if self.viewModel.arrayOfListItems[index].inMyList == 0 {
                                    self.viewModel.arrayOfListItems[index].inMyList = 1
                                } else {
                                    self.viewModel.arrayOfListItems[index].inMyList = 0
                                }
                            }
                        }
                        if let isShowList = UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int {
                            if isShowList == 0 {
                                self.tableView.reloadData()
                            } else {
                                self.productListCollectionView.reloadData()
                            }
                        }
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
    
    //Get-Categories
    private func getCategoriesbyId(with param: [String: Any]) {
        viewModel.searchItemsByCategory(with: param, view: self.view) { result in
            switch result {
            case .success(let searchItemsByCategoryData):
                if let searchItemsByCategoryData = searchItemsByCategoryData {
                    guard let status = searchItemsByCategoryData.status  else { return }
                    if (status == 1) {
                        if let arrCategoryData = searchItemsByCategoryData.data, let displayAllItems = searchItemsByCategoryData.displayAllItems {
                            print(displayAllItems)
                            UserDefaults.standard.set(displayAllItems, forKey: "displayAllItem")
                            self.viewModel.arrayOfListItems = arrCategoryData
                            print(self.viewModel.arrayOfListItems)
                            self.tableView.reloadData()
                            self.productListCollectionView.reloadData()
                        }  }else if(status == 2 ) {
                            guard let messge = searchItemsByCategoryData.message else {return}
                            self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                        }
                    else {
                        //self.viewModel.arrItemsCategoryData.removeAll()
                        // self.itemsTableView.reloadData()
                        guard let messge = searchItemsByCategoryData.message else {return}
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
    
    //MARK: - Update-Product-List
    private func updateProductList(with param: [String: Any]) {
        viewModel.updateProductList(with: param, view: self.view) { result in
            switch result{
            case .success(let deletedItemData):
                print(deletedItemData)
                // self.productListCollectionView.reloadData()
                if let status = deletedItemData?.status {
                    if status == 1 {
                        //if self.viewModel.isComingFromReviewOrderButton {
                        //self.goToConfirmPaymentPage()
                        //}
                        if self.viewModel.isClickCart {
                            self.goToConfirmPaymentPage()
                            self.isClickCart = false
                        }
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
    
    //Delete-Item
    func deleteItem(with param: [String: Any],itemCode:String) {
        viewModel.deleteItem (with: param, view: self.view,itemCode: itemCode) { result in
            switch result{
            case .success(let deletedItemData):
                if let deletedItemData = deletedItemData {
                    guard let status = deletedItemData.status else { return }
                    if (status == 1) {
                        if self.searching {
                            if let index = self.viewModel.arrayOfFilteredData.firstIndex(where: { $0.item_code == itemCode }) {
                                if self.viewModel.arrayOfFilteredData[index].inMyList == 0 {
                                    self.viewModel.arrayOfFilteredData[index].inMyList = 1
                                } else {
                                    self.viewModel.arrayOfFilteredData[index].inMyList = 0
                                }
                            }
                        } else {
                            if let index = self.viewModel.arrayOfListItems.firstIndex(where: { $0.item_code == itemCode }) {
                                if self.viewModel.arrayOfListItems[index].inMyList == 0 {
                                    self.viewModel.arrayOfListItems[index].inMyList = 1
                                } else {
                                    self.viewModel.arrayOfListItems[index].inMyList = 0
                                }
                            }
                        }
                        
                        if let isShowList = UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int {
                            if isShowList == 0 {
                                self.tableView.reloadData()
                            } else {
                                self.productListCollectionView.reloadData()
                            }
                        }
                        
                        guard let messge = deletedItemData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
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
                self.page = 1
                self.searchTextField.text = ""
                self.searchUserText = ""
                self.categoryId = ""
                self.selectedChipIndex = 0
                self.getCategories()
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
extension ProductsViewController:PopUpDelegate {
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
            let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            self.navigationController?.pushViewController(tbc, animated: false)
        } else {
            let tbc = storyboard?.instantiateViewController(withIdentifier: "RegionViewController") as! RegionViewController
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
}

//MARK: -> DelegeteSuccess
extension ProductsViewController: DelegeteSuccess {
    func isSuceess(success: Bool, text: String) {
        self.updateTotaPrice()
        if !(isClickProductDetails) {
            if showList == 0 {
                self.tableView.reloadData()
            } else {
                productListCollectionView.reloadData()
            }
        }
    }
}

//MARK: -> DelegeteBannerImageClick
extension ProductsViewController: DelegeteBannerImageClick {
    func didClickBannerImage(ind: Int) {
        let linkItemType = self.viewModel.arrayOfBanner[ind].linkItemType
        if linkItemType == "category" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isComeFromBanner)
            vc.categoryId = self.viewModel.arrayOfBanner[ind].linkItemTypeID ?? ""
            //vc.selectedTabIndex = 2
            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "specials" {
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "SpecialsViewController") as! SpecialsViewController
//            vc.tabType = self.tabType
//            //vc.selectedTabIndex = 3
//            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "product" {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.tabType = self.tabType
            vc.isComingFromBannerClick = true
            self.isClickProductDetails = true
            vc.itemCode = self.viewModel.arrayOfBanner[ind].linkItemTypeID ?? ""
            vc.showImage = self.viewModel.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//MARK: -> Paging
extension ProductsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.arrayOfListItems.count - 1 == indexPath.row && viewModel.arrayOfListItems.count % self.recordPerPage == 0 {
                if hasMoreItems && !self.isLoading {
                    self.isLoading = true
                    self.getItems()
                }
                print("Prefatch")
            }
        }
    }
    //
    //    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    //
    //    }
    //
}


//MARK: -> Paging
extension ProductsViewController: UITableViewDataSourcePrefetching {
    func pagination(with data: [GetItemsData]) {
        if data.count > 0 {
            if(self.page == 1) {
                self.viewModel.arrayOfListItems = data
                self.count = self.viewModel.arrayOfListItems.count
            } else {
                self.viewModel.arrayOfListItems = self.viewModel.arrayOfListItems + data
                self.count = self.viewModel.arrayOfListItems.count
            }
            self.page += 1
            self.hasMoreItems = true
            print("count", count)
            print("length", self.viewModel.arrayOfListItems.count)
            self.isLoading = false
        } else {
            self.hasMoreItems = false
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if viewModel.arrayOfListItems.count - 1 == indexPath.row && viewModel.arrayOfListItems.count % self.recordPerPage == 0 {
                if hasMoreItems && !self.isLoading {
                    self.isLoading = true
                    self.getItems()
                }
                print("Prefatch")
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
}

//MARK: -> UIScrollViewDelegate
extension ProductsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != chipsCollectionView {
            print("page", page)
            
            if viewModel.arrayOfListItems.count > 4 || viewModel.arrayOfFilteredData.count > 4 {
                let isShowBanner = UserDefaults.standard.integer(forKey: UserDefaultsKeys.showAppBanner)
                print(isShowBanner)
                
                if isShowBanner == 1 && !self.viewModel.arrayOfBanner.isEmpty {
                    if scrollView.contentOffset.y > 0 {
                        scrollContent = Int(scrollView.contentOffset.y)
                        bannerContainerViewHeightConst.constant = 0
                        banerTableView.isHidden = true
                    } else {
                        scrollContent = 0
                        bannerContainerViewHeightConst.constant = Constants.bannerHeight
                        banerTableView.isHidden = false
                        
                        // Reload only the first row with animation
                        self.banerTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    }
                }
            } else {
                
            }
        }
    }
}

//MARK: -> Handle-Background-State
extension ProductsViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        if presentingViewController is ProductsViewController {
            print("handleAppDidBecomeActive")
            self.categoryId = ""
            //self.selectedChipIndex = 0
            self.page = 1
            addObserver()
            getCategories()
            updateTotaPrice()
            if self.showList == 0 {
                self.tableView.setContentOffset(.zero, animated: false)
            } else {
                self.productListCollectionView.setContentOffset(.zero, animated: false)
            }
            
            if searchTextField.text != "" {
                cancelButtonContainerView.isHidden = false
                self.selectedChipIndex = nil
            } else {
                cancelButtonContainerView.isHidden = true
            }
        }
    }
}

//MARK: -> Notification Center
extension ProductsViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("tabChange"), object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        UserDefaults.standard.setValue(true, forKey: "tabChange")
    }
    
    @objc private func notificationReceived(notification: NSNotification) {
        print("tab changed ****")
        self.isClickProductDetails = false
        self.updateTotaPrice()
        if self.showList == 1 {
            productListCollectionView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
}

//MARK: - snake Bar
extension ProductsViewController {
    func showSnakeBar(message: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ToastViewController") as! ToastViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.message = snakeBarMsg
        self.present(vc, animated: false, completion: nil)
    }
}

//MARK: - DelegateUpdateQuantity
extension ProductsViewController: DelegateUpdateQuantity {
    func didUpdateQuantity(updatedQuantity: String, inMyList: Int, indexPath: IndexPath) {
        self.viewModel.arrayOfListItems[indexPath.row].quantity = updatedQuantity
        self.viewModel.arrayOfListItems[indexPath.row].inMyList = inMyList
        if showList == 0 {
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            productListCollectionView.reloadItems(at: [indexPath])
        }
    }
    
}

extension ProductsViewController: RefreshDelegate {
    func refresh() {
        updateTotaPrice()
        configureCartImage()
        self.tableView.reloadData()
        self.productListCollectionView.reloadData()
        self.sendRequestUpdateUserProductList()
    }
}
