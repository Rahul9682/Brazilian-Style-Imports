//  MyListViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import SwiftyJSON

import Toast_Swift

class MyListViewController: UIViewController, CalendarDelegate {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    
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
//    @IBOutlet weak var outLetContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var outLetHeader: UILabel!
    
    //MARK: - FooterView Properties
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var viewDeliveryPickUp: UIView!
    @IBOutlet var viewDeliveryPickUpHeightConst: NSLayoutConstraint!
    @IBOutlet var deliveryButton: UIButton!
    @IBOutlet var pickUpButton: UIButton!
    @IBOutlet var deliveryMessageLabel: UILabel!
    @IBOutlet var deliveryMessgeHeightConst: NSLayoutConstraint!
    @IBOutlet var viewDelivery: UIView!
    @IBOutlet var viewDeliveryHeightConst: NSLayoutConstraint!
    @IBOutlet var deliveryLabel: RegularLabelSize14!
    @IBOutlet var deliveryDateLabel: RegularLabelSize14!
    @IBOutlet var calendarImage: UIImageView!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet var viewShowPickupHeightConst: NSLayoutConstraint!
    @IBOutlet var poNumberTopConst: NSLayoutConstraint!
    @IBOutlet var poNumberHeightConst: NSLayoutConstraint!
    @IBOutlet var reviewYourOrderButton: UIButton!
    @IBOutlet var poNumberTextField: UITextField!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerTableView: UITableView!
    private var isAnimationInProgress = false
    var tabType: TabType = .myList
    @IBOutlet weak var bannerContainerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var switchButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginUserNameLabel: UILabel!
    
    
    //MARK: -> Properties
    var isSpecialSelected = false
    var viewModel = MyListViewModel()
    var searching = false
    var refreshEnable = true
    var background: BackgroundView?
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var showImage: String = ""
    var showPrice  = ""
    //var strResetValue = ""
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var isChipSelelect = false
    var selectedChipIndex: Int = 0
    var strDeliveryPickUP = ""
    var myListReviewOrderCollectionViewCell: MyListReviewOrderCollectionViewCell?
    var reviewOrderTableViewCell: MyListReviewOrderTableViewCell?
    var showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
    var showList = UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int
    //var showList = 0
    var isChangedQuantity: Bool = false
    var isShowOutletsTable: Bool = false
    var alert:UIAlertController!
    var snakeBarMsg = "My List"
    var isClickProductDetails: Bool = false
    var displayAllItem: Bool = false
    var acmCode  = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID)
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
       // totalPriceLabel.text = "Total $0.00"
        //productListCollectionView.tableFooterView = viewFooter
        // productListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        let layout = productListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0) // Add bottom inset of 20
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        reviewYourOrderButton.layer.cornerRadius = 8
        self.strDeliveryPickUP = "Delivery"
        configureUI()
        registerCell()
       //configureGridOrList(isShowList: 0)
       configureGridOrList(isShowList: UserDefaults.standard.value(forKey:UserDefaultsKeys.showItemInGrid) as? Int ?? 0)
        viewModel.isComingFromReviewOrderButton = false
        UserDefaults.standard.set("delivery", forKey:UserDefaultsKeys.selectedRadioButtonType)
        // tableView.tableFooterView = viewFooter
        //        viewModel.isResetList = UserDefaults.standard.bool(forKey: "isResetList")
        //        if(viewModel.isResetList) {
        //            self.showPopUpToResetList()
        //            viewModel.isResetList = false
        //            UserDefaults.standard.set(false, forKey: "isResetList")
        //        } else {
        //            self.callGetItems()
        //        }
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
            outLetHeader.isHidden = false
          
        } else {
            if let acmCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID) {
                self.configureOutletsView(noOfOutltes: 1)
            } else {
                outletsContainerView.isHidden = true
                outletsContainerWidthConst.constant = 0
               outletsContainerTrailingConst.constant = 0
               
            }
            outLetHeader.isHidden = true
        }
       // self.configureOutletsView(noOfOutltes: 1)
        self.toggleOutletsListView(isShow: isShowOutletsTable)
        self.refreshEnable = true
        addObserver()
        if(viewModel.isResetList) {
            self.showPopUpToResetList()
            viewModel.isResetList = false
            UserDefaults.standard.set(false, forKey: "isResetList")
        } else {
            self.callGetItems()
        }
        didEnterBackgroundObserver()
        if !(isClickProductDetails){
            self.showSnakeBar(message: self.snakeBarMsg)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        viewModel.isMenuButtonSelected = true
        searching = false
        refreshEnable = false
        self.searchTextField.text = ""
        //DispatchQueue.global().async {
//        if self.isChangedQuantity {
//        DispatchQueue.main.async {
//            self.sendRequestUpdateUserProductList()
//        }
//        }
        DispatchQueue.main.async {
            self.sendRequestUpdateUserProductList()
        }
        self.isChangedQuantity = false
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isResetList)
    }

    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabbarView.bounds
        tabBar?.configureTabUI(with: .myList)
        
        tabBar?.didClickHomeButton = {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickMyList = {
            //            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
            //            self.navigationController?.pushViewController(vc, animated: false)
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
    
    //MARK: - METHOD TO SHOW POP UP TO RESET LIST
    func showPopUpToResetList() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupResetListViewController") as? PopupResetListViewController
            vc?.strMessage = "Clicking confirm will re-arrange items in the My Product List in alphabetical order."
            vc?.delegate = self
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    //MARK: - POPUP RESET LIST DELEGATE
    func showPopUP(didTapCancel: Bool, didTapConfirm: Bool) {
        if(didTapCancel){
            viewModel.strResetValue = "0"
        } else if(didTapConfirm){
            viewModel.strResetValue = "1"
        }
        self.callGetItems()
    }
    
    override func viewDidLayoutSubviews() {
        commentTextView.textColor = UIColor.black
        commentTextView.backgroundColor = UIColor.white
        commentTextView.placeholder = "Comments:";
        commentTextView.placeholderColor = UIColor.gray
        commentTextView.layer.cornerRadius = 5;
        commentTextView.layer.borderWidth=1;
        commentTextView.layer.borderColor = UIColor.MyTheme.reviewOrderColor.cgColor
        viewDelivery.layer.cornerRadius = 5;
        viewDelivery.layer.borderWidth=1;
        viewDelivery.layer.borderColor = UIColor.MyTheme.reviewOrderColor.cgColor
        poNumberTextField.textColor = UIColor.black
        poNumberTextField.backgroundColor = UIColor.white
        poNumberTextField.attributedPlaceholder = NSAttributedString(string: "PO Number:",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        poNumberTextField.layer.cornerRadius = 5
        poNumberTextField.layer.borderWidth = 1
        poNumberTextField.layer.borderColor = UIColor.MyTheme.reviewOrderColor.cgColor
        deliveryLabel.text = "Delivery:"
        deliveryLabel.textColor = UIColor.gray
    }
    
    //MARK: -> Helpers
    private func configureUI() {
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        self.showImage = "0"
        viewModel.strResetValue = "0"
        showPrice = "0"
        self.arrSuppliers = db.readData()
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        //tableView.dragDelegate = self
        //var tableViewLongPress = UILongPressGestureRecognizer (target: self, action:#selector(self.tableViewLongPressGestureRecognized(_:)))
        //tableView.addGestureRecognizer(tableViewLongPress)
        
        /****/
        //        productListCollectionView.delegate = self
        //        productListCollectionView.dataSource = self
        //        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        //        productListCollectionView.addGestureRecognizer(longPressGesture)
        //        tableView.delegate = self
        //        tableView.dataSource = self
        //        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        //        longPress.minimumPressDuration = 0.2 // optional
        //        tableView.addGestureRecognizer(longPress)
        bannerTableView.delegate = self
        bannerTableView.dataSource = self
        searchContainerView.layer.cornerRadius = Radius.searchViewRadius
        searchContainerView.layer.borderWidth = Radius.searchViewborderWidth
        searchContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH MY LIST",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
        
        outletsContainerView.layer.cornerRadius = Radius.searchViewRadius
        outletsContainerView.layer.borderWidth = Radius.searchViewborderWidth
        outletsContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        
        outletsTableView.delegate = self
        outletsTableView.dataSource = self
    }
    
    private func registerCell() {
        chipsCollectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
        productListCollectionView.register(UINib(nibName: "SpecialProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpecialProductsCollectionViewCell")
        tableView.register(UINib(nibName: "ItemTableViewCellWithImage", bundle: nil), forCellReuseIdentifier: "ItemTableViewCellWithImage")
        tableView.register(UINib(nibName: "MyListReviewOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyListReviewOrderTableViewCell")
        productListCollectionView.register(UINib(nibName: "MyListReviewOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyListReviewOrderCollectionViewCell")
        productListCollectionView.register(UINib(nibName: "ButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ButtonCollectionViewCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        bannerTableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
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
    
    //    @objc func tableViewLongPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
    //        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
    //        let state = longPress.state
    //        let locationInView = longPress.location(in: tableView)
    //        let indexPath = tableView.indexPathForRow(at: locationInView)
    //
    //        struct Path {
    //            static var initialIndexPath : IndexPath? = nil
    //        }
    //
    //        switch state {
    //        case UIGestureRecognizer.State.began:
    //            if indexPath != nil {
    //                let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell?
    //                UIView.animate(withDuration: 0.25, animations: { () -> Void in
    //                    cell?.alpha = 0.0
    //                }, completion: { (finished) -> Void in
    //                    if finished {
    //                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
    //                            cell?.alpha = 1
    //                        })
    //                    } else {
    //                        cell?.isHidden = true
    //                    }
    //                })
    //            }
    //        case UIGestureRecognizer.State.changed:
    //            if searching {
    //                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
    //                    viewModel.arrayOfFilteredData.insert(viewModel.arrayOfFilteredData.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
    //                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
    //                    Path.initialIndexPath = indexPath
    //                }
    //            } else {
    //                if viewModel.arrayOfListItems.count > 0 {
    //                    if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
    //                        viewModel.arrayOfListItems.insert(viewModel.arrayOfListItems.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
    //                        tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
    //                        Path.initialIndexPath = indexPath
    //                    }
    //                }
    //            }
    //        default:
    //            print("default:")
    //        }
    //    }
    
    // MARK: - TableView- Cell reorder / long press
    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        if searching {
            if sender.state == .began {
                if indexPath != nil {
                    if   let senderItemID = self.viewModel.arrayOfFilteredData[indexPath!.row].special_item_id {
                        if(senderItemID == 1){
                            return
                        }
                    }
                    if let specialTitle = viewModel.arrayOfFilteredData[indexPath!.row].special_title {
                        if(specialTitle == 1){
                            return
                        }
                    }
                    
                    viewModel.dragInitialIndexPath = indexPath
                    let cell = tableView.cellForRow(at: indexPath!)
                    viewModel.dragCellSnapshot = snapshotOfCell(inputView: cell!)
                    var center = cell?.center
                    viewModel.dragCellSnapshot?.center = center!
                    viewModel.dragCellSnapshot?.alpha = 0.0
                    tableView.addSubview(viewModel.dragCellSnapshot!)
                    
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        center?.y = locationInView.y
                        self.viewModel.dragCellSnapshot?.center = center!
                        self.viewModel.dragCellSnapshot?.transform = (self.viewModel.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                        self.viewModel.dragCellSnapshot?.alpha = 0.99
                        cell?.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell?.isHidden = true
                        }
                    })
                }
            } else if sender.state == .changed && viewModel.dragInitialIndexPath != nil {
                var center = viewModel.dragCellSnapshot?.center
                center?.y = locationInView.y
                viewModel.dragCellSnapshot?.center = center!
                
                // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
                if indexPath != nil && indexPath != viewModel.dragInitialIndexPath {
                    // update your data model
                    let dataToMove = self.viewModel.arrayOfListItems[viewModel.dragInitialIndexPath!.row]
                    viewModel.arrayOfListItems.remove(at: viewModel.dragInitialIndexPath!.row)
                    viewModel.arrayOfListItems.insert(dataToMove, at: indexPath!.row)
                    //arrItemsData.swapAt(indexPath!.row, dragInitialIndexPath!.row)
                    print(viewModel.arrayOfListItems)
                    tableView.moveRow(at: viewModel.dragInitialIndexPath!, to: indexPath!)
                    viewModel.dragInitialIndexPath = indexPath
                    //
                }
            } else if sender.state == .ended && viewModel.dragInitialIndexPath != nil {
                let cell = tableView.cellForRow(at: viewModel.dragInitialIndexPath!)
                cell?.isHidden = false
                cell?.alpha = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.viewModel.dragCellSnapshot?.center = (cell?.center)!
                    self.viewModel.dragCellSnapshot?.transform = CGAffineTransform.identity
                    self.viewModel.dragCellSnapshot?.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        self.viewModel.dragInitialIndexPath = nil
                        self.viewModel.dragCellSnapshot?.removeFromSuperview()
                        self.viewModel.dragCellSnapshot = nil
                        UserDefaults.standard.set("1", forKey:UserDefaultsKeys.orderFlag)
                        self.viewModel.isLongPressGestureRecogized = true
                        print(self.viewModel.arrayOfListItems)
                        print(self.viewModel.arrLongPressGesture)
                        self.tableView.reloadData()
                        self.RearrangingOrder()
                        return
                    }
                })
            }
        } else {
            if sender.state == .began {
                if indexPath != nil {
                    if   let senderItemID = self.viewModel.arrayOfListItems[indexPath!.row].special_item_id {
                        if(senderItemID == 1){
                            return
                        }
                    }
                    if let specialTitle = viewModel.arrayOfListItems[indexPath!.row].special_title {
                        if(specialTitle == 1){
                            return
                        }
                    }
                    
                    viewModel.dragInitialIndexPath = indexPath
                    let cell = tableView.cellForRow(at: indexPath!)
                    viewModel.dragCellSnapshot = snapshotOfCell(inputView: cell!)
                    var center = cell?.center
                    viewModel.dragCellSnapshot?.center = center!
                    viewModel.dragCellSnapshot?.alpha = 0.0
                    tableView.addSubview(viewModel.dragCellSnapshot!)
                    
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        center?.y = locationInView.y
                        self.viewModel.dragCellSnapshot?.center = center!
                        self.viewModel.dragCellSnapshot?.transform = (self.viewModel.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                        self.viewModel.dragCellSnapshot?.alpha = 0.99
                        cell?.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell?.isHidden = true
                        }
                    })
                }
            } else if sender.state == .changed && viewModel.dragInitialIndexPath != nil {
                var center = viewModel.dragCellSnapshot?.center
                center?.y = locationInView.y
                viewModel.dragCellSnapshot?.center = center!
                
                // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
                if indexPath != nil && indexPath != viewModel.dragInitialIndexPath {
                    // update your data model
                    let dataToMove = self.viewModel.arrayOfListItems[viewModel.dragInitialIndexPath!.row]
                    viewModel.arrayOfListItems.remove(at: viewModel.dragInitialIndexPath!.row)
                    viewModel.arrayOfListItems.insert(dataToMove, at: indexPath!.row)
                    //arrItemsData.swapAt(indexPath!.row, dragInitialIndexPath!.row)
                    print(viewModel.arrayOfListItems)
                    tableView.moveRow(at: viewModel.dragInitialIndexPath!, to: indexPath!)
                    viewModel.dragInitialIndexPath = indexPath
                    //
                }
            } else if sender.state == .ended && viewModel.dragInitialIndexPath != nil {
                let cell = tableView.cellForRow(at: viewModel.dragInitialIndexPath!)
                cell?.isHidden = false
                cell?.alpha = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.viewModel.dragCellSnapshot?.center = (cell?.center)!
                    self.viewModel.dragCellSnapshot?.transform = CGAffineTransform.identity
                    self.viewModel.dragCellSnapshot?.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        self.viewModel.dragInitialIndexPath = nil
                        self.viewModel.dragCellSnapshot?.removeFromSuperview()
                        self.viewModel.dragCellSnapshot = nil
                        UserDefaults.standard.set("1", forKey:UserDefaultsKeys.orderFlag)
                        self.viewModel.isLongPressGestureRecogized = true
                        print(self.viewModel.arrayOfListItems)
                        print(self.viewModel.arrLongPressGesture)
                        self.tableView.reloadData()
                        self.RearrangingOrder()
                        return
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
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
//        if self.showPrice != "0" {
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
    
    func configureGridOrList(isShowList: Int) {
        searching = false
        productListCollectionView.reloadData()
        tableView.reloadData()
        if isShowList == 1 {
            tableView.isHidden = true
            productListCollectionView.isHidden = false
            productListCollectionView.delegate = self
            productListCollectionView.dataSource = self
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
            productListCollectionView.addGestureRecognizer(longPressGesture)
        } else {
            tableView.isHidden = false
            productListCollectionView.isHidden = true
            tableView.delegate = self
            tableView.dataSource = self
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
            longPress.minimumPressDuration = 0.2 // optional
            tableView.addGestureRecognizer(longPress)
        }
        productListCollectionView.reloadData()
        tableView.reloadData()
    }
    
    //MARK: - Show Calendar Method
    func showCalendar() {
        DispatchQueue.main.async {
            let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
            calendarVC?.deliveryAvailableDays = self.viewModel.deliveryAvailableDays
            calendarVC?.deliveryAvailabelDates = self.viewModel.deliveryAvailabelDates
            calendarVC?.delegate = self
            calendarVC?.view.backgroundColor = UIColor.clear
            calendarVC?.modalPresentationStyle = .overCurrentContext
            self.present(calendarVC!, animated: false, completion: nil)
        }
    }
    //MARK: - Calendar Delegate
    func passDate(strDate: String) {
        if(strDate != "") {
            // deliveryDateLabel.text = strDate
        }
    }
    
    //MARK: - METHOD TO HIDE DELIVERY OR PICK UP BUTTON
    func hideDeliveryOrPickUpView() {
        if showList == 1 {
            viewModel.isPickUpDeliveryAvailable = false
            myListReviewOrderCollectionViewCell?.viewDeliveryPickUp.isHidden = true
            //viewShowPickupHeightConst.constant = 0
            myListReviewOrderCollectionViewCell?.deliveryMessagelabel.isHidden = true
            // deliveryMessgeHeightConst.constant = 0
            myListReviewOrderCollectionViewCell?.viewDelivery.isHidden = false
            //viewDeliveryHeightConst.constant = 45
        } else {
            viewModel.isPickUpDeliveryAvailable = false
            viewDeliveryPickUp.isHidden = true
            viewShowPickupHeightConst.constant = 0
            deliveryMessageLabel.isHidden = true
            deliveryMessgeHeightConst.constant = 0
            viewDelivery.isHidden = false
            viewDeliveryHeightConst.constant = 34
        }
    }
    
    //MARK: - METHOD TO SHOW DELIVERY OR PICK UP BUTTON
    func showDeliveryOrPickUpView() {
        if showList == 1 { //Grid
            viewModel.isPickUpDeliveryAvailable = true
            myListReviewOrderCollectionViewCell?.viewDeliveryPickUp.isHidden = false
            // viewShowPickupHeightConst.constant = 50
            myListReviewOrderCollectionViewCell?.viewDelivery.isHidden = false
            myListReviewOrderCollectionViewCell?.deliveryMessagelabel.isHidden = true
            //deliveryMessgeHeightConst.constant = 21
            myListReviewOrderCollectionViewCell?.deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            // viewDeliveryHeightConst.constant = 45
        } else { //List
            viewModel.isPickUpDeliveryAvailable = true
            viewDeliveryPickUp.isHidden = false
            viewShowPickupHeightConst.constant = 50
            viewDelivery.isHidden = false
            deliveryMessageLabel.isHidden = true
            deliveryMessgeHeightConst.constant = 21
            reviewOrderTableViewCell?.deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            viewDeliveryHeightConst.constant = 45
        }
    }
    
    //MARK: - METHOD TO HIDE PO NUMBER
    func hidePoNumber() {
        if showList == 1 { //Grid
            myListReviewOrderCollectionViewCell?.poNumberTextFiedl.isHidden = true
            //poNumberTopConst.constant = 0
            //poNumberHeightConst.constant = 0
        } else {
            poNumberTextField.isHidden = true
        }
    }
    
    //MARK: - METHOD TO SHOW PO NUMBER
    func showPONumber() {
        if showList == 1 { //Grid
            myListReviewOrderCollectionViewCell?.poNumberTextFiedl.isHidden = false
            //poNumberTopConst.constant = 10
            //poNumberHeightConst.constant = 45
        } else {
            poNumberTextField.isHidden = false
        }
    }
    
    //MARK: - METHOD TO SELECT DELIVERY BUTTON
    func selectDeliveryButton() {
        if showList == 1 {
            self.strDeliveryPickUP = "Delivery"
            // viewShowPickupHeightConst.constant = 50
            //viewDeliveryHeightConst.constant = 45
            myListReviewOrderCollectionViewCell?.viewDelivery.isHidden = false
            //deliveryMessgeHeightConst.constant = 0
            myListReviewOrderCollectionViewCell?.deliveryMessagelabel.isHidden = true
            myListReviewOrderCollectionViewCell?.deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            myListReviewOrderCollectionViewCell?.pickUpbutton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            UserDefaults.standard.set("delivery", forKey:UserDefaultsKeys.selectedRadioButtonType)
        } else {
            self.strDeliveryPickUP = "Delivery"
            viewShowPickupHeightConst.constant = 50
            viewDeliveryHeightConst.constant = 45
            viewDelivery.isHidden = false
            deliveryMessgeHeightConst.constant = 0
            deliveryMessageLabel.isHidden = true
            deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            pickUpButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            UserDefaults.standard.set("delivery", forKey:UserDefaultsKeys.selectedRadioButtonType)
        }
    }
    
    //MARK: - METHOD TO SELECT PICKUP BUTTON
    func selectPickUpButton() {
        if showList == 1 {
            self.strDeliveryPickUP = "Pickup"
            //viewShowPickupHeightConst.constant = 75
            // viewDeliveryHeightConst.constant = 0
            myListReviewOrderCollectionViewCell?.viewDelivery.isHidden = true
            // deliveryMessgeHeightConst.constant = 21
            myListReviewOrderCollectionViewCell?.deliveryMessagelabel.isHidden = false
            myListReviewOrderCollectionViewCell?.deliveryButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            myListReviewOrderCollectionViewCell?.pickUpbutton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            UserDefaults.standard.set("pickup", forKey:UserDefaultsKeys.selectedRadioButtonType)
        } else {
            self.strDeliveryPickUP = "Pickup"
            viewShowPickupHeightConst.constant = 75
            viewDeliveryHeightConst.constant = 0
            viewDelivery.isHidden = true
            deliveryMessgeHeightConst.constant = 21
            deliveryMessageLabel.isHidden = false
            deliveryButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            pickUpButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            UserDefaults.standard.set("pickup", forKey:UserDefaultsKeys.selectedRadioButtonType)
        }
    }
    
    //MARK: - METHOD WHEN ROUTE NOT ASSIGNED
    func routeNotAssigned() {
        if showList == 1 {
            myListReviewOrderCollectionViewCell?.calendarImageCiew.isHidden = true
            myListReviewOrderCollectionViewCell?.deliveryDateLabel.text = "Next Delivery"
            myListReviewOrderCollectionViewCell?.selectDateButton.isEnabled = false
        } else {//List
            calendarImage.isHidden = true
            deliveryDateLabel.text = "Next Delivery"
            selectDateButton.isEnabled = false
        }
    }
    
    //MARK: - METHOD FOR HIDING COLLECTION VIEW
    //    func hideCollectionView() {
    //        categoryCollectionViewHeightConst.constant = 0
    //        categoryCollectionView.isHidden = true
    //    }
    
    //MARK: - METHOD FOR HIDING COLLECTION VIEW
    //    func showCollectionView() {
    //        categoryCollectionViewHeightConst.constant = 50
    //        categoryCollectionView.isHidden = false
    //    }
    
    //MARK: - METHOD WHEN ROUTE WAS ASSIGNED
    func routeAssigned() {
        if showList == 1 {
            myListReviewOrderCollectionViewCell?.calendarImageCiew.isHidden = false
            if let strSelectedDate = UserDefaults.standard.object(forKey:UserDefaultsKeys.SelectedDate)        {
                myListReviewOrderCollectionViewCell?.deliveryDateLabel.text = strSelectedDate as? String
            }
            myListReviewOrderCollectionViewCell?.selectDateButton.isEnabled = true
        } else {//List
            calendarImage.isHidden = false
            if let strSelectedDate = UserDefaults.standard.object(forKey:UserDefaultsKeys.SelectedDate)        {
                deliveryDateLabel.text = strSelectedDate as? String
            }
            selectDateButton.isEnabled = true
        }
    }
    
    //MARK: - VALIDATE ORDER METHOD
    func validation()->Bool {
        if(self.viewModel.arrItemsDataToSend.count == 0) {
            self.presentPopUpVC(message:validateQuantities,title: "")
            return false
        } else {
            if(self.strDeliveryPickUP == "Delivery") {
                if(viewModel.isRouteAssigned){
                    if showList == 1 {
                        if(self.myListReviewOrderCollectionViewCell?.deliveryDateLabel.text == "Next Delivery" || self.myListReviewOrderCollectionViewCell?.deliveryDateLabel.text == "") {
                            self.presentPopUpVC(message: validateDeliveryDate,title: "")
                            return false
                        }
                    } else { //List
                        if(self.deliveryDateLabel.text == "Next Delivery" || self.deliveryDateLabel.text == "") {
                            self.presentPopUpVC(message: validateDeliveryDate,title: "")
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    //MARK: - REVIEW YOUR ORDER
    private func reviewYourOrder() {
        let localStorageArray = LocalStorage.getItemsData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let confirmPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
        
        //        if showList == 1 {
        //            self.viewModel.arrItemsDataToSend.removeAll()
        //            var comment = ""
        //            var poNumber = ""
        //            if  let commentt = myListReviewOrderCollectionViewCell?.commentTextView.text {
        //                comment = commentt
        //            }
        //            if let poNumberr = self.myListReviewOrderCollectionViewCell?.poNumberTextFiedl.text {
        //                poNumber = poNumberr
        //            }
        //
        //            UserDefaults.standard.set(poNumber, forKey:UserDefaultsKeys.ponumber)
        //            UserDefaults.standard.set(comment, forKey:UserDefaultsKeys.comment)
        //            UserDefaults.standard.set(myListReviewOrderCollectionViewCell?.deliveryDateLabel.text, forKey:UserDefaultsKeys.SelectedDate)
        //            if(viewModel.isCategoryExist){
        //                if   let arrItemsDatta = self.viewModel.arrItemsCategoryData[0].data {
        //                    for i in 0..<arrItemsDatta.count {
        //                        if  let quantity = arrItemsDatta[i].quantity {
        //                            guard let floatQuantity = Float(quantity) else { return  }
        //                            if(quantity != "" && quantity != "0" && floatQuantity > 0.0 && quantity != "0.00") {
        //                                self.viewModel.arrItemsDataToSend.append(arrItemsDatta[i])
        //                            }
        //                        }
        //                    }
        //                }
        //            } else {
        //                for i in 0..<self.viewModel.arrayOfListItems.count {
        //                    if  let quantity = self.viewModel.arrayOfListItems[i].quantity {
        //                        guard let floatQuantity = Float(quantity) else { return  }
        //                        if(quantity != "" && quantity != "0" && floatQuantity > 0 && quantity != "0.00") {
        //                            self.viewModel.arrItemsDataToSend.append(self.viewModel.arrayOfListItems[i])
        //                        }
        //                    }
        //                }
        //            }
        //
        //            if(validation()) {
        //                viewModel.isComingFromReviewOrderButton = true
        //                self.sendRequestUpdateUserProductList()
        //            }
        //        } else { //List
        //            self.viewModel.arrItemsDataToSend.removeAll()
        //            var comment = ""
        //            var poNumber = ""
        //            if  let commentt = commentTextView.text {
        //                comment = commentt
        //            }
        //            if let poNumberr = self.poNumberTextField.text {
        //                poNumber = poNumberr
        //            }
        //
        //            UserDefaults.standard.set(poNumber, forKey:UserDefaultsKeys.ponumber)
        //            UserDefaults.standard.set(comment, forKey:UserDefaultsKeys.comment)
        //            UserDefaults.standard.set(deliveryDateLabel.text, forKey:UserDefaultsKeys.SelectedDate)
        //            if(viewModel.isCategoryExist){
        //                if   let arrItemsDatta = self.viewModel.arrItemsCategoryData[0].data {
        //                    for i in 0..<arrItemsDatta.count {
        //                        if  let quantity = arrItemsDatta[i].quantity {
        //                            guard let floatQuantity = Float(quantity) else { return  }
        //                            if(quantity != "" && quantity != "0" && floatQuantity > 0.0 && quantity != "0.00") {
        //                                self.viewModel.arrItemsDataToSend.append(arrItemsDatta[i])
        //                            }
        //                        }
        //                    }
        //                }
        //            } else {
        //                for i in 0..<self.viewModel.arrayOfListItems.count {
        //                    if  let quantity = self.viewModel.arrayOfListItems[i].quantity {
        //                        guard let floatQuantity = Float(quantity) else { return  }
        //                        if(quantity != "" && quantity != "0" && floatQuantity > 0 && quantity != "0.00") {
        //                            self.viewModel.arrItemsDataToSend.append(self.viewModel.arrayOfListItems[i])
        //                        }
        //                    }
        //                }
        //            }
        //            if(validation()) {
        //                viewModel.isComingFromReviewOrderButton = true
        //                self.sendRequestUpdateUserProductList()
        //            }
        //        }
    }
    
    //MARK: - GO TO CONFIRM PAYMENT PAGE
    func goToConfirmPaymentPage() {
        // let nav :HamburguerNavigationController = self.mainNavigationController()
        let confirmPaymentVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
        confirmPaymentVC.tabType = self.tabType
        //nav.setViewControllers([confirmPaymentVC], animated: false)
        confirmPaymentVC.arrSelectedItems = self.viewModel.arrItemsDataToSend
        confirmPaymentVC.showPrice = self.showPrice
        confirmPaymentVC.strFeature = "Yes"
        confirmPaymentVC.strPoNumber = myListReviewOrderCollectionViewCell?.poNumberTextFiedl.text ?? ""
        confirmPaymentVC.strShowImage = self.showImage
        confirmPaymentVC.strComment = myListReviewOrderCollectionViewCell?.commentTextView.text ?? ""
        confirmPaymentVC.strDeliveryDate = myListReviewOrderCollectionViewCell?.deliveryDateLabel.text ?? ""
        confirmPaymentVC.strContactNo = self.viewModel.strContactNumber
        confirmPaymentVC.strPickUpDelivery = self.strDeliveryPickUP
        confirmPaymentVC.strMinOrderValue = self.viewModel.strMinOrderValue
        confirmPaymentVC.strDeliveryCharge = self.viewModel.strDeliveryCharge
        confirmPaymentVC.floatTotalPrice = self.viewModel.floatTotalPrice
        confirmPaymentVC.showPO = self.viewModel.showPO
        self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
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
                self.productListCollectionView.isHidden = true
                self.backgroundView.addSubview(self.background!)
            } else {
                self.productListCollectionView.isHidden = false
                if self.background != nil {
                    self.background?.removeFromSuperview()
                }
                self.chipsCollectionView.reloadData()
                self.productListCollectionView.reloadData()
            }
            
            if refreshEnable {
                background?.refreshButton.isHidden = true//false
            } else {
                background?.refreshButton.isHidden = true
            }
            
            self.background?.didClickRefreshButton = {
                if(self.viewModel.isResetList) {
                    self.showPopUpToResetList()
                    self.viewModel.isResetList = false
                    UserDefaults.standard.set(false, forKey: "isResetList")
                } else {
                    self.callGetItems()
                }
            }
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
                //self.tableView.reloadData()
                self.tableView.reloadData()
                //self.productListCollectionView.reloadData()
            }
            if refreshEnable {
                background?.refreshButton.isHidden = true//false
            } else {
                background?.refreshButton.isHidden = true
            }
            self.background?.didClickRefreshButton = {
                if(self.viewModel.isResetList) {
                    self.showPopUpToResetList()
                    self.viewModel.isResetList = false
                    UserDefaults.standard.set(false, forKey: "isResetList")
                } else {
                    self.callGetItems()
                }
            }
        }
    }
    
    //MARK: - LOGOUT METHOD
    func logOut() {
        Constants.clearUserDefaults()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        db.deleteByClientCode(strClientCode: clientCode)
        self.arrSuppliers = db.readData()
        if(arrSuppliers.count != 0){
            
            if let strAppName = arrSuppliers[0]["supplier_name"]{
                //// UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
            }
            if let strClientCode = arrSuppliers[0]["client_code"]{
                UserDefaults.standard.set(strClientCode, forKey: "ClientCode")
            }
            if let strUserLoginId = arrSuppliers[0]["user_code"]{
                UserDefaults.standard.set(strUserLoginId, forKey:UserDefaultsKeys.UserLoginID)
            }
            if let strUserLoginId = arrSuppliers[0]["user_code"]{
                UserDefaults.standard.set(strUserLoginId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            }
            
            UserDefaults.standard.set("produceList", forKey: "isCheckView")
            let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            navigationController?.pushViewController(tbc, animated: false)
        }
        else {
            let tbc = storyboard?.instantiateViewController(withIdentifier: "RegionViewController") as! RegionViewController
            navigationController?.pushViewController(tbc, animated: false)
        }
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
    
    
    @IBAction func pickUpButton(_ sender: UIButton) {
        self.selectPickUpButton()
    }
    
    @IBAction func deliveryButton(_ sender: UIButton) {
        self.selectDeliveryButton()
    }
    
    @IBAction func reviewYourOrderButton(_ sender: UIButton) {
        self.reviewYourOrder()
    }
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        self.selectDeliveryButton()
    }
    
    @IBAction func didChangesearchText(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print(text)
        self.searchText(with: text)
        if text == "" {
            print("12365")
        }
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
}

//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
extension MyListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == chipsCollectionView {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == chipsCollectionView {
            return viewModel.arrayOfChips.count
        } else {
            if section == 0 {
                if !searching {
                    return viewModel.arrayOfListItems.count
                } else {
                    return viewModel.arrayOfFilteredData.count
                }
            } else {
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == chipsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipsCollectionViewCell", for: indexPath) as! ChipsCollectionViewCell
            cell.configureUI()
            //if !isChipSelelect {
            viewModel.arrayOfChips[selectedChipIndex].isSlected = true
            //}
            cell.configureMyListData(chipsData: viewModel.arrayOfChips[indexPath.row])
            if indexPath.row == viewModel.arrayOfChips.count - 1 {
                cell.rightSeparatorView.backgroundColor = UIColor.white
            } else {
                cell.rightSeparatorView.backgroundColor = UIColor.black
            }
            return  cell
        } else {
            if indexPath.section == 0 {
                let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialProductsCollectionViewCell", for: indexPath) as! SpecialProductsCollectionViewCell
                // cellB.quantityTextField.delegate = self
                cellB.delegeteMyListSuccess = self
                //cellB.configureUI()
                cellB.quantityTextField.tag = indexPath.row
                cellB.measureTextField.tag = indexPath.row
                var count = 0
                if searching {
                    cellB.configureMyListData(data:viewModel.arrayOfFilteredData[indexPath.row], showImage: self.showImage, showPrice: self.showPrice, displayAll: self.displayAllItem)
                    count = Constants.getCount(itemCode: self.viewModel.arrayOfFilteredData[indexPath.row].item_code)
                   
                } else {
                    cellB.configureMyListData(data:viewModel.arrayOfListItems[indexPath.row], showImage: self.showImage, showPrice: self.showPrice, displayAll: self.displayAllItem)
                    count = Constants.getCount(itemCode: self.viewModel.arrayOfListItems[indexPath.row].item_code)
                }
                
                if count != 0 {
                    cellB.multiItemCount.isHidden = false
                    cellB.multiItemCount.text = ("\(count)")
                    
                } else {
                    cellB.multiItemCount.text = ""
                    cellB.multiItemCount.isHidden = true
                }
                
                cellB.didClickAdd = {
                    if self.searching {
                        if let itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code {
                            self.deleteItemWithId(itemCode: itemCode, index: indexPath.row, isSearching: self.searching)
                        }
                        self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfFilteredData.count)
                    } else {
                        if let itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code {
                            self.deleteItemWithId(itemCode: itemCode, index: indexPath.row, isSearching: self.searching)
                        }
                        self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                    }
                    self.productListCollectionView.reloadData()
                }
                
                cellB.didClickProduct = {
                    if indexPath.section == 0 {
                        let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                        vc.delegeteSuccess = self
                        vc.showImage = self.showImage
                        if self.searching {
                            vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                        } else {
                            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                        }
                        vc.tabType = self.tabType
                        self.isClickProductDetails = true
                        self.navigationController?.pushViewController(vc, animated: false)
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
                            self.productListCollectionView.reloadData()
                            
                        }
                    }
                }
    
                cellB.didClickProductNameLabel = {
                    print("Click Product Name Label")
                    if indexPath.section == 0 {
                        let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                        vc.delegeteSuccess = self
                        vc.showImage = self.showImage
                        if self.searching {
                            vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                        } else {
                            vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                        }
                        vc.tabType = self.tabType
                        self.isClickProductDetails = true
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
                
                return cellB
            } else {
                //                myListReviewOrderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyListReviewOrderCollectionViewCell", for: indexPath) as! MyListReviewOrderCollectionViewCell
                //                myListReviewOrderCollectionViewCell?.didClickPickupButton = {
                //                    print("didClickPickupButton")
                //                    self.selectPickUpButton()
                //                }
                //                myListReviewOrderCollectionViewCell?.didClickDeliveryButton = {
                //                    print("didClickDeliveryButton")
                self.selectDeliveryButton()
                //                }
                //
                //                myListReviewOrderCollectionViewCell?.didClickDeliveryDate = {
                //                    print("didClickDeliveryDate")
                //                    self.showCalendar()
                //                }
                //
                //                myListReviewOrderCollectionViewCell?.didClickReviewOrderButton = {
                //                    print("didClickReviewOrderButton")
                //                    self.reviewYourOrder()
                //                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
                cell.reviewOrderClick = {
                    self.reviewYourOrder()
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == chipsCollectionView {
            
            self.isChipSelelect = true
            for i in 0...viewModel.arrayOfChips.count - 1 {
                viewModel.arrayOfChips[i].isSlected = false
            }
            viewModel.arrayOfChips[indexPath.row].isSlected = true
            self.selectedChipIndex = indexPath.row
            if var arrData = viewModel.arrItemsCategoryData[indexPath.row].data {
                if let WeeklyItemIndex = arrData.firstIndex(where: {$0.item_code == ""}) {
                    arrData.remove(at: WeeklyItemIndex)
                }
                self.viewModel.arrayOfListItems = arrData
                self.viewModel.arrayOfNewListItems = arrData
            }
            
            self.searching = false
            searchTextField.text = ""
            //collectionView.reloadData()
            chipsCollectionView.reloadData()
            //productListCollectionView.reloadData()
            if self.showList == 0 {
                configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems .count)
            } else {
                configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems .count)
            }
        } else {
//            if indexPath.section == 0 {
//                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//                vc.delegeteSuccess = self
//                if searching {
//                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
//                } else {
//                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
//                }
//                vc.tabType = self.tabType
//                self.navigationController?.pushViewController(vc, animated: false)
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if collectionView == productListCollectionView {
            if indexPath.section == 0 {
                if   let senderItemID = self.viewModel.arrayOfListItems[indexPath.row].special_item_id {
                    if(senderItemID == 1){
                        return false
                    }
                }
                if let specialTitle = viewModel.arrayOfListItems[indexPath.row].special_title {
                    if(specialTitle == 1){
                        return false
                    }
                }
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == productListCollectionView {
            if sourceIndexPath.section == 0 {
                print("Start index :- \(sourceIndexPath.item)")
                print("End index :- \(destinationIndexPath.item)")
                if !searching {
                    let tmp = viewModel.arrayOfListItems[sourceIndexPath.item]
                    viewModel.arrayOfListItems[sourceIndexPath.item] = viewModel.arrayOfListItems[destinationIndexPath.item]
                    viewModel.arrayOfListItems[destinationIndexPath.item] = tmp
                    //productListCollectionView.reloadData()
                } else {
                    let tmp = viewModel.arrayOfFilteredData[sourceIndexPath.item]
                    viewModel.arrayOfFilteredData[sourceIndexPath.item] = viewModel.arrayOfFilteredData[destinationIndexPath.item]
                    viewModel.arrayOfFilteredData[destinationIndexPath.item] = tmp
                }
                UserDefaults.standard.setValue("1", forKey:UserDefaultsKeys.orderFlag)
                ///sendRequestReArrangeUserProductList()
                RearrangingOrder()
                productListCollectionView.reloadData()
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == chipsCollectionView {
            if let categoryName = self.viewModel.arrayOfChips[indexPath.row].category_title {
                let label = UILabel(frame: CGRect.zero)
                label.text = categoryName
                label.sizeToFit()
                return CGSize(width:label.frame.size.width,height:14)
            }
            return CGSize(width:120,height:14)
        } else {
            if indexPath.section == 0 {
                if showImage == "1" {
                    print(productListCollectionView.bounds.width/2)
                    return CGSize(width: (productListCollectionView.bounds.width/2) - 3 , height: 230)
                } else {
                    return CGSize(width: (productListCollectionView.bounds.width/2) - 3 , height: 154)
                }
            } else {
                //Review order Cell
                //return CGSize(width:productListCollectionView.bounds.width - 4, height: 280)
                return CGSize(width:productListCollectionView.bounds.width, height: 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == chipsCollectionView {
            return 0
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
}

//MARK: ->  UITableViewDelegate, UITableViewDataSource
extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bannerTableView {
            return 1
        } else if tableView == outletsTableView {
            return LocalStorage.getOutletsListData().count
        } else {
            if searching {
                return viewModel.arrayOfFilteredData.count
            } else {
                return viewModel.arrayOfListItems.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bannerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
            cell.delegeteBannerImageClick = self
            cell.configureUI()
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
            cell.configureShowImage(isShow: self.showImage)
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            cell.quantityTextField.isHidden = false
            cell.inactiveLabel.isHidden = true
            cell.inactiveLabel.text = ""
            cell.quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
            cell.delegeteMyListSuccess = self
            cell.addContainerView.isHidden = true
            cell.addIcon.image = Icons.remove
            cell.quantityTextField.tag = indexPath.row
            cell.measureTexfield.tag = indexPath.row
            cell.addIconWIdthConstraint.constant = 0
          
            
            
            cell.addItemButton = {
                print("add")
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
            
            cell.didClickShowList = {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowListPopUpViewController") as? ShowListPopUpViewController
             
                if self.searching {
                    nextVC?.itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code ?? ""
                } else {
                    nextVC?.itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
                }
                nextVC?.refreshDelegate = self
                nextVC?.modalPresentationStyle = .overFullScreen
                self.present(nextVC!, animated: false, completion: nil)
            }
            
            cell.didClickProduct = {
                print("ind is", indexPath.row)
                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                vc.delegeteSuccess = self
                vc.showImage = self.showImage
                if self.searching {
                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                } else {
                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                }
                vc.tabType = self.tabType
                self.isClickProductDetails = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
            cell.didClickProductNameLabel = {
                print("Click Product Name Label")
                let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                vc.delegeteSuccess = self
                vc.showImage = self.showImage
                if self.searching {
                    vc.productDetails = self.viewModel.arrayOfFilteredData[indexPath.row]
                } else {
                    vc.productDetails = self.viewModel.arrayOfListItems[indexPath.row]
                }
                vc.tabType = self.tabType
                self.isClickProductDetails = true
                self.navigationController?.pushViewController(vc, animated: false)
            }

            if searching {
                if self.viewModel.arrayOfFilteredData.count > 0 {
                    cell.didChangeQuantity = { value in
                        cell.index = indexPath.row
                        let itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code ?? ""
                        if(value == "") {
                            // self.updateQuantityInArray(quantity: "0", sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                            //
                        } else  {
                            //self.updateQuantityInArray(quantity: value , sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                        }
                    }
                    cell.quantityTextField.isEnabled  = true
                    
                    if let strUOM = viewModel.arrayOfFilteredData[indexPath.row].uom {
                        cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    }
                    
                    var multiCount = "\(Constants.getCount(itemCode: self.viewModel.arrayOfFilteredData[indexPath.row].item_code ?? ""))"
                    if multiCount != "0" {
                        cell.measureLabel.text = multiCount
                    } else {
                        cell.measureLabel.text = ""
                    }
                    
                    if let itemName = viewModel.arrayOfFilteredData[indexPath.row].item_name {
                        if(itemName != "")
                        {
                            cell.itemLabel.text = itemName
                        }
                    }
                    
                    
                    
                    
//                    if let thumbImage = viewModel.arrayOfFilteredData[indexPath.row].thumb_image {
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
                    
                    //                if let strQuantity = viewModel.arrayOfFilteredData[indexPath.row].quantity {
                    if let strQuantity = Constants.getPrice(itemCode: viewModel.arrayOfFilteredData[indexPath.row].quantity) {
                        if (strQuantity == "0.00" || strQuantity == "0") {
                            if (viewModel.arrayOfFilteredData[indexPath.row].special_title == 1)
                            {
                                cell.quantityTextField.text = "";
                            }
                            else
                            {
                                if (viewModel.arrayOfFilteredData[indexPath.row].uom?.count == 0)
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
                        cell.quantityTextField.text = ""
                    }
                    
                    if let specialItemID = viewModel.arrayOfFilteredData[indexPath.row].special_item_id {
                        if (specialItemID == 1)
                        {
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
                        else
                        {
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
                    
                    if(self.showPrice == "0") {
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
                                //cell.addContainerView.isHidden = true
                            } else {
                                cell.priceLabel.textColor = UIColor.black
                                if let status = viewModel.arrayOfFilteredData[indexPath.row].status {
                                    if(status != "Active") {
                                        cell.priceLabel.isHidden = true
                                    } else {
                                        cell.priceLabel.isHidden = false
                                    }
                                }
                                //cell.addContainerView.isHidden = false
                            }
                        }
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
                        } else {
                            cell.itemImageView.isHidden = false
                        }
                    }
                }
            }
            else { // Without Searching
                if self.viewModel.arrayOfListItems.count > 0 {
                    cell.didChangeQuantity = { value in
                        cell.index = indexPath.row
                        let itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""
                        if(value == "") {
                            //self.updateQuantityInArray(quantity: "0", sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                        } else  {
                            //self.updateQuantityInArray(quantity: value , sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                        }
                    }
                    cell.quantityTextField.isEnabled  = true
                    
                    if let strUOM = viewModel.arrayOfListItems[indexPath.row].uom {
                        cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    }
                 
                    
                    var multiCount: String = "\(Constants.getCount(itemCode: self.viewModel.arrayOfListItems[indexPath.row].item_code ?? ""))"
                    if multiCount != "0" {
                        cell.measureLabel.text = multiCount
                    } else {
                        cell.measureLabel.text = ""
                    }
                    
                   
                    
                    if let itemName = viewModel.arrayOfListItems[indexPath.row].item_name {
                        if(itemName != "")
                        {
                            cell.itemLabel.text = itemName
                        }
                    }
                    //
//                    if let thumbImage = viewModel.arrayOfListItems[indexPath.row].thumb_image {
//                        if(thumbImage != ""){
//                            if let url = URL(string: thumbImage) {
//                                DispatchQueue.main.async {
//                                    cell.itemImageView?.sd_setImage(with: url, placeholderImage: Icons.placeholderImage)
//                                }
//                            }
//                        } else {
//                            cell.itemImageView?.image = Icons.placeholderImage
//                        }
//                    } else {
//                        cell.itemImageView?.image = Icons.placeholderImage
//                        
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
                    
                    //                if let strQuantity = viewModel.arrayOfListItems[indexPath.row].quantity {
                    //                if let strQuantity =  Constants.getPrice(itemCode: viewModel.arrayOfListItems[indexPath.row].item_code) {
                    //                    if (strQuantity == "0.00" || strQuantity == "0") {
                    //                        if (viewModel.arrayOfListItems[indexPath.row].special_title == 1)
                    //                        {
                    //                            cell.quantityTextField.text = ""
                    //                        }
                    //                        else
                    //                        {
                    //                            if (viewModel.arrayOfListItems[indexPath.row].uom?.count == 0)
                    //                            {
                    //                                cell.quantityTextField.text = "0"
                    //                            }
                    //                            else
                    //                            {
                    //                                cell.quantityTextField.text = ""
                    //                            }
                    //                        }
                    //                    } else {
                    //
                    //                        let floatQuantity = (strQuantity as NSString).floatValue.clean
                    //                        let strQuantity = String(floatQuantity)
                    //                        cell.quantityTextField.text  = strQuantity as String
                    //                    }
                    //                } else {
                    //                    cell.quantityTextField.text = ""
                    //                }
                    
                    if let strMeasure = Constants.getMeasure(itemCode: viewModel.arrayOfListItems[indexPath.row].item_code) {
                        let floatQuantity = (strMeasure as NSString).floatValue.clean
                        let strQuantity = String(floatQuantity)
                        cell.measureTexfield.text  = strQuantity as String
                    } else {
                        cell.measureTexfield.text  = ""
                    }
                     
                    if let strQuantity = Constants.getPrice(itemCode: viewModel.arrayOfListItems[indexPath.row].item_code) {
                        // if (strQuantity == "0.00" || strQuantity == "0") {
                        let Intprice = Int(strQuantity)
                        if (Intprice == 0) {
                            if (viewModel.arrayOfListItems[indexPath.row].special_item_id == 1) {
                                cell.quantityTextField.text = ""
                            }
                            else {
                                if (viewModel.arrayOfListItems[indexPath.row].uom?.count == 0)
                                {
                                    cell.quantityTextField.text = "0"
                                }
                                else {
                                    cell.quantityTextField.text = ""
                                }
                            }
                        } else {
                            let floatQuantity = (strQuantity as NSString).floatValue.clean
                            let strQuantity = String(floatQuantity)
                            cell.quantityTextField.text  = strQuantity as String
                        }
                    } else {
                        cell.quantityTextField.text = ""
                    }
                    
                    
                    if let isMeasure = viewModel.arrayOfListItems[indexPath.row].is_meas_box {
                        cell.configureIsMeasureShow(isMeasure: isMeasure)
                    }
                    
                    
                    if let specialItemID = viewModel.arrayOfListItems[indexPath.row].special_item_id {
                        if (specialItemID == 1)
                        {
                            if let strQuantity = viewModel.arrayOfListItems[indexPath.row].quantity {
                                if (strQuantity == "0.00" || strQuantity == "0") {
                                    cell.starImageView.isHidden = false
                                    //cell.addContainerView.isHidden = true
                                } else {
                                    cell.starImageView.isHidden = true
                                }
                            } else {
                                cell.starImageView.isHidden = true
                                //  cell.addContainerView.isHidden = false
                            }
                        }
                        else
                        {
                            cell.starImageView.isHidden = true
                            //cell.addContainerView.isHidden = false
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
                    
                    if(self.showPrice == "0") {
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
                                // cell.addContainerView.isHidden = true
                            } else {
                                cell.priceLabel.textColor = UIColor.black
                                if let status = viewModel.arrayOfListItems[indexPath.row].status {
                                    if(status != "Active") {
                                        cell.priceLabel.isHidden = true
                                    } else {
                                        cell.priceLabel.isHidden = false
                                    }
                                }
                                //cell.addContainerView.isHidden = false
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
                            //cell.addContainerView.isHidden = true
                        } else {
                            cell.itemImageView.isHidden = false
                            //cell.addContainerView.isHidden = false
                        }
                    }
                }
            }
            
            cell.starImageView.tintColor = UIColor.red
            cell.starImageView.image = UIImage(named: "starFill")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            //print("ind is", indexPath.row)
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
        if tableView == self.tableView {
            if self.showImage == "1" {
                return 130
            } else {
                return 74
            }
        } else if tableView == outletsTableView {
            return 38
        } else if tableView == bannerTableView {
            let isShowBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
            if isShowBanner == 1 && self.viewModel.arrayOfBanner.count > 0  {
                bannerContainerViewHeightConst.constant = Constants.bannerHeight
                return Constants.bannerHeight
            } else {
                bannerContainerViewHeightConst.constant = 0
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView != self.bannerTableView || tableView != self.outletsTableView {
            if searching {
                if self.viewModel.arrayOfFilteredData.count > 0 {
                    guard let specialTitle = self.viewModel.arrayOfFilteredData[indexPath.row].special_title else {return false}
                    guard let specialItemID = self.viewModel.arrayOfFilteredData[indexPath.row].special_item_id else {return false}
                    guard let isDelete = self.viewModel.arrayOfFilteredData[indexPath.row].is_delete else {return false}
                    if(specialTitle == 1) {
                        return false
                    } else  if(isDelete == 1) {
                        return true
                    } else  if(specialItemID == 1) {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                if self.viewModel.arrayOfListItems.count > 0 {
                    print(self.viewModel.arrayOfListItems.count)
                    if indexPath.row > self.viewModel.arrayOfListItems.count {
                        guard let specialTitle = self.viewModel.arrayOfListItems[indexPath.row].special_title else {return false}
                        guard let specialItemID = self.viewModel.arrayOfListItems[indexPath.row].special_item_id else {return false}
                        guard let isDelete = self.viewModel.arrayOfListItems[indexPath.row].is_delete else {return false}
                        if(specialTitle == 1) {
                            return false
                        } else  if(isDelete == 1) {
                            return true
                        }else  if(specialItemID == 1) {
                            return false
                        } else {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView != bannerTableView || tableView != self.outletsTableView {
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                if self.searching {
                    if let itemCode = self.viewModel.arrayOfFilteredData[indexPath.row].item_code {
                        self.deleteItemWithId(itemCode: itemCode, index: indexPath.row, isSearching: self.searching)
                    }
                    //self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfFilteredData.count)
                } else {
                    if let itemCode = self.viewModel.arrayOfListItems[indexPath.row].item_code {
                        self.deleteItemWithId(itemCode: itemCode, index: indexPath.row, isSearching: self.searching)
                    }
                    // self.configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfListItems.count)
                }
            })
            deleteAction.backgroundColor = UIColor.red
            return [deleteAction]
        }
        return nil
    }
    
    //MARK: -> Footer
    //        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //            if tableView != bannerTableView {
    //                let footer = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as? ButtonTableViewCell
    //
    //                footer?.reviewOrderClick = {
    //                    self.reviewYourOrder()
    //                }
    //
    //                return footer
    //            }
    //            return nil
    //        }
    //
    //        func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    //            if tableView != bannerTableView {
    //                return 1
    //            } else {
    //                return 0
    //            }
    //        }
    //
    //        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //            if tableView != bannerTableView {
    //                return 0
    //            } else {
    //                return 0
    //            }
    //        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != bannerTableView  {
            return CGFloat.leastNonzeroMagnitude
        }
        return CGFloat.zero
    }
}

//MARK: -> Delegete-Success
extension MyListViewController: DelegeteMyListSuccess {
    //    func updateArray(quantity: String,itemCode:String, index: Int) {
    //        if quantity != "" {
    //            if searching {
    //                if self.isChipSelelect {
    //                    print("chipSelected")
    //                    if viewModel.arrayOfFilteredData.count > 0 {
    //                        if let ind = viewModel.arrayOfFilteredData.firstIndex(where: {$0.item_code == itemCode}) {
    //                            self.viewModel.arrayOfFilteredData[ind].quantity = quantity
    //                        }
    //                    }
    //                } else {
    //                    self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfFilteredData
    //                    self.viewModel.arrayOfNewListItems[index].quantity = quantity
    //                    self.viewModel.arrayOfNewListItems[index].item_code = itemCode
    //                    self.viewModel.arrayOfFilteredData = self.viewModel.arrayOfNewListItems
    //                }
    //                self.updateTotaPrice()
    //                self.sendRequestUpdateUserProductList()
    //            } else {//Without-Searching
    //                if self.isChipSelelect {
    //                    print("chipSelected")
    //                    if viewModel.arrayOfListItems.count > 0 {
    //                        if let ind = viewModel.arrayOfListItems.firstIndex(where: {$0.item_code == self.viewModel.arrayOfListItems[index].item_code}) {
    //                            self.viewModel.arrayOfListItems[ind].quantity = quantity
    //                        }
    //                    }
    //                } else {
    //                    self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfListItems
    //                    self.viewModel.arrayOfNewListItems[index].quantity = quantity
    //                    self.viewModel.arrayOfNewListItems[index].item_code = itemCode
    //                    self.viewModel.arrayOfListItems = self.viewModel.arrayOfNewListItems
    //                }
    //                self.updateTotaPrice()
    //                self.sendRequestUpdateUserProductList()
    //            }
    //        }
    //    }
    
    //    func sendRequestReArrangeUserProductList() {
    //        var arrUpdatedPriceQuantity = [[String:Any]]()
    //        self.viewModel.arrayOfNewListItems.removeAll()
    ////        print(self.viewModel.arrayOfNewListItems)
    ////        print(self.viewModel.arrayOfListItems)
    //        // if(viewModel.isCategoryExist) {
    //        if searching {
    //            self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfFilteredData
    //        } else {
    //            self.viewModel.arrayOfNewListItems = self.viewModel.arrayOfListItems
    //        }
    //        //}
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
    //        print(JSON(dictParam))
    //        self.isChipSelelect = !isChipSelelect //use for enable selected Chip
    //        self.updateProductList(with: dictParam)
    //    }
    
    func RearrangingOrder() {
        var arrUpdatedPriceQuantity = [[String:Any]]()
        var localStorageData = LocalStorage.getItemsData()
        if localStorageData.count > 0 {
            var tempLocalStorageData = localStorageData
            LocalStorage.clearItemsData()
            var newUpdatedQuantityArray = [GetItemsData]()
            newUpdatedQuantityArray.removeAll()
            
            if searching {
                for i in 0..<self.viewModel.arrayOfFilteredData.count {
                    if self.viewModel.arrayOfFilteredData[i].quantity != "" {
                        newUpdatedQuantityArray.append(self.viewModel.arrayOfFilteredData[i])
                    }
                }
            } else {
                for i in 0..<self.viewModel.arrayOfListItems.count {
                    if self.viewModel.arrayOfListItems[i].quantity != "" {
                        newUpdatedQuantityArray.append(self.viewModel.arrayOfListItems[i])
                    }
                }
            }
            LocalStorage.saveItemsData(data: newUpdatedQuantityArray)
            var UpdatedQuantityLocalStorageData = LocalStorage.getItemsData()
            
            for i in 0..<localStorageData.count {
                if let itemCode = localStorageData[i].item_code {
                    if let index = UpdatedQuantityLocalStorageData.firstIndex(where: {$0.item_code == itemCode}) {
                        UpdatedQuantityLocalStorageData[index].quantity = localStorageData[i].quantity
                    } else {
                        print("Append in local Storage array ")
                        UpdatedQuantityLocalStorageData.append(localStorageData[i])
                    }
                }
            }
            LocalStorage.saveItemsData(data: UpdatedQuantityLocalStorageData)
        }
    }
    
    
//    func sendRequestUpdateUserProductList() {
//        self.view.endEditing(true)
//        var arrUpdatedPriceQuantity = [[String:Any]]()
//        let localStorageData = LocalStorage.getItemsData()
//        print(localStorageData)
//        for i in 0..<localStorageData.count {
//            var strQuantityy = ""
//            var strItemNamee = ""
//            var strItemCodee = ""
//            if let strQuantity = localStorageData[i].quantity {
//                strQuantityy = strQuantity
//            }
//            if let strItemName = localStorageData[i].item_name {
//                strItemNamee = strItemName
//            }
//            if let strItemCode  = localStorageData[i].item_code {
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
//        var orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
//
//        if(orderFlag == "") {
//            orderFlag = "0"
//        }
//
//        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
//        dictParam = [
//            UpdateProductList.type.rawValue:KeyConstants.appType ,
//            UpdateProductList.app_type.rawValue:appType,
//            UpdateProductList.client_code.rawValue:KeyConstants.clientCode ,
//            UpdateProductList.user_code.rawValue:userID ,
//            UpdateProductList.orderFlag.rawValue: orderFlag,
//            UpdateProductList.cartItems.rawValue:arrUpdatedPriceQuantity,
//            UpdateProductList.device_id.rawValue:Constants.deviceId]
//        print("Update",JSON(dictParam))
//        self.isChipSelelect = !isChipSelelect//use for enable selected Chip
//
//        print(self.viewModel.arrayOfListItems.count)
//        print(self.viewModel.arrayOfListItems)
//        print(self.viewModel.arrayOfFilteredData.count)
//        print(self.viewModel.arrayOfFilteredData)
//        self.updateProductList(with: dictParam)
//    }
    
    func  sendRequestUpdateUserProductList() {
        self.view.endEditing(true)
        var arrUpdatedPriceQuantity = [[String:Any]]()
        var localStorageData = LocalStorage.getItemsData()
        localStorageData += LocalStorage.getShowItData()
        //let localStorageData = self.viewModel.arrayOfListItems
        print(localStorageData)
        for i in 0..<localStorageData.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            var strmeasureQty = ""
            var stroriginQty = ""
            var strIsMeasure = 0
            var strPriority = 1
            var strId = 0
            if let strQuantity = localStorageData[i].quantity {
                strQuantityy = strQuantity
            }
            if let strItemName = localStorageData[i].item_name {
                strItemNamee = strItemName
            }
            if let strItemCode  = localStorageData[i].item_code {
                strItemCodee = strItemCode
            }
            
            if let measureQty  = localStorageData[i].measureQty {
                strmeasureQty = measureQty
            }
            
            if let originQty  = localStorageData[i].originQty {
                stroriginQty = originQty
            }
            if let isMeasure  = localStorageData[i].is_meas_box {
                strIsMeasure = isMeasure
            }
            
            if let isMeasure  = localStorageData[i].is_meas_box {
                strIsMeasure = isMeasure
            }
            
            if let priority  = localStorageData[i].priority {
                strPriority = priority
            }
            
            if let id  = localStorageData[i].id {
                strId = id
            }
            var dictData = [String:Any]()
            dictData["quantity"] = strQuantityy
            dictData["item_name"] = strItemNamee
            dictData["item_code"] = strItemCodee
            dictData["measureQty"] = strmeasureQty
            dictData["originQty"] = stroriginQty
            dictData["is_meas_box"] = strIsMeasure
            dictData["is_meas_box"] = strIsMeasure
            dictData["priority"] = strPriority
            dictData["id"] = strId
            arrUpdatedPriceQuantity.insert(dictData, at: i)
        }
        //----------------------------------------------------//
        var arrayOfListItems = self.viewModel.arrayOfListItems
        
        // Step 1: Store items from arrUpdatedPriceQuantity in an array instead of a dictionary
        var itemList = arrUpdatedPriceQuantity

        // Step 2: Create a sorted array based on arrayOfListItems order
        var sortedItems = [[String: Any]]()
        var seenItemCodes = Set<String>()

        for item in arrayOfListItems {
            if let itemCode = item.item_code {
                // Find the first matching item from itemList
                if let index = itemList.firstIndex(where: { $0["item_code"] as? String == itemCode }) {
                    sortedItems.append(itemList[index]) // Add the item in correct order
                    seenItemCodes.insert(itemCode)      // Track seen items
                    itemList.remove(at: index)          // Remove it to avoid duplicates
                }
            }
        }

        // Step 3: Append remaining items with originQty == "0"
        for remainingItem in itemList {
            if let originQty = remainingItem["originQty"] as? String, originQty == "0",
               let itemCode = remainingItem["item_code"] as? String, !seenItemCodes.contains(itemCode) {
                sortedItems.append(remainingItem) // Add only if originQty is zero and not already added
            }
        }

        // Step 4: Assign back to arrUpdatedPriceQuantity
        arrUpdatedPriceQuantity = sortedItems
        //----------------------------------------------------//
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        
        var orderFlag = "0"
        
        if let strOrderFlag = UserDefaults.standard.value(forKey: UserDefaultsKeys.orderFlag) as? String {
            orderFlag = strOrderFlag
        } else {
            orderFlag = "0"
        }
        UserDefaults.standard.set("0",forKey:UserDefaultsKeys.orderFlag)
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
            UpdateProductList.type.rawValue:KeyConstants.appType ,
            UpdateProductList.app_type.rawValue:appType,
            UpdateProductList.client_code.rawValue:KeyConstants.clientCode ,
            UpdateProductList.user_code.rawValue:userID ,
            UpdateProductList.orderFlag.rawValue: orderFlag,
            UpdateProductList.cartItems.rawValue:arrUpdatedPriceQuantity,
            UpdateProductList.device_id.rawValue:Constants.deviceId]
        print("Update",JSON(dictParam))
        self.isChipSelelect = !isChipSelelect//use for enable selected Chip
        //        print(self.viewModel.arrayOfListItems.count)
        //        print(self.viewModel.arrayOfListItems)
        //        print(self.viewModel.arrayOfFilteredData.count)
        //        print(self.viewModel.arrayOfFilteredData)
        self.updateProductList(with: dictParam)
    }
    
    func isSuceess(success: Bool, text: String, index: Int, measureQty:String) {
        //        if success {
        //            if searching {
        //                if text != "" {
        //                    guard let itemCode = self.viewModel.arrayOfFilteredData[index].item_code else { return }
        //                    self.updateArray(quantity: text, itemCode: itemCode, index: index)
        //                } else {
        //                    guard let itemCode = self.viewModel.arrayOfFilteredData[index].item_code else { return }
        //                    self.updateArray(quantity: "0", itemCode: itemCode, index: index)
        //                }
        //            } else {
        //                if text != "" {
        //                    guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
        //                    self.updateArray(quantity: text, itemCode: itemCode, index: index)
        //                } else {
        //                    guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
        //                    self.updateArray(quantity: "0", itemCode: itemCode, index: index)
        //                }
        //            }
        //        }
        
        if success {
            self.isChangedQuantity = true
            if searching {
                guard let itemCode = self.viewModel.arrayOfFilteredData[index].item_code else { return }
                if let ind = self.viewModel.arrayOfFilteredData.firstIndex(where: {$0.item_code == itemCode}) {
                    // if text != "" && text != "0" && text != "0.00"{
                    self.viewModel.arrayOfFilteredData[index].originQty = text
                    self.viewModel.arrayOfFilteredData[index].measureQty = measureQty
                    Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfFilteredData[index])
                    //} else {
                    // self.viewModel.arrayOfFilteredData[index].quantity = "0"
                    //}
                }
            } else {
                guard let itemCode = self.viewModel.arrayOfListItems[index].item_code else { return }
                if let ind = self.viewModel.arrayOfListItems.firstIndex(where: {$0.item_code == itemCode}) {
                    // if text != "" && text != "0" && text != "0.00"{
                    self.viewModel.arrayOfListItems[index].originQty = text
                    self.viewModel.arrayOfListItems[index].measureQty = measureQty
                    Constants.checkItems(localData: self.viewModel.arrayOfLocalStorageItems, data: self.viewModel.arrayOfListItems[index])
                    //} else {
                    // self.viewModel.arrayOfListItems[index].quantity = "0"
                    //}
                }
            }
        }
        self.updateTotaPrice()
        self.productListCollectionView.reloadData()
        // self.tableView.reloadData()
    }
}


//MARK: -> Searching
extension MyListViewController:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // make sure the result is under 16 characters
        return updatedText.count <= 4
    }
}

//MARK: -> Searching
extension MyListViewController {
    func searchText(with searchText: String?) {
        let arrayOfGarageData = viewModel.arrayOfListItems
        self.viewModel.arrayOfFilteredData = arrayOfGarageData.filter {
            return $0.item_name!.localizedCaseInsensitiveContains(searchText ?? "")
        }
        if searchText?.count == 0 {
            searching = false
            refreshEnable = false
            if self.showList == 0 {
                configureBackgroundList(with: Icons.noDataFound, message: "", count: arrayOfGarageData.count)
            } else {
                configureBackground(with: Icons.noDataFound, message: "", count: arrayOfGarageData.count)
            }
        } else {
            searching = true
            //refreshEnable = true
            if self.showList == 0 {
                configureBackgroundList(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfFilteredData.count)
            } else {
                configureBackground(with: Icons.noDataFound, message: "", count: self.viewModel.arrayOfFilteredData.count)
            }
        }
        refreshEnable = false
        //        if showList == 0 {
        //            tableView.reloadData()
        //        } else {
        //            productListCollectionView.reloadData()
        //        }
    }
}

//MARK: -> view-Model - Ineraction
extension MyListViewController {
    private func getItems(with param: [String: Any]) {
        self.view.endEditing(true)
        viewModel.getItems(with: param) { [self] result in
//            showSnakeBar(message: snakeBarMsg)

            switch result {
            case .success(let getUserItemsData):
                if let getUserItemsData = getUserItemsData {
                    guard let status = getUserItemsData.status else { return }
                    
                    if let displayAllItem = getUserItemsData.displayAllItemsInApp {
                        self.displayAllItem = displayAllItem
                        UserDefaults.standard.set(displayAllItem, forKey: "displayAllItem")
                    }
                    //                    if let arrayOfListItems = getUserItemsData.data_with_category {
                    //                        self.viewModel.arrItemsCategoryData = arrayOfListItems
                    //                        self.viewModel.arrayOfChips = arrayOfListItems
                    //                        if let arrayOfListItems = self.viewModel.arrayOfChips[0].data {
                    //                            self.viewModel.arrayOfListItems = arrayOfListItems
                    //                        }
                    //                    }
                    //
                    //                    if viewModel.arrItemsCategoryData.count > 0 {
                    //                        if let arrData = viewModel.arrItemsCategoryData[selectedChipIndex].data {
                    //                            self.viewModel.arrayOfListItems = arrData
                    //                            self.viewModel.arrayOfNewListItems = arrData
                    //                        }
                    //                    }
                    if let showAppBanner = getUserItemsData.showAppBanner {
                        UserDefaults.standard.set(showAppBanner, forKey:UserDefaultsKeys.showAppBanner)
                    }
                    
                    if let showItemInGrid = getUserItemsData.showItemInGrid {
                        UserDefaults.standard.set(showItemInGrid, forKey:UserDefaultsKeys.showItemInGrid)
                        configureGridOrList(isShowList: showItemInGrid)
                    }
                    
                    if let bannerLists = getUserItemsData.bannerLists {
                        self.viewModel.arrayOfBanner = bannerLists
                    }
                   
//                    if let multiList = getUserItemsData.multi_items {
//                        if !multiList.isEmpty {
//                            LocalStorage.clearMultiItemsData()
//                            LocalStorage.saveMultiData(data: multiList)
//                        }
//                    }
                    
                    if(getUserItemsData.category_exists == 0) {
                        viewModel.isCategoryExist = false
                        if let arrItemsData = getUserItemsData.data
                        {
                            self.viewModel.arrayOfListItems = arrItemsData
                        }
                    } else {
                        viewModel.isCategoryExist = true
                        if let arrItemsWithCategoryData = getUserItemsData.data_with_category  {
                            
                            for i in 0..<arrItemsWithCategoryData.count {
//                                print("category_title ::", arrItemsWithCategoryData[i].category_title)
                                if let catTitle = arrItemsWithCategoryData[i].category_title {
                                    if self.isSpecialSelected && catTitle == "SPECIALS" {
                                        selectedChipIndex = i
                                    }
                                }
                            }
                            
                            if arrItemsWithCategoryData.count > 0 {
                                self.viewModel.arrItemsCategoryData = arrItemsWithCategoryData
                                self.viewModel.arrayOfChips = arrItemsWithCategoryData
                                if let arrItemsDataNew = self.viewModel.arrItemsCategoryData[0].data {
                                    self.viewModel.arrayOfListItems = arrItemsDataNew
                                }
                            }
                            
                        }
                        self.chipsCollectionView.reloadData()
                    }
                    
                    print(selectedChipIndex)
                    //                    if viewModel.arrItemsCategoryData.count > 0 {
                    //                        print(viewModel.arrItemsCategoryData.count)
                    //                        if let arrData = viewModel.arrItemsCategoryData[selectedChipIndex].data {
                    //                            self.viewModel.arrayOfListItems = arrData
                    //                            self.viewModel.arrayOfNewListItems = arrData
                    //                        }
                    //                    }
                    if viewModel.arrItemsCategoryData.count > 0 {
                        print(viewModel.arrItemsCategoryData.count)
                        
                        if viewModel.arrItemsCategoryData[0].data!.count > 0 {
                            if let arrData = viewModel.arrItemsCategoryData[selectedChipIndex].data {
                                self.viewModel.arrayOfListItems = arrData
                                self.viewModel.arrayOfNewListItems = arrData
                            }
                        } else {
                            if let arrData = viewModel.arrItemsCategoryData[0].data {
                                self.viewModel.arrayOfListItems = arrData
                                self.viewModel.arrayOfNewListItems = arrData
                            }
                        }
                    }
                    
                    if viewModel.arrayOfListItems.count > 0 {
                        //used to remove weekly product from list
                        if let WeeklyItemIndex = viewModel.arrayOfListItems.firstIndex(where: {$0.item_code == ""}) {
                            viewModel.arrayOfListItems.remove(at: WeeklyItemIndex)
                        }
                    }
                    
                    //self.addProductButton.isHidden = true
                    //labelAddProduct.isHidden = true
                    
                    if (status == 1) {
                        if let showImage = getUserItemsData.show_image {
                            self.showImage = showImage
                        }
                        if let customerType = getUserItemsData.customer_type {
                            UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                            if(customerType == "Wholesale Customer") {
                                self.strDeliveryPickUP = "Delivery"
                                self.hideDeliveryOrPickUpView()
                            } else {
                                if let showPickUp = getUserItemsData.show_pickup {
                                    if(showPickUp == 0) {
                                        self.hideDeliveryOrPickUpView()
                                    } else {
                                        self.showDeliveryOrPickUpView()
                                    }
                                }
                            }
                        } else {
                            if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                                if(customerType as? String  == "Wholesale Customer") {
                                    self.strDeliveryPickUP = "Delivery"
                                    self.hideDeliveryOrPickUpView()
                                }
                            }
                        }
                        
                        if let showPrice = getUserItemsData.show_price {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                            if(showPrice == "0") {
                                //self.totalPriceView.isHidden = true
                                //self.totalPriceLabel.isHidden = true
                                //self.totalPriceViewHeightConst.constant = 0
                                //self.totalPriceButton.isHidden = true
                            } else {
                                //self.totalPriceView.isHidden = false
                                //self.totalPriceLabel.isHidden = false
                                // self.totalPriceViewHeightConst.constant = 30
                                // self.totalPriceButton.isHidden = false
                            }
                            self.showPrice = showPrice
                        }
                        
                        if let outletName = getUserItemsData.outlet_name {
                            //self.outletLabel.text = outletName
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
                        
                        if let categoryExist = getUserItemsData.category_exists {
                            if(categoryExist == 0) {
                                viewModel.isCategoryExist = false
                                //                                                        self.hideCollectionView()
                                //                                                        if let arrItemsData = getUserItemsData.data
                                //                                                        {
                                //                                                            self.viewModel.arrItemsData  = arrItemsData
                                //                                                        }
                            } else {
                                viewModel.isCategoryExist = true
                                //                                                        self.showCollectionView()
                                //                                                        if let arrItemsWithCategoryData = getUserItemsData.data_with_category {
                                //                                                            self.viewModel.arrItemsCategoryData = arrItemsWithCategoryData
                                //                                                            if let arrItemsDataNew = self.viewModel.arrItemsCategoryData[0].data {
                                //                                                                self.viewModel.arrItemsData = arrItemsDataNew
                                //                                                            }
                                //                                                            productListCollectionView.reloadData()
                                //                                                        }
                            }
                        }
                        
                        if let minOrderValue = getUserItemsData.min_order_value {
                            self.viewModel.strMinOrderValue = minOrderValue
                        }
                        if let showPO  = getUserItemsData.show_po {
                            if(showPO == 0) {
                                self.viewModel.showPO = 0
                                self.hidePoNumber()
                            } else {
                                self.viewModel.showPO = 1
                                self.showPONumber()
                            }
                        }
                        if let routeAssigned = getUserItemsData.route_assigned {
                            if(routeAssigned == 0) {
                                viewModel.isRouteAssigned = false
                                self.routeNotAssigned()
                            } else {
                                viewModel.isRouteAssigned = true
                                self.routeAssigned()
                            }
                        }
                        //
                        if let arrDeliveryAvailableDates =  getUserItemsData.delivery_available_dates {
                            self.viewModel.deliveryAvailabelDates = arrDeliveryAvailableDates
                        }
                        if let deliveryAvailableDays = getUserItemsData.delivery_available {
                            self.viewModel.deliveryAvailableDays = deliveryAvailableDays
                        }
                        if(self.showPrice != "0") {
                            self.updateTotaPrice()
                        }
                        //
                        if let deliveryCharge = getUserItemsData.delivery_charge {
                            self.viewModel.strDeliveryCharge = deliveryCharge
                        }
                        
                        if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                            if(customerType as! String == "Retail Customer") {
                                if let showPickUp = getUserItemsData.show_pickup {
                                    if(showPickUp == 1) {
                                        if let radioButtonSelected = UserDefaults.standard.object(forKey:UserDefaultsKeys.selectedRadioButtonType) {
                                            if(radioButtonSelected as? String == "delivery") {
                                                self.selectDeliveryButton()
                                            }
                                            if(radioButtonSelected as? String == "pickup") {
                                                self.selectPickUpButton()
                                            }
                                        } else {
                                            self.selectDeliveryButton()
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let contactNo = getUserItemsData.pickup_contact {
                            self.viewModel.strContactNumber = contactNo
                            myListReviewOrderCollectionViewCell?.deliveryMessagelabel.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                            let strFullMessage = "Please call" + " " + self.viewModel.strContactNumber + " " + "to arrange a pick up time"
                            myListReviewOrderCollectionViewCell?.deliveryMessagelabel.text = strFullMessage
                        }
                        //                        self.itemsTableView.dataSource = self
                        //                        self.itemsTableView.delegate = self
                        //                        self.itemsTableView.reloadData()
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
                
                DispatchQueue.main.async {
                    self.chipsCollectionView.reloadData()
                    self.bannerTableView.reloadData()
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
    }
    
    //MARK: - METHOD TO HIT GET ITEMS API
    func callGetItems() {
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var dictParam = [String:Any]()
        var appType = ""
        var resetValue = "0"
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        
        let strResetValue = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isResetList)
        if strResetValue {
            resetValue = "1"
        }
        else {
            resetValue = "0"
        }
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
//            GetUserItems.type.rawValue:KeyConstants.appType ,
//            GetUserItems.app_type.rawValue:appType,
            GetUserItems.client_code.rawValue:KeyConstants.clientCode ,
            GetUserItems.user_code.rawValue:userID ,
            GetUserItems.reset.rawValue: resetValue,
            GetUserItems.device_id.rawValue:Constants.deviceId,
            GetUserItems.acm_code.rawValue: acmCode
        ]
        
        print(JSON(dictParam))
        self.getItems(with: dictParam)
    }
        
        //Get-Categories
        private func getCategoriesbyId(with param: [String: Any]) {
            viewModel.searchItemsByCategory(with: param, view: self.view) { result in
                switch result {
                case .success(let searchItemsByCategoryData):
                    if let searchItemsByCategoryData = searchItemsByCategoryData {
                        guard let status = searchItemsByCategoryData.status  else { return }
                        if (status == 1) {
                            if let arrCategoryData = searchItemsByCategoryData.data {
                                //print(arrCategoryData)
                                self.viewModel.arrayOfListItems.removeAll()
                                self.viewModel.arrayOfListItems = arrCategoryData
                                print("******",self.viewModel.arrayOfListItems.count)
                                self.tableView.reloadData()
                                self.productListCollectionView.reloadData()
                            }
                        } else if(status == 2 ) {
                            guard let messge = searchItemsByCategoryData.message else {return}
                            self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                        }
                        else {
                            //                        self.viewModel.arrayOfListItems.removeAll()
                            //                        self.productListCollectionView.reloadData()
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
                GetItemsByCategoryData.type.rawValue:KeyConstants.appType ,
                GetItemsByCategoryData.app_type.rawValue:appType,
                GetItemsByCategoryData.client_code.rawValue:KeyConstants.clientCode ,
                GetItemsByCategoryData.user_code.rawValue:userID ,
                GetItemsByCategoryData.category_id.rawValue:categoryID,
                GetItemsByCategoryData.device_id.rawValue:Constants.deviceId
            ]
            print(JSON(dictParam))
            self.getCategoriesbyId(with: dictParam)
        }
        
        //Get-Categories
        private func getChipsCategories(with param: [String: Any]) {
            viewModel.getCategories(with: param, view: self.view) { result in
                switch result {
                case .success(let categoryData):
                    if let categoryData = categoryData {
                        guard let status = categoryData.status  else { return }
                        if (status == 1) {
                            if let arrCategoryData = categoryData.categories {
                                print(arrCategoryData)
                                //self.viewModel.arrayOfChips = arrCategoryData
                                //                            if let id = self.viewModel.arrayOfChips[0].id {
                                //                                self.getItecmsById(categoryID: id)
                                //                            }
                                print(self.viewModel.arrayOfChips)
                                self.chipsCollectionView.reloadData()
                            }} else if(status == 2) {
                                DispatchQueue.main.async {
                                    guard let messge = categoryData.message else {return}
                                    self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                                }
                            }
                        else {
                            guard let messge = categoryData.message else {return}
                            DispatchQueue.main.async {
                                self.presentPopUpVC(message:messge,title: "")
                            }
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
        
        //Delete-Item
        func deleteItem(with param: [String: Any],itemCode:String, index: Int,isSearching: Bool) {
            viewModel.deleteItem (with: param, view: self.view,itemCode: itemCode) { result in
                switch result{
                case .success(let deletedItemData):
                    if let deletedItemData = deletedItemData {
                        guard let status = deletedItemData.status else { return }
                        if (status == 1) {
                            if self.viewModel.arrayOfListItems.count > 0 {
                                //used to remove weekly product from list
                                if let WeeklyItemIndex = self.viewModel.arrayOfListItems.firstIndex(where: {$0.item_code == ""}) {
                                    self.viewModel.arrayOfListItems.remove(at: WeeklyItemIndex)
                                }
                            }
                            self.viewModel.arrayOfListItems.remove(at: index)
                            
                            LocalStorage.deleteGetItemsIndex(itemCode: itemCode)
                            LocalStorage.deleteMultiItemsIndex(itemCode: itemCode)
                            //self.deleteSelectedItem(deletedRowIndexPath: deletedRowIndexPath,itemCode: itemCode)
                            //                         if isSearching {
                            //                          self.viewModel.arrayOfFilteredData.remove(at: index)
                            //                         } else {
                            //                         self.viewModel.arrayOfListItems.remove(at: index)
                            //                         }
                            if self.viewModel.arrItemsCategoryData[self.selectedChipIndex].data?.count == 1 {
                                for i in 0..<self.viewModel.arrayOfChips.count {
                                    self.viewModel.arrayOfChips[i].isSlected = false
                                }
                                self.selectedChipIndex = 0
                            }
                            self.productListCollectionView.reloadData()
                            self.tableView.reloadData()
                            self.callGetItems()
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
        
        func deleteItemWithId(itemCode: String, index: Int,isSearching: Bool) {
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
            deleteItem(with: dictParam, itemCode: itemCode, index: index,isSearching: searching)
        }
        
        //MARK: -> getChipsCategoriesData
        private func getChipsCategoriesData() {
            let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
            let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
            // appNameLabel.text = appName
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
            let dictParam = [
                GetCategoryData.type.rawValue:KeyConstants.appType ,
                GetCategoryData.user_code.rawValue:userID,
                GetCategoryData.client_code.rawValue:KeyConstants.clientCode ,
                GetCategoryData.device_id.rawValue:Constants.deviceId,
            ]
            self.getChipsCategories(with: dictParam)
        }
        
        //MARK: - sendRequestUpdateUserProductList // Called When Add quantity on TextField.
        //Update-Product-List
        private func updateProductList(with param: [String: Any]) {
            viewModel.updateProductList(with: param, view: self.view) { result in
                switch result{
                case .success(let deletedItemData):
                    print(deletedItemData)
                    // self.productListCollectionView.reloadData()
                    if let status = deletedItemData?.status {
                        if status == 1 {
                            self.configureTabBar()
                            if self.viewModel.isComingFromReviewOrderButton {
                                self.goToConfirmPaymentPage()
                            }
                        }
                        self.callGetItems()
                    }
                case .failure(let error):
                    print(error)
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
                    self.callGetItems()
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


extension MyListViewController:ShowPopupResetListDelegate,PopUpDelegate {
    //    //MARK: - POPUP RESET LIST DELEGATE
    //    func showPopUP(didTapCancel: Bool, didTapConfirm: Bool) {
    //        if(didTapCancel){
    //            strResetValue = "0"
    //        } else if(didTapConfirm){
    //            strResetValue = "1"
    //        }
    //        self.callGetItems()
    //    }
    
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
        if let userdefaultId = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String {
            userDefaultId = userdefaultId
        }
        if(userId == userDefaultId) {
            self.logOut()
        }
        else{
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserDefaultLoginID)
            UserDefaults.standard.set(userDefaultId, forKey:UserDefaultsKeys.UserLoginID)
            self.pushToOutlets()
        }
    }
    
    //MARK: - METHOD TO PUSH TO OUTLETS
    func pushToOutlets() {
        let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
        navigationController?.pushViewController(tbc, animated: false)
    }
}

//MARK: -> Notification Center
extension MyListViewController {
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
        self.selectedChipIndex = 0
        self.updateTotaPrice()
        tableView.reloadData()
        productListCollectionView.reloadData()
    }
}

//MARK: -> DelegeteBannerImageClick
extension MyListViewController: DelegeteBannerImageClick {
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
            vc.isComingFromBannerClick = true
            vc.tabType = self.tabType
            vc.itemCode = self.viewModel.arrayOfBanner[ind].linkItemTypeID ?? ""
            vc.showImage = self.showImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//MARK: -> DelegeteSuccess
extension MyListViewController: DelegeteSuccess {
    func isSuceess(success: Bool, text: String) {
        self.updateTotaPrice()
        if showList == 0 {
            self.tableView.reloadData()
        } else {
            productListCollectionView.reloadData()
        }
    }
}

//MARK: -> UIScrollViewDelegate
extension MyListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isShowBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
        if isShowBanner == 1 && self.viewModel.arrayOfBanner.count > 0 {
            if scrollView.contentOffset.y > 0 {
                //bannerContainerView.isHidden = true
                setView(view:  bannerContainerView, hidden: true)
                bannerContainerViewHeightConst.constant = 0
            } else {
                //bannerContainerView.isHidden = false
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

//MARK: -> Handle-Background-State
extension MyListViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        if presentingViewController is MyListViewController {
            print("handleAppDidBecomeActive")
            self.refreshEnable = true
            addObserver()
            viewModel.isResetList = UserDefaults.standard.bool(forKey: "isResetList")
            if(viewModel.isResetList) {
                self.showPopUpToResetList()
                viewModel.isResetList = false
                UserDefaults.standard.set(false, forKey: "isResetList")
            } else {
                self.callGetItems()
            }
        }
    }
}

//MARK: - snake Bar
extension MyListViewController {
    func showSnakeBar(message: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ToastViewController") as! ToastViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.message = snakeBarMsg
        self.present(vc, animated: false, completion: nil)
    }
}

//MARK: - RefreshDelegate
extension MyListViewController: RefreshDelegate {
    func refresh() {
        updateTotaPrice()
         configureCartImage()
         self.productListCollectionView.reloadData()
         self.tableView.reloadData()
         self.sendRequestUpdateUserProductList()
     }
}
