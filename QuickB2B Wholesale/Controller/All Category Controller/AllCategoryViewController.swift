//  AllCategoryViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 20/04/23.

import UIKit

class AllCategoryViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var searchTectField: UITextField!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var bannerTableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tabbarView: CustomTabBarView!
    var tabType: TabType = .none
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartImageIcon: UIImageView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    @IBOutlet weak var totalCartItemsCountTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var totalCartItemsCountTopConst: NSLayoutConstraint!
    @IBOutlet weak var appNameStackView: UIStackView!

    //MARK: -> Properties
    var viewModel = AllCategoryViewModel()
    var showAppBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
    var floatTotalPrice :Float! = 0.0
    var arrayOfAllCategory = [AllCategory]()
    var displayAllItems = UserDefaults.standard.bool(forKey: "displayAllItem")
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        self.configureCartImage()
        //configureUI()
        //registerCell()
        //updateTotaPrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        registerCell()
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
        
        if let showBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int {
            if showBanner == 1 {
                bannerTableViewHeightConst.constant = Constants.bannerHeight
            } else {
                bannerTableViewHeightConst.constant = 0
            }
        } else {
            bannerTableViewHeightConst.constant = 0
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom:100, right: 0) // Add bottom inset of 20
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            let localStorageArray = LocalStorage.getFilteredData()
            if localStorageArray.count == 0 {
                self.configureTabBar()
                self.presentPopUpVC(message: emptyCart, title: "")
            } else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let confirmPaymentVC = storyBoard.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
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
    
    //MARK: -> Helpers
    private func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        searchContainerView.layer.cornerRadius = Radius.searchViewRadius
        searchContainerView.layer.borderWidth = Radius.searchViewborderWidth
        searchContainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.textColor = UIColor.MyTheme.appNameColor
        totalPriceLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAmountLabelTapped(_:)))
        totalPriceLabel.addGestureRecognizer(tapGesture)
        
        if self.arrayOfAllCategory.count > 0 {
            self.viewModel.arrayOfAllCategory = self.arrayOfAllCategory
            collectionView.reloadData()
        }
        
        searchTectField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH ALL PRODUCTS",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
        
        if let showBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int {
            if showBanner == 1 {
                bannerTableViewHeightConst.constant = Constants.bannerHeight
            } else {
                bannerTableViewHeightConst.constant = 0
            }
        } else {
            bannerTableViewHeightConst.constant = 0
        }
    }
    
    private func registerCell() {
        collectionView.register(UINib(nibName: "AllCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllCategoryCollectionViewCell")
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
    }
    
    @objc func totalAmountLabelTapped(_ sender: UITapGestureRecognizer) {
        var localStorageArray = LocalStorage.getFilteredData()
         localStorageArray = LocalStorage.getFilteredMultiData()
        if localStorageArray.count == 0 {
            self.presentPopUpVC(message: emptyCart, title: "")
        } else {
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let confirmPaymentVC = StoryBoard.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
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
        
        floatTotalPrice = totalPrice
        if(floatTotalPrice < 0.0){
            floatTotalPrice = 0.0
        }
        let strTotalPrice:NSString = NSString(format: "%.2f", totalPrice)
        let strTottalPrice:String = strTotalPrice as String
        let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
        let strTitleTotalPriceButton = "Total" + " " + currencySymbol + strTottalPrice
        self.totalPriceLabel.text = strTitleTotalPriceButton
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
        var  cartItems = LocalStorage.getFilteredData()
        cartItems += LocalStorage.getFilteredMultiData()
        totalCartItemsCountTopConst.constant = Constants.totalCartItemsCountTopConst
        totalCartItemsCountTrailingConst.constant = CGFloat(Constants.cartItemsCountLabelTrailingConst())
        if cartItems.count > 0 {
            cartItemsCountLabel.text = "\(cartItems.count)"
        } else {
            cartItemsCountLabel.text = "0"
        }
    }
    
    //MARK: -> Button Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        //go to search page
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
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let confirmPaymentVC = StoryBoard.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            confirmPaymentVC.tabType = self.tabType
            self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
        }
    }
}

//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource
extension AllCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOfAllCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCollectionViewCell", for: indexPath) as! AllCategoryCollectionViewCell
        cell.configureData(data: viewModel.arrayOfAllCategory[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = StoryBoard.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
        //tabVC?.selectedTabIndex = 2
        if let categoryId = viewModel.arrayOfAllCategory[indexPath.row].id {
            UserDefaults.standard.setValue(categoryId, forKey: "AllCategoryId")
        }
        self.navigationController?.pushViewController(tabVC!, animated: false)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.size.width - 1) / 3
//       // return  CGSize(width: width , height: 140)
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    return  CGSize(width: width , height: width - 10)
//                 } else {
//                     return  CGSize(width: width , height:  160)
//                 }
//        //return CGSize(width: (collectionView.bounds.width/3) , height:140)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        // Calculate total padding space for the items
        let paddingSpace = 0.0
        // Calculate available width by subtracting padding space from collection view width
        let availableWidth = collectionView.frame.width - paddingSpace
        // Calculate width for each item
        let widthPerItem = availableWidth / itemsPerRow
        // Calculate height based on 4:3 aspect ratio
        let heightPerItem = (widthPerItem * 3) / 3
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}

//MARK: -> UITableViewDelegate, UITableViewDataSource
extension AllCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
        cell.configureUI()
        cell.configureUI(with: viewModel.arrayOfBanner)
        cell.delegeteBannerImageClick = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.showAppBanner == 1 {
            bannerTableViewHeightConst.constant = Constants.bannerHeight
            return Constants.bannerHeight
        } else {
            bannerTableViewHeightConst.constant = 0
            return 0
        }
    }
}

//MARK: - Delegete-BannerImage-Click
extension AllCategoryViewController: DelegeteBannerImageClick {
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
            //vc.selectedTabIndex = 3
            self.navigationController?.pushViewController(vc, animated: false)
        } else if linkItemType == "product" {
            let storyBoard = UIStoryboard(name: Storyboard.productDetailsStoryboard, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.isComingFromBannerClick = true
            vc.itemCode = self.viewModel.arrayOfBanner[ind].linkItemTypeID ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//MARK: -> UIScrollViewDelegate
extension AllCategoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isShowBanner = UserDefaults.standard.value(forKey:UserDefaultsKeys.showAppBanner) as? Int
        if isShowBanner == 1 {
            if scrollView.contentOffset.y > 0 {
                bannerTableViewHeightConst.constant = 0
            } else {
                bannerTableViewHeightConst.constant = Constants.bannerHeight
            }
        }
    }
}

//MARK: -> Handle-Background-State
extension AllCategoryViewController {
    func didEnterBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppDidBecomeActive() {
        print("handleAppDidBecomeActive")
        configureUI()
        registerCell()
        if let showPrice = UserDefaults.standard.value(forKey: UserDefaultsKeys.showPrice) as? String {
            if showPrice != "0" {
                updateTotaPrice()
            }
        }
    }
}
