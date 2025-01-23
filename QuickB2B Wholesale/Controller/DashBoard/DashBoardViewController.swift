//  DashBoardViewController.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 23/01/2020 Saka.

import UIKit
import Kingfisher
import IQKeyboardManagerSwift
import SwiftyJSON
import SDWebImage

class DashBoardViewController:UIViewController,CalendarDelegate,UITextFieldDelegate,ShowPopupResetListDelegate,PopUpDelegate {
    
    //MARK: - FooterView Properties
    @IBOutlet var labelAddProduct: UILabel!
    @IBOutlet var addProductButton: UIButton!
    @IBOutlet var viewAddProduct: UIView!
    @IBOutlet var outletLabel: UILabel!
    @IBOutlet var viewShowPickupHeightConst: NSLayoutConstraint!
    @IBOutlet var calendarImage: UIImageView!
    @IBOutlet var deliveryMessgeHeightConst: NSLayoutConstraint!
    @IBOutlet var poNumberTopConst: NSLayoutConstraint!
    @IBOutlet var poNumberHeightConst: NSLayoutConstraint!
    @IBOutlet var viewDeliveryHeightConst: NSLayoutConstraint!
    @IBOutlet var viewDeliveryPickUpHeightConst: NSLayoutConstraint!
    @IBOutlet var deliveryLabel: UILabel!
    @IBOutlet var viewDelivery: UIView!
    @IBOutlet var deliveryMessageLabel: UILabel!
    @IBOutlet var viewDeliveryPickUp: UIView!
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var deliveryDateLabel: UILabel!
    @IBOutlet var deliveryButton: UIButton!
    @IBOutlet var pickUpButton: UIButton!
    @IBOutlet var reviewYourOrderButton: UIButton!
    @IBOutlet var poNumberTextField: UITextField!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var viewOutletHeightConstant: NSLayoutConstraint!
    @IBOutlet var viewOutlet: UIView!
    @IBOutlet var totalPriceButton: UIButton!
    @IBOutlet var itemsTableView: UITableView!
    @IBOutlet var selectOutletButton: UIButton!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var totalPriceViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var categoryCollectionViewHeightConst: NSLayoutConstraint!
    
    //MARK: - Properties
    var viewModel = DashboardViewModel()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceViewHeightConst.constant = 0
        addProductButton.setTitle("Click here", for: .normal)
        labelAddProduct.text = "to add product in your list"
        self.viewModel.arrSuppliers = viewModel.db.readData()
        if(self.viewModel.arrSuppliers.count == 1){
            self.dropDownButton.isHidden = true
            self.dropDownButton.isUserInteractionEnabled = false
        } else {
            self.dropDownButton.isHidden = false
            self.dropDownButton.isUserInteractionEnabled = true
        }
        self.findHamburguerViewController()?.gestureEnabled = false
        self.findHamburguerViewController()?.gestureRecognizer?.isEnabled = false
        viewOutletHeightConstant.constant = 0
        viewOutlet.isHidden = true
        
        viewModel.isComingFromReviewOrderButton = false
        self.viewModel.strDeliveryPickUP = "Delivery"
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.2 // optional
        itemsTableView.addGestureRecognizer(longPress)
        //footerView.translatesAutoresizingMaskIntoConstraints = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        itemsTableView.dragInteractionEnabled = true
        itemsTableView.tableFooterView = viewFooter
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        viewModel.specialItemIndex = 0
        self.viewModel.showImage = "0"
        viewModel.strResetValue = "0"
        viewModel.showPrice = "0"
        configureUI()
        addProductButton.isHidden = true
        labelAddProduct.isHidden = true
        self.hideDeliveryOrPickUpView()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        UserDefaults.standard.set("delivery", forKey:UserDefaultsKeys.selectedRadioButtonType)
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        itemsTableView.tableHeaderView = UIView(frame: frame)
        categoryCollectionView.isHidden = true
        categoryCollectionViewHeightConst.constant = 0
        let isShowFeaturedImageOnDashboard = UserDefaults.standard.object(forKey:UserDefaultsKeys.isShowFeaturedImageOnDashboard) as? Bool ?? false
        if(isShowFeaturedImageOnDashboard){
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
                GetInformation.client_code.rawValue:clientCode ,
                GetInformation.user_code.rawValue:userID,
                GetInformation.device_id.rawValue:Constants.deviceId,
            ]
            self.getFeaturedProduct(with: dictParam)
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.isShowFeaturedImageOnDashboard)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        
        NotificationCenter.default.removeObserver(self)
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
        
        if let comment = UserDefaults.standard.object(forKey:"comment") {
            commentTextView.text = comment as? String
        }
        if let poNumber = UserDefaults.standard.object(forKey:UserDefaultsKeys.ponumber) {
            poNumberTextField.text = poNumber as? String
        }
        
        if let selectedDate = UserDefaults.standard.object(forKey:"SelectedDate")   {
            if(selectedDate as? String ?? "" == "") {
                //                deliveryDateLabel.text = "Next Delivery"
            } else {
                deliveryDateLabel.text = selectedDate as? String ?? ""
            }
        }
        else {
            //deliveryDateLabel.text = "Next Delivery"
        }
        if(viewModel.isResetList) {
            self.showPopUpToResetList()
            viewModel.isResetList = false
        } else  {
            self.callGetItems()
        }
        setNeedsStatusBarAppearanceUpdate()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        commentTextView.textColor = UIColor.black
        commentTextView.backgroundColor = UIColor.white
        commentTextView.placeholder = "Comments:";
        commentTextView.placeholderColor = UIColor.gray
        commentTextView.layer.cornerRadius = 5;
        commentTextView.layer.borderWidth=1;
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        viewDelivery.layer.cornerRadius = 5;
        viewDelivery.layer.borderWidth=1;
        viewDelivery.layer.borderColor = UIColor.gray.cgColor
        poNumberTextField.textColor = UIColor.black
        poNumberTextField.backgroundColor = UIColor.white
        poNumberTextField.attributedPlaceholder = NSAttributedString(string: "PO Number:",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        poNumberTextField.layer.cornerRadius = 5
        poNumberTextField.layer.borderWidth = 1
        poNumberTextField.layer.borderColor = UIColor.gray.cgColor
        deliveryLabel.text = "Delivery:"
        deliveryLabel.textColor = UIColor.gray
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - METHOD TO ADD PICKER VIEW
    func addPickerView() {
        self.view.endEditing(true)
        
        self.viewModel.pickerView = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: self.view.frame.size.width, height: 180))
        self.viewModel.pickerView?.backgroundColor = UIColor.white
        self.viewModel.pickerView?.showsSelectionIndicator = true
        self.viewModel.pickerView?.delegate = self
        self.viewModel.pickerView?.dataSource = self
        self.viewModel.pickerView?.setValue(UIColor.black, forKey: "textColor")
        viewModel.pickerView?.selectRow(1, inComponent: 0, animated: false)
        self.view.addSubview(viewModel.pickerView!)
        
        viewModel.toolBar.frame = CGRect(x: 0, y: self.view.frame.size.height-220, width: self.view.frame.size.width, height: 50)
        viewModel.toolBar.barStyle = UIBarStyle.blackOpaque
        viewModel.toolBar.isTranslucent = true
        viewModel.toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelPicker))
        cancelButton.tintColor = UIColor.white
        viewModel.toolBar.backgroundColor = UIColor.black
        doneButton.tintColor = UIColor.white
        viewModel.toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        viewModel.toolBar.isUserInteractionEnabled = true
        self.view.addSubview(viewModel.toolBar)
    }
    
    //MARK: - METHOD TO DISMISS PICKERVIEW AND TOOLBAR
    @objc func donePicker() {
        self.viewModel.pickerView?.removeFromSuperview()
        self.viewModel.toolBar.removeFromSuperview()
        self.viewModel.pickerView?.selectRow(viewModel.selectSupplier, inComponent: 0, animated: true)
        self.appNameLabel.text = self.viewModel.strSupplierNamePicker
        //UserDefaults.standard.set(viewModel.strSupplierNamePicker, forKey: UserDefaultsKeys.AppName)
        UserDefaults.standard.set(viewModel.strClientCodePicker, forKey: "ClientCode")
        UserDefaults.standard.set(viewModel.strUserCodePicker, forKey:UserDefaultsKeys.UserLoginID)
        UserDefaults.standard.set(viewModel.strUserCodePicker, forKey:UserDefaultsKeys.UserDefaultLoginID)
        let outletListVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
        self.navigationController?.pushViewController(outletListVC!, animated: false)
    }
    
    //MARK: - METHOD TO Cancel PickerView
    @objc func cancelPicker() {
        self.viewModel.pickerView?.removeFromSuperview()
        self.viewModel.toolBar.removeFromSuperview()
    }
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - NOTIFICATION METHOD WHEN APP MOVED TO BACKGROUND
    @objc func willResignActive(_ notification: Notification) {
        self.sendRequestUpdateUserProductList()
    }
    
    
    //MARK: - METHOD TO SHOW POP UP TO RESET LIST
    func showPopUpToResetList(){
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
    
    //MARK: - METHOD TO HIT GET ITEMS API
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
            GetUserItems.type.rawValue:KeyConstants.appType ,
            GetUserItems.app_type.rawValue:appType,
            GetUserItems.client_code.rawValue:clientCode ,
            GetUserItems.user_code.rawValue:userID ,
            GetUserItems.reset.rawValue:viewModel.strResetValue,
            GetUserItems.device_id.rawValue:Constants.deviceId,
        ]
        self.registerCustomCell()
        self.getItems(with: dictParam)
    }
    
    //MARK: - METHOD TO HIDE DELIVERY OR PICK UP BUTTON
    func hideDeliveryOrPickUpView() {
        viewModel.isPickUpDeliveryAvailable = false
        viewDeliveryPickUp.isHidden = true
        viewShowPickupHeightConst.constant = 0
        deliveryMessageLabel.isHidden = true
        deliveryMessgeHeightConst.constant = 0
        viewDelivery.isHidden = false
        viewDeliveryHeightConst.constant = 45
    }
    
    //MARK: - METHOD TO SHOW DELIVERY OR PICK UP BUTTON
    func showDeliveryOrPickUpView() {
        viewModel.isPickUpDeliveryAvailable = true
        viewDeliveryPickUp.isHidden = false
        viewShowPickupHeightConst.constant = 50
        viewDelivery.isHidden = false
        deliveryMessageLabel.isHidden = true
        deliveryMessgeHeightConst.constant = 21
        deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
        viewDeliveryHeightConst.constant = 45
    }
    
    //MARK: - METHOD TO HIDE PO NUMBER
    func hidePoNumber() {
        poNumberTextField.isHidden = true
        poNumberTopConst.constant = 0
        poNumberHeightConst.constant = 0
    }
    
    //MARK: - METHOD TO SHOW PO NUMBER
    func showPONumber() {
        poNumberTextField.isHidden = false
        poNumberTopConst.constant = 10
        poNumberHeightConst.constant = 45
    }
    
    //MARK: - METHOD TO SELECT DELIVERY BUTTON
    func selectDeliveryButton() {
        self.viewModel.strDeliveryPickUP = "Delivery"
        viewShowPickupHeightConst.constant = 50
        viewDeliveryHeightConst.constant = 45
        viewDelivery.isHidden = false
        deliveryMessgeHeightConst.constant = 0
        deliveryMessageLabel.isHidden = true
        deliveryButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
        pickUpButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
        UserDefaults.standard.set("delivery", forKey:UserDefaultsKeys.selectedRadioButtonType)
    }
    
    //MARK: - METHOD TO SELECT PICKUP BUTTON
    func selectPickUpButton() {
        self.viewModel.strDeliveryPickUP = "Pickup"
        viewShowPickupHeightConst.constant = 75
        viewDeliveryHeightConst.constant = 0
        viewDelivery.isHidden = true
        deliveryMessgeHeightConst.constant = 21
        deliveryMessageLabel.isHidden = false
        deliveryButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
        pickUpButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
        UserDefaults.standard.set("pickup", forKey:UserDefaultsKeys.selectedRadioButtonType)
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
        let nav :HamburguerNavigationController = self.mainNavigationController()
        let hasViewController: Bool = true
        let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
        nav.setViewControllers([tbc], animated: false)
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                if hasViewController {
                    hamburguerViewController.contentViewController = nav
                }
            })
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
                ////UserDefaults.standard.set(strAppName, forKey: UserDefaultsKeys.AppName)
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
            var hasViewController: Bool = false
            let nav :HamburguerNavigationController = self.mainNavigationController()
            let tbc = storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as! OutletsListController
            nav.setViewControllers([tbc], animated: false)
            hasViewController = true
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
        } else {
            var hasViewController: Bool = false
            let nav :HamburguerNavigationController = self.mainNavigationController()
            let tbc = storyboard?.instantiateViewController(withIdentifier: "SupplierIdViewController") as! SupplierIdViewController
            nav.setViewControllers([tbc], animated: false)
            hasViewController = true
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    if hasViewController {
                        hamburguerViewController.contentViewController = nav
                    }
                })
            }
        }
    }
    
    //MARK: - METHOD WHEN ROUTE NOT ASSIGNED
    func routeNotAssigned() {
        calendarImage.isHidden = true
        deliveryDateLabel.text = "Next Delivery"
        selectDateButton.isEnabled = false
    }
    
    //MARK: - METHOD FOR HIDING COLLECTION VIEW
    func hideCollectionView() {
        categoryCollectionViewHeightConst.constant = 0
        categoryCollectionView.isHidden = true
    }
    
    //MARK: - METHOD FOR HIDING COLLECTION VIEW
    func showCollectionView() {
        categoryCollectionViewHeightConst.constant = 50
        categoryCollectionView.isHidden = false
    }
    
    //MARK: - METHOD WHEN ROUTE WAS ASSIGNED
    func routeAssigned() {
        calendarImage.isHidden = false
        if let strSelectedDate = UserDefaults.standard.object(forKey:UserDefaultsKeys.SelectedDate)        {
            deliveryDateLabel.text = strSelectedDate as? String
        }
        selectDateButton.isEnabled = true
    }
    
    // MARK: - Cell reorder / long press
    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        viewModel.isMenuButtonSelected = true
        let locationInView = sender.location(in: itemsTableView)
        let indexPath = itemsTableView.indexPathForRow(at: locationInView)
        
        if sender.state == .began {
            if indexPath != nil {
                if   let senderItemID = self.viewModel.arrItemsData[indexPath!.row].special_item_id {
                    if(senderItemID == 1){
                        return
                    }
                }
                
                if let specialTitle = viewModel.arrItemsData[indexPath!.row].special_title {
                    if(specialTitle == 1){
                        return
                    }
                }
                
                viewModel.dragInitialIndexPath = indexPath
                let cell = itemsTableView.cellForRow(at: indexPath!)
                viewModel.dragCellSnapshot = snapshotOfCell(inputView: cell!)
                var center = cell?.center
                viewModel.dragCellSnapshot?.center = center!
                viewModel.dragCellSnapshot?.alpha = 0.0
                itemsTableView.addSubview(viewModel.dragCellSnapshot!)
                
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
                let dataToMove = self.viewModel.arrItemsData[viewModel.dragInitialIndexPath!.row]
                viewModel.arrItemsData.remove(at: viewModel.dragInitialIndexPath!.row)
                viewModel.arrItemsData.insert(dataToMove, at: indexPath!.row)
                //            arrItemsData.swapAt(indexPath!.row, dragInitialIndexPath!.row)
                print(viewModel.arrItemsData)
                itemsTableView.moveRow(at: viewModel.dragInitialIndexPath!, to: indexPath!)
                viewModel.dragInitialIndexPath = indexPath
                //
            }
        } else if sender.state == .ended && viewModel.dragInitialIndexPath != nil {
            let cell = itemsTableView.cellForRow(at: viewModel.dragInitialIndexPath!)
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
                    print(self.viewModel.arrItemsData)
                    print(self.viewModel.arrLongPressGesture)
                    self.itemsTableView.reloadData()
                    self.sendRequestUpdateUserProductList()
                    return
                }
            })
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
    
    //MARK: - HIT UPDATE USER PRODUCT LIST API
    func sendRequestUpdateUserProductList(){
        var arrUpdatedPriceQuantity = [[String:Any]]()
        self.viewModel.arrItemsDataNew.removeAll()
        print(self.viewModel.arrItemsData)
        if(viewModel.isLongPressGestureRecogized) {
            print(self.viewModel.arrLongPressGesture)
            self.viewModel.arrItemsDataNew = self.viewModel.arrItemsData
        } else {
            if(viewModel.isCategoryExist)
            {
                if let data = self.viewModel.arrItemsCategoryData[0].data
                {
                    self.viewModel.arrItemsDataNew = data
                }
            } else {
                self.viewModel.arrItemsDataNew = self.viewModel.arrItemsData
            }
        }
        
        for i in 0..<viewModel.arrItemsDataNew.count {
            var strQuantityy = ""
            var strItemNamee = ""
            var strItemCodee = ""
            if let strQuantity = self.viewModel.arrItemsDataNew[i].quantity{
                strQuantityy = strQuantity
            }
            if let strItemName = self.viewModel.arrItemsDataNew[i].item_name{
                strItemNamee = strItemName
            }
            if let strItemCode  = self.viewModel.arrItemsDataNew[i].item_code{
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
        
        if(orderFlag == ""){
            orderFlag = "0"
        }
        
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        dictParam = [
            UpdateProductList.type.rawValue:KeyConstants.appType ,
            UpdateProductList.app_type.rawValue:appType,
            UpdateProductList.client_code.rawValue:clientCode ,
            UpdateProductList.user_code.rawValue:userID ,
            UpdateProductList.orderFlag.rawValue:orderFlag,
            UpdateProductList.cartItems.rawValue:arrUpdatedPriceQuantity,
        ]
        self.updateProductList(with: dictParam)
    }
    
    //MARK: - VALIDATE ORDER METHOD
    func validation()->Bool {
        if(self.viewModel.arrItemsDataToSend.count == 0) {
            self.presentPopUpVC(message:validateQuantities,title: "")
            return false
        } else {
            if(self.viewModel.strDeliveryPickUP == "Delivery") {
                if(viewModel.isRouteAssigned){
                    if(self.deliveryDateLabel.text == "Next Delivery" || self.deliveryDateLabel.text == "") {
                        self.presentPopUpVC(message: validateDeliveryDate,title: "")
                        return false
                    }
                }
            }
        }
        return true
    }
    
    //MARK: - Helpers
    private  func configureUI() {
        setupHamburgerMenu()
    }
    
    private func setupHamburgerMenu() {
        self.findHamburguerViewController()?.gestureEnabled = false
        self.findHamburguerViewController()?.gestureRecognizer?.isEnabled = false
    }
    
    //MARK: - Button Actions
    @IBAction func addProductButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController else {return}
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func selectOutletButton(_ sender: UIButton) {
        let outletVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
        self.navigationController?.pushViewController(outletVC!, animated: false)
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        self.view.endEditing(true)
        UserDefaults.standard.set(deliveryDateLabel.text, forKey:UserDefaultsKeys.SelectedDate)
        viewModel.isMenuButtonSelected = true
        //UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        self.findHamburguerViewController()?.showMenuViewController()
        self.sendRequestUpdateUserProductList()
        //
    }
    
    @IBAction func totalPriceButton(_ sender: Any) {
        self.reviewYourOrder()
    }
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        self.view.endEditing(true)
        showCalendar()
    }
    
    @IBAction func reviewYourOrderButton(_ sender: UIButton) {
        self.reviewYourOrder()
    }
    
    @IBAction func deliveryButton(_ sender: UIButton) {
        self.selectDeliveryButton()
    }
    
    @IBAction func pickUpButton(_ sender: UIButton) {
        self.selectPickUpButton()
    }
    
    @IBAction func dropDownButton(_ sender: Any) {
        self.addPickerView()
    }
    
    //MARK: - REVIEW YOUR ORDER
    private func reviewYourOrder(){
        self.viewModel.arrItemsDataToSend.removeAll()
        var comment = ""
        var poNumber = ""
        if  let commentt = commentTextView.text {
            comment = commentt
        }
        if let poNumberr = self.poNumberTextField.text {
            poNumber = poNumberr
        }
        
        UserDefaults.standard.set(poNumber, forKey:UserDefaultsKeys.ponumber)
        UserDefaults.standard.set(comment, forKey:UserDefaultsKeys.comment)
        UserDefaults.standard.set(deliveryDateLabel.text, forKey:UserDefaultsKeys.SelectedDate)
        if(viewModel.isCategoryExist){
            if   let arrItemsDatta = self.viewModel.arrItemsCategoryData[0].data {
                for i in 0..<arrItemsDatta.count {
                    if  let quantity = arrItemsDatta[i].quantity {
                        guard let floatQuantity = Float(quantity) else { return  }
                        if(quantity != "" && quantity != "0" && floatQuantity > 0.0 && quantity != "0.00") {
                            self.viewModel.arrItemsDataToSend.append(arrItemsDatta[i])
                        }
                    }
                }
            }
        } else {
            for i in 0..<self.viewModel.arrItemsData.count {
                if  let quantity = self.viewModel.arrItemsData[i].quantity {
                    guard let floatQuantity = Float(quantity) else { return  }
                    if(quantity != "" && quantity != "0" && floatQuantity > 0 && quantity != "0.00") {
                        self.viewModel.arrItemsDataToSend.append(self.viewModel.arrItemsData[i])
                    }
                }
            }
        }
        
        if(validation()) {
            viewModel.isComingFromReviewOrderButton = true
            self.sendRequestUpdateUserProductList()
        }
    }
    
    //MARK: - METHOD TO DELETE ITEM
    private func deleteSelectedItem(deletedRowIndexPath:Int,itemCode:String){
        if(viewModel.isCategoryExist){
            
            self.viewModel.arrItemsDataNew.removeAll()
            for i in 0..<viewModel.arrItemsCategoryData.count {
                var dict = viewModel.arrItemsCategoryData[i]
                if let data  = viewModel.arrItemsCategoryData[i].data  {
                    viewModel.arrItemsDataNew = data
                }
                
                for  j in 0..<self.viewModel.arrItemsDataNew.count {
                    if let itemCodeNew = viewModel.arrItemsDataNew[j].item_code {
                        if(itemCode == itemCodeNew) {
                            self.viewModel.arrItemsDataNew.remove(at: j)
                            break
                            
                        }
                    }
                }
                dict.data = viewModel.arrItemsDataNew
                viewModel.arrItemsCategoryData.remove(at: i)
                viewModel.arrItemsCategoryData.insert(dict, at: i)
            }
            if let data = self.viewModel.arrItemsCategoryData[viewModel.selectedIndexPath.row].data {
                self.viewModel.arrItemsData = data
            }
            itemsTableView.reloadData()
            self.updateTotaPrice()
        } else {
            self.viewModel.arrItemsData.remove(at: deletedRowIndexPath)
            itemsTableView.reloadData()
            self.updateTotaPrice()
        }
    }
    
    //MARK:- GO TO CONFIRM PAYMENT PAGE
    func goToConfirmPaymentPage() {
        let nav :HamburguerNavigationController = self.mainNavigationController()
        let confirmPaymentVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
        nav.setViewControllers([confirmPaymentVC], animated: false)
        confirmPaymentVC.arrSelectedItems = self.viewModel.arrItemsDataToSend
        confirmPaymentVC.showPrice = self.viewModel.showPrice
        confirmPaymentVC.strFeature = "Yes"
        confirmPaymentVC.strPoNumber = poNumberTextField.text ?? ""
        confirmPaymentVC.strShowImage = self.viewModel.showImage
        confirmPaymentVC.strComment = commentTextView.text ?? ""
        confirmPaymentVC.strDeliveryDate = deliveryDateLabel.text ?? ""
        confirmPaymentVC.strContactNo = self.viewModel.strContactNumber
        confirmPaymentVC.strPickUpDelivery = self.viewModel.strDeliveryPickUP
        confirmPaymentVC.strMinOrderValue = self.viewModel.strMinOrderValue
        confirmPaymentVC.strDeliveryCharge = self.viewModel.strDeliveryCharge
        confirmPaymentVC.floatTotalPrice = self.viewModel.floatTotalPrice
        confirmPaymentVC.showPO = self.viewModel.showPO
        self.navigationController?.pushViewController(confirmPaymentVC, animated: false)
    }
    
    //MARK:- REGISTER CUSTOM CELL
    private func registerCustomCell() {
        itemsTableView.register(UINib.init(nibName: "ItemTableViewCellWithoutImage", bundle: nil), forCellReuseIdentifier: "ItemTableViewCellWithoutImage")
        itemsTableView.register(UINib.init(nibName: "ItemTableViewCellWithImage", bundle: nil), forCellReuseIdentifier: "ItemTableViewCellWithImage")
        let nib = UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        categoryCollectionView?.register(nib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
    }
    
    func allowsFooterViewToFloat() -> Bool { return false }
    
    //MARK:- Show Calendar Method
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
    
    //MARK:- Calendar Delegate
    func passDate(strDate: String) {
        if(strDate != "") {
            deliveryDateLabel.text = strDate
        }
    }
    
    //MARK:- TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 1000) {
            return
        }
        
        if(self.viewModel.showImage == "0") {
            let  quantityFloatValue = (textField.text! as NSString).floatValue
            if !(quantityFloatValue > 0) {
                textField.text = ""
                let cell:ItemTableViewCellWithoutImage = textField.superview?.superview as! ItemTableViewCellWithoutImage
                cell.starImageView.isHidden = true
            }
        } else {
            let  quantityFloatValue = (textField.text! as NSString).floatValue
            if !(quantityFloatValue > 0) {
                textField.text = ""
                let cell:ItemTableViewCellWithImage = textField.superview?.superview as! ItemTableViewCellWithImage
                cell.starImageView.isHidden = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 1000) {
            return false
        }
        if(self.viewModel.showImage == "0") {
            let item:UITableViewCell = textField.superview?.superview as! ItemTableViewCellWithoutImage
            let currentIndexPath  = itemsTableView.indexPath(for: item)
            if (currentIndexPath?.row != viewModel.arrItemsData.count - 1) {
                let nextIndexPath = NSIndexPath(row: currentIndexPath!.row + 1, section: 0)
                let nextCell = itemsTableView.cellForRow(at: nextIndexPath as IndexPath) as? ItemTableViewCellWithoutImage
                nextCell?.quantityTextField.becomeFirstResponder()
            }
        } else  {
            let item:UITableViewCell = textField.superview?.superview as! ItemTableViewCellWithImage
            let currentIndexPath  = itemsTableView.indexPath(for: item)
            if (currentIndexPath?.row != viewModel.arrItemsData.count - 1) {
                
                let nextIndexPath = NSIndexPath(row: currentIndexPath!.row + 1, section: 0)
                let nextCell = itemsTableView.cellForRow(at: nextIndexPath as IndexPath) as? ItemTableViewCellWithImage
                nextCell?.quantityTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag == 1000) {
            return
        }
        
        if(textField.text  == "") {
            textField.text = "0"
        }
        
        if(self.viewModel.showImage == "0") {
            let item:ItemTableViewCellWithoutImage = textField.superview?.superview as! ItemTableViewCellWithoutImage
            let currentIndexPath  = itemsTableView.indexPath(for: item) ?? IndexPath(row: 0, section: 0)
            guard  let itemCode = self.viewModel.arrItemsData[currentIndexPath.row].item_code  else {return}
            if(textField.text == "") {
                self.updateQuantityInArray(quantity: "0", sectionIndexPath: viewModel.indexPathCategory, rowIndexPath: currentIndexPath,itemCode: itemCode,isReloadTableView: true)
            } else  {
                if let text = textField.text {
                    let doubleText: Double = Double(text) ?? 0.00
                    if(doubleText.decimalPlaces >= 3){
                        let tipText: String = String(format: "%.2f", doubleText)
                        self.updateQuantityInArray(quantity: tipText , sectionIndexPath: viewModel.indexPathCategory, rowIndexPath: currentIndexPath,itemCode: itemCode,isReloadTableView: true)
                    } else {
                        self.updateQuantityInArray(quantity: textField.text ?? "0", sectionIndexPath: viewModel.indexPathCategory, rowIndexPath: currentIndexPath,itemCode: itemCode,isReloadTableView: true)
                    }
                }
            }
        } else {
            let item:ItemTableViewCellWithImage = textField.superview?.superview as! ItemTableViewCellWithImage
            let currentIndexPath  = itemsTableView.indexPath(for: item) ?? IndexPath(row: 0, section: 0)
            guard  let itemCode = self.viewModel.arrItemsData[currentIndexPath.row ].item_code  else {return}
            if(textField.text == "") {
                self.updateQuantityInArray(quantity: "0", sectionIndexPath: viewModel.indexPathCategory, rowIndexPath: currentIndexPath,itemCode: itemCode,isReloadTableView: true)
            } else  {
                if let text = textField.text {
                    let doubleText: Double = Double(text) ?? 0.00
                    if(doubleText.decimalPlaces >= 3){
                        let tipText: String = String(format: "%.2f", doubleText)
                        self.updateQuantityInArray(quantity: tipText , sectionIndexPath: viewModel.indexPathCategory, rowIndexPath: currentIndexPath,itemCode: itemCode,isReloadTableView: true)
                    }else {
                        self.updateQuantityInArray(quantity: textField.text ?? "0", sectionIndexPath: viewModel.indexPathCategory, rowIndexPath: currentIndexPath,itemCode: itemCode,isReloadTableView: true)
                    }
                }
            }
        }
    }
    
    //
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag != 1000) {
            let nonNumberSet = CharacterSet(charactersIn: "0123456789.").inverted
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if(string != ""){
                if(string != numberFiltered){
                    return false
                }
            }
            var newValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            newValue = newValue?.components(separatedBy: nonNumberSet).joined(separator: "")
            if(newValue?.contains(".") == false){
                viewModel.dotLocation = 0
            }
            
            let countdots =  (textField.text?.components(separatedBy: (".")).count)! - 1
            
            if (countdots > 0 && string == "."){
                return false
            }
            
            if Int(range.length) == 0 && string.count == 0 {
                return true
            }
            
            if (string == ".") {
                // if Int(range.location) == 0 {
                //  return false
                //  }
                if viewModel.dotLocation == 0 {
                    viewModel.dotLocation = range.location
                    return true
                } else {
                    return false
                }
            }
            
            if range.location == viewModel.dotLocation && string.count == 0 {
                viewModel.dotLocation = 0
            }
            
            if(textField.text == ""){
                if viewModel.dotLocation == 0 && range.location > viewModel.dotLocation + 2 {
                    return false
                }
            }
            
            if viewModel.dotLocation > 0 && range.location > viewModel.dotLocation + 2 {
                return false
            }
            print(range.length)
            if(newValue?.count ?? 0 > 7){
                return false
            }
            
            if range.location >= 4 {
                if viewModel.dotLocation >= 4 || string.count == 0 {
                    return true
                } else if range.location > viewModel.dotLocation + 2 {
                    return false
                }
                textField.text = newValue
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    func updateQuantityInArray(quantity:String,sectionIndexPath:Int,rowIndexPath:IndexPath,itemCode:String,isReloadTableView:Bool) {
        if(quantity != "") {
            if(viewModel.isCategoryExist) {
                for i in 0..<viewModel.arrItemsCategoryData.count {
                    var dict = viewModel.arrItemsCategoryData[i]
                    if let data  = viewModel.arrItemsCategoryData[i].data  {
                        viewModel.arrItemsDataNew = data
                    }
                    for j in 0..<viewModel.arrItemsDataNew.count {
                        if let itemCodeNew = viewModel.arrItemsDataNew[j].item_code {
                            if(itemCode == itemCodeNew) {
                                viewModel.arrItemsDataNew[j].quantity = quantity
                            }
                        }
                    }
                    dict.data = viewModel.arrItemsDataNew
                    viewModel.arrItemsCategoryData.remove(at: i)
                    viewModel.arrItemsCategoryData.insert(dict, at: i)
                }
                
                if(viewModel.isCategoryExist){
                    if let data = self.viewModel.arrItemsCategoryData[viewModel.selectedIndexPath.row].data {
                        self.viewModel.arrItemsData = data
                    }
                }
                if(isReloadTableView){
                    itemsTableView.reloadRows(at: [rowIndexPath], with: .none)
                }
                print(self.viewModel.arrItemsCategoryData)
                print(self.viewModel.arrItemsCategoryData)
            } else {
                self.viewModel.arrItemsData[rowIndexPath.row].quantity = quantity
                if(isReloadTableView){
                    itemsTableView.reloadRows(at: [rowIndexPath], with: .none)
                }
            }
        }
        self.updateTotaPrice()
    }
    
    //MARK:- GO TO SHOW DATA METHODS
    func showItemData(row:Int){
        DispatchQueue.main.async {
            let imageUrl = self.viewModel.arrItemsData[row].image ?? ""
            let itemCode = self.viewModel.arrItemsData[row].item_code ?? ""
            let description = self.viewModel.arrItemsData[row].image_description ?? ""
            let itemName = self.viewModel.arrItemsData[row].item_name ?? ""
            let specialTitle = self.viewModel.arrItemsData[row].special_title ?? 0
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
    
    //MARK:- UPDATE TOTAL PRICE METHOD
    func updateTotaPrice() {
        var totalPrice:Float! = 0.0
        self.viewModel.arrItemsDataNew.removeAll()
        if(viewModel.isCategoryExist)
        {
            if let arrData = self.viewModel.arrItemsCategoryData[0].data {
                self.viewModel.arrItemsDataNew = arrData
            }
        } else {
            self.viewModel.arrItemsDataNew = self.viewModel.arrItemsData
        }
        for i in 0..<self.viewModel.arrItemsDataNew.count {
            var strPrice = ""
            var strQuantity = ""
            var strPortion = ""
            if  let strPricee = self.viewModel.arrItemsDataNew[i].item_price {
                strPrice = strPricee
            }
            if let strPortionn = self.viewModel.arrItemsDataNew[i].portion {
                strPortion = strPortionn
            }
            if let strQuantityy = self.viewModel.arrItemsDataNew[i].quantity {
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
        //self.totalPriceButton.setTitle(strTitleTotalPriceButton , for: .normal)
    }
    
    //MARK:- METHOD TO UPDATE CELL
    func updateCell(indexPath:NSIndexPath,value:String) {
        print(indexPath)
        print(value)
    }
}

//MARK:- TABLE VIEW DELEGATES AND DATA SOURCE
extension DashBoardViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //                if(isCategoryExist){
        //                    if let data = self.arrItemsCategoryData[selectedIndexPath.row].data
        //                    {
        //                        self.arrItemsData = data
        //                    }
        //                }
        return self.viewModel.arrItemsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.viewModel.showImage == "0") {
            let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ItemTableViewCellWithoutImage", for: indexPath) as! ItemTableViewCellWithoutImage
            cell.quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
            cell.selectionStyle = .none
            itemsTableView.separatorStyle = .singleLine
            cell.quantityTextField.isHidden = true
            cell.inactiveLabel.isHidden = false
            cell.inactiveLabel.text = ""
            cell.quantityTextField.isEnabled  = true
            cell.quantityTextField.tag = indexPath.row
            cell.quantityTextField.delegate = self
            cell.priceLabel.textColor = UIColor.black
            if let strUOM = viewModel.arrItemsData[indexPath.row].uom {
                cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }
            if let itemName = viewModel.arrItemsData[indexPath.row].item_name {
                if(itemName != "")
                {
                    cell.itemLabel.text = itemName
                }
            }
            
            cell.didChangeQuantity = { [self] value in
                let itemCode = self.viewModel.arrItemsData[indexPath.row].item_code ?? ""
                if(value == "") {
                    self.updateQuantityInArray(quantity: "0", sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                } else  {
                    self.updateQuantityInArray(quantity: value , sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                }
            }
            
            if let itemPrice = viewModel.arrItemsData[indexPath.row].item_price {
                let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
                cell.priceLabel.text =  currencySymbol + itemPrice
                cell.priceLabel.textColor = UIColor.black
            }
            
            if let strQuantity = viewModel.arrItemsData[indexPath.row].quantity {
                if (strQuantity == "0.00" || strQuantity == "0") {
                    if (viewModel.arrItemsData[indexPath.row].special_item_id == 1)
                    {
                        cell.quantityTextField.text = "";
                    }
                    else
                    {
                        if (viewModel.arrItemsData[indexPath.row].uom?.count == 0)
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
                
            }
            
            if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                if ( specialItemID == 1)
                {
                    if let strQuantity = viewModel.arrItemsData[indexPath.row].quantity {
                        print(strQuantity)
                        if (strQuantity == "0.00" || strQuantity == "0") {
                            cell.starImageView.isHidden = false
                            
                        } else {
                            cell.starImageView.isHidden = true
                        }
                    }
                }
                else
                {
                    cell.starImageView.isHidden = true
                }
            }
            
            if let status = viewModel.arrItemsData[indexPath.row].status {
                if(status != "Active") {
                    cell.quantityTextField.isHidden = true
                    cell.inactiveLabel.isHidden = false
                    cell.inactiveLabel.text = "NA"
                    cell.priceLabel.isHidden  = true
                    cell.specialItemLabel.isHidden = true
                    cell.itemLabel.isHidden = false
                } else {
                    cell.quantityTextField.layer.borderWidth = 0.5;
                    cell.quantityTextField.layer.cornerRadius = 5;
                    cell.quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                    cell.quantityTextField.textColor = UIColor.black
                    if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                        if ( specialItemID == 1)
                        {
                            cell.specialItemLabel.isHidden = true
                            cell.quantityTextField.isHidden = false
                            cell.priceLabel.isHidden = false
                            cell.itemLabel.isHidden = false
                            cell.quantityTextField.isEnabled = true
                        }
                        else
                        {
                            cell.specialItemLabel.isHidden = true
                            cell.quantityTextField.isHidden = false
                            cell.quantityTextField.isEnabled = true
                            cell.priceLabel.isHidden = false
                            cell.itemLabel.isHidden = false
                        }
                        
                    } }}
            else {
                cell.quantityTextField.isHidden = true
                cell.inactiveLabel.isHidden = false
                cell.inactiveLabel.text = "NA"
                cell.priceLabel.isHidden  = true
                cell.specialItemLabel.isHidden = true
                cell.itemLabel.isHidden = true
            }
            
            if(viewModel.showPrice == "0") {
                
                if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                    
                    if( specialItemID == 1){
                        cell.priceLabel.textColor = UIColor(red: 237.0/255, green: 35.0/255, blue: 35.0/255, alpha: 1.0)
                        cell.priceLabel.isHidden = false
                    } else {
                        cell.priceLabel.isHidden = true
                        cell.priceLabel.textColor = UIColor.black
                    }
                }
                
            } else {
                if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                    
                    if( specialItemID == 1){
                        cell.priceLabel.textColor = UIColor(red: 237.0/255, green: 35.0/255, blue: 35.0/255, alpha: 1.0)
                        if let status = viewModel.arrItemsData[indexPath.row].status {
                            if(status != "Active") {
                                
                                cell.priceLabel.isHidden = true
                            } else {
                                cell.priceLabel.isHidden = false
                            }
                        }
                        
                    } else {
                        cell.priceLabel.textColor = UIColor.black
                        if let status = viewModel.arrItemsData[indexPath.row].status {
                            if(status != "Active") {
                                cell.priceLabel.isHidden = true
                            } else {
                                cell.priceLabel.isHidden = false
                            }
                        }
                        
                    }
                }
            }
            
            if let specialTitle = viewModel.arrItemsData[indexPath.row].special_title {
                if(specialTitle == 1) {
                    viewModel.specialItemIndex = indexPath.row
                    cell.specialItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                    cell.specialItemLabel.isHidden = false
                    cell.itemLabel.isHidden = true
                    cell.quantityTextField.isHidden = true
                    cell.priceLabel.isHidden = true
                    cell.starImageView.isHidden  = true
                }
            }
            
            return cell
        } else {
            
            let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ItemTableViewCellWithImage", for: indexPath) as! ItemTableViewCellWithImage
            cell.selectionStyle = .none
            itemsTableView.separatorStyle = .none
            cell.quantityTextField.isHidden = false
            cell.inactiveLabel.isHidden = true
            cell.inactiveLabel.text = ""
            cell.quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
            
            cell.didChangeQuantity = { value in
                let itemCode = self.viewModel.arrItemsData[indexPath.row].item_code ?? ""
                if(value == "") {
                    self.updateQuantityInArray(quantity: "0", sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                    
                } else  {
                    self.updateQuantityInArray(quantity: value , sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
                }
            }
            cell.btnShowItemData = {
                self.showItemData(row: indexPath.row)
            }
            cell.quantityTextField.delegate = self
            cell.quantityTextField.isEnabled  = true
            cell.quantityTextField.tag = indexPath.row
            
            if let strUOM = viewModel.arrItemsData[indexPath.row].uom {
                cell.quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }
            if let itemName = viewModel.arrItemsData[indexPath.row].item_name {
                if(itemName != "")
                {
                    cell.itemLabel.text = itemName
                }
            }
            
            if let thumbImage = viewModel.arrItemsData[indexPath.row].thumb_image {
                if(thumbImage != ""){
                    if let url = URL(string: thumbImage) {
                        DispatchQueue.main.async {
                            cell.itemImageView?.sd_setImage(with: url, placeholderImage: nil)
                        }
                    }
                }else {
                    cell.itemImageView?.image = nil
                }
                
            }
            
            if let itemPrice = viewModel.arrItemsData[indexPath.row].item_price {
                let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
                cell.priceLabel.text =  currencySymbol + String(itemPrice)
            }
            
            if let strQuantity = viewModel.arrItemsData[indexPath.row].quantity {
                if (strQuantity == "0.00" || strQuantity == "0") {
                    if (viewModel.arrItemsData[indexPath.row].special_title == 1)
                    {
                        cell.quantityTextField.text = "";
                    }
                    else
                    {
                        if (viewModel.arrItemsData[indexPath.row].uom?.count == 0)
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
            }
            
            if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                if ( specialItemID == 1)
                {
                    if let strQuantity = viewModel.arrItemsData[indexPath.row].quantity {
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
            
            if let status = viewModel.arrItemsData[indexPath.row].status {
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
                    if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
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
            
            if(viewModel.showPrice == "0") {
                if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                    if( specialItemID == 1){
                        cell.priceLabel.textColor = UIColor(red: 237.0/255, green: 35.0/255, blue: 35.0/255, alpha: 1.0)
                        cell.priceLabel.isHidden = false
                        
                    } else {
                        cell.priceLabel.textColor = UIColor.black
                        cell.priceLabel.isHidden = true
                    }
                }
            } else {
                if let specialItemID = viewModel.arrItemsData[indexPath.row].special_item_id {
                    
                    if( specialItemID == 1){
                        cell.priceLabel.textColor = UIColor(red: 237.0/255, green: 35.0/255, blue: 35.0/255, alpha: 1.0)
                        if let status = viewModel.arrItemsData[indexPath.row].status {
                            if(status != "Active") {
                                cell.priceLabel.isHidden = true
                            } else {
                                cell.priceLabel.isHidden = false
                            }
                        }
                    } else {
                        cell.priceLabel.textColor = UIColor.black
                        if let status = viewModel.arrItemsData[indexPath.row].status {
                            if(status != "Active") {
                                cell.priceLabel.isHidden = true
                            } else {
                                cell.priceLabel.isHidden = false
                            }
                        }
                    }
                }
            }
            
            if let specialTitle = viewModel.arrItemsData[indexPath.row].special_title {
                if(specialTitle == 1) {
                    viewModel.specialItemIndex = indexPath.row
                    cell.specialIItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                    cell.specialIItemLabel.isHidden = false
                    cell.itemLabel.isHidden = true
                    cell.quantityTextField.isHidden = true
                    cell.priceLabel.isHidden = true
                    cell.starImageView.isHidden  = true
                    cell.itemImageView.isHidden = true
                }
                
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 0
        if(self.viewModel.showImage == "0") {
            height =  50
        } else {
            if let specialTitle = viewModel.arrItemsData[indexPath.row].special_title {
                if(specialTitle == 1) {
                    height =  60
                } else {
                    height = 120
                }
            }else {
                height = 120
            }
        }
        return CGFloat(height)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let specialTitle = self.viewModel.arrItemsData[indexPath.row].special_title else {return false}
        guard let specialItemID = self.viewModel.arrItemsData[indexPath.row].special_item_id else {return false}
        guard let isDelete = self.viewModel.arrItemsData[indexPath.row].is_delete else {return false}
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            if  let itemCode = self.viewModel.arrItemsData[indexPath.row].item_code {
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
                    DeleteItems.client_code.rawValue:clientCode,
                    DeleteItems.user_code.rawValue:userID ,
                    DeleteItems.item_code.rawValue:itemCode,
                    DeleteItems.device_id.rawValue:Constants.deviceId
                ]
                let deletedRow = indexPath.row
                self.deleteItem(with: dictParam,deletedRowIndexPath:deletedRow,itemCode: itemCode)
            }
            print("Delete tapped")
        })
        deleteAction.backgroundColor = UIColor.red
        return [ deleteAction]
    }
}

//MARK:- View-Model Ineraction
extension DashBoardViewController {
    private func getItems(with param: [String: Any]) {
        self.view.endEditing(true)
        viewModel.getItems(with: param) { [self] result in
            switch result {
            case .success(let getUserItemsData):
                if let getUserItemsData = getUserItemsData {
                    guard let status = getUserItemsData.status else { return }
                    
                    self.addProductButton.isHidden = true
                    labelAddProduct.isHidden = true
                    
                    if (status == 1) {
                        if let showImage = getUserItemsData.show_image {
                            self.viewModel.showImage = showImage
                        }
                        if let customerType = getUserItemsData.customer_type {
                            UserDefaults.standard.set(customerType, forKey:UserDefaultsKeys.CustomerType)
                            if(customerType == "Wholesale Customer") {
                                self.viewModel.strDeliveryPickUP = "Delivery"
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
                                    self.viewModel.strDeliveryPickUP = "Delivery"
                                    self.hideDeliveryOrPickUpView()
                                }
                            }
                        }
                        
                        if let showPrice  = getUserItemsData.show_price {
                            if(showPrice == "0"){
                                self.totalPriceView.isHidden = true
                                self.totalPriceLabel.isHidden = true
                                self.totalPriceViewHeightConst.constant = 0
                                self.totalPriceButton.isHidden = true
                            }else {
                                self.totalPriceView.isHidden = false
                                self.totalPriceLabel.isHidden = false
                                self.totalPriceViewHeightConst.constant = 30
                                self.totalPriceButton.isHidden = false
                            }
                            self.viewModel.showPrice = showPrice
                        }
                        
                        if let outletName = getUserItemsData.outlet_name {
                            self.outletLabel.text = outletName
                        }
                        
                        if let outletsNumber = getUserItemsData.outlets {
                            if(outletsNumber == 0 ){
                                viewOutlet.isHidden = true
                                viewOutletHeightConstant.constant = 0
                                selectOutletButton.isHidden = true
                                outletLabel.isHidden = true
                            } else if(outletsNumber == 1) {
                                viewOutlet.isHidden = false
                                viewOutletHeightConstant.constant = 30
                                selectOutletButton.isHidden = true
                                outletLabel.isHidden = false
                            }
                            else {
                                viewOutlet.isHidden = false
                                viewOutletHeightConstant.constant = 30
                                selectOutletButton.isHidden = false
                                outletLabel.isHidden = false
                            }
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
                                self.hideCollectionView()
                                if let arrItemsData = getUserItemsData.data
                                {
                                    self.viewModel.arrItemsData  = arrItemsData
                                }
                            } else {
                                viewModel.isCategoryExist = true
                                self.showCollectionView()
                                if let arrItemsWithCategoryData = getUserItemsData.data_with_category {
                                    self.viewModel.arrItemsCategoryData = arrItemsWithCategoryData
                                    if let arrItemsDataNew = self.viewModel.arrItemsCategoryData[0].data {
                                        self.viewModel.arrItemsData = arrItemsDataNew
                                    }
                                    categoryCollectionView.reloadData()
                                }
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
                        
                        if let arrDeliveryAvailableDates =  getUserItemsData.delivery_available_dates {
                            self.viewModel.deliveryAvailabelDates = arrDeliveryAvailableDates
                        }
                        if let deliveryAvailableDays = getUserItemsData.delivery_available {
                            self.viewModel.deliveryAvailableDays = deliveryAvailableDays
                            
                        }
                        if(self.viewModel.showPrice != "0") {
                            self.updateTotaPrice()
                        }
                        
                        if let deliveryCharge = getUserItemsData.delivery_charge {
                            self.viewModel.strDeliveryCharge = deliveryCharge
                        }
                        
                        if  let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) {
                            if(customerType as! String == "Retail Customer") {
                                if let showPickUp = getUserItemsData.show_pickup {
                                    if(showPickUp == 1) {
                                        if let radioButtonSelected = UserDefaults.standard.object(forKey:UserDefaultsKeys.selectedRadioButtonType)
                                        {
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
                            deliveryMessageLabel.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                            let strFullMessage = "Please call" + " " + self.viewModel.strContactNumber + " " + "to arrange a pick up time"
                            deliveryMessageLabel.text = strFullMessage
                        }
                        self.itemsTableView.dataSource = self
                        self.itemsTableView.delegate = self
                        self.itemsTableView.reloadData()
                    } else if(status == 2){
                        guard let messge = getUserItemsData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                    else {
                        self.itemsTableView.isHidden = true
                        self.addProductButton.isHidden = false
                        self.labelAddProduct.isHidden = false
                        self.categoryCollectionView.isHidden = true
                        self.viewOutlet.isHidden = true
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
    
    //Delete-Item
    func deleteItem(with param: [String: Any],deletedRowIndexPath:Int,itemCode:String) {
        viewModel.deleteItem(with: param, view: self.view, deletedRowIndexPath: deletedRowIndexPath, itemCode: itemCode) { result in
            switch result{
            case .success(let deletedItemData):
                if let deletedItemData = deletedItemData {
                    guard let status = deletedItemData.status else { return }
                    
                    if (status == 1) {
                        self.deleteSelectedItem(deletedRowIndexPath: deletedRowIndexPath,itemCode: itemCode)
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
    
    //Get Featured- Product
    private func getFeaturedProduct(with param: [String: Any]) {
        viewModel.getFeaturedProduct(with: param, view: self.view) { result in
            switch result {
            case .success(let featuredProductData):
                if let featuredProductData = featuredProductData {
                    guard let status = featuredProductData.status else { return }
                    
                    if (status == 1) {
                        DispatchQueue.main.async {
                            let strImage = featuredProductData.data?.image ?? ""
                            let strContent = featuredProductData.data?.content  ?? ""
                            let strSavedDate = featuredProductData.data?.date ?? ""
                            let strShow = featuredProductData.data?.show ?? ""
                            let strVisibility = featuredProductData.data?.visibility ?? ""
                            let strOnLaunch = featuredProductData.data?.on_launch ?? ""
                            let strOnLogin = featuredProductData.data?.on_login ?? ""
                            let strDateRes = UserDefaults.standard.object(forKey:UserDefaultsKeys.Date) as? String ?? ""
                            if(strOnLaunch == "1") {
                                if(strShow == "1"){
                                    DispatchQueue.main.async {
                                        let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                        featuredPopUpVC?.strHtmlContent = strContent
                                        featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                        self.present(featuredPopUpVC!, animated: false, completion: nil)
                                    }
                                } else {
                                }
                            }
                            if(strOnLogin == "0") {
                            }
                            else {
                                if(strSavedDate != strDateRes) {
                                    if(strShow == "1") {
                                        if(strVisibility == "1") {
                                            if(strContent == ""  && strImage == "") {
                                            } else {
                                                DispatchQueue.main.async {
                                                    let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                    featuredPopUpVC?.strHtmlContent = strContent
                                                    featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                    featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                    self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                }
                                            }
                                        }
                                        else {
                                            if(strContent == "") {
                                            }else {
                                                DispatchQueue.main.async {
                                                    let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                    featuredPopUpVC?.strHtmlContent = strContent
                                                    featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                    featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                    self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                }
                                            }
                                        }
                                    } else {
                                    }
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/YYYY"
                                    let currentDate = Date()
                                    let strCurrentDate = dateFormatter.string(from: currentDate)
                                    UserDefaults.standard.set(strCurrentDate, forKey:UserDefaultsKeys.CurrentDate)
                                    UserDefaults.standard.set(strSavedDate, forKey:UserDefaultsKeys.Date)
                                }
                                else {
                                    let currentDate = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrentDate) as? String ?? ""
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/YYYY"
                                    let strDate1 = dateFormatter.string(from: Date())
                                    if(strDate1 == currentDate) {
                                    } else {
                                        if(strShow == "1"){
                                            if(strVisibility == "1") {
                                                if (strContent == "" && strImage == "") {
                                                }
                                                else{
                                                    DispatchQueue.main.async {
                                                        let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                        featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                        featuredPopUpVC?.strHtmlContent = strContent
                                                        featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                        self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                    }
                                                }
                                            } else {
                                                if (strContent == "") {
                                                }
                                                else {
                                                    DispatchQueue.main.async {
                                                        let featuredPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPopUpViewController") as? FeaturedPopUpViewController
                                                        featuredPopUpVC?.view.backgroundColor = UIColor.clear
                                                        featuredPopUpVC?.strHtmlContent = strContent
                                                        featuredPopUpVC?.modalPresentationStyle = .overFullScreen
                                                        self.present(featuredPopUpVC!, animated: false, completion: nil)
                                                    }
                                                }
                                            }
                                        }
                                        UserDefaults.standard.set(strDate1, forKey:UserDefaultsKeys.CurrentDate)
                                    }
                                }
                            }
                        }
                    } else if(status == 2) {
                        guard let messge = featuredProductData.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                    else {
                        guard let messge = featuredProductData.message else {return}
                        self.presentPopUpVC(message:messge,title: "")
                    }                }
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
    
    //Update-Product-List
    private func updateProductList(with param: [String: Any]) {
        viewModel.updateProductList(with: param, view: self.view) { result in
            switch result{
            case .success(let deletedItemData):
                if let deletedItemData = deletedItemData {
                    guard let status = deletedItemData.status else { return }
                    
                    if (status == 1) {
                        if(self.viewModel.isComingFromReviewOrderButton) {
                            self.goToConfirmPaymentPage()
                        }
                        if(self.viewModel.isMenuButtonSelected){
                            self.viewModel.isMenuButtonSelected = false
                            if(self.viewModel.isLongPressGestureRecogized){
                                self.itemsTableView.reloadData()
                            }
                        }
                    } else if(status == 2){
                        if(self.viewModel.isMenuButtonSelected){
                            if(self.viewModel.isLongPressGestureRecogized == false) {
                            }
                        } else {
                            guard let messge = deletedItemData.message else {return}
                            self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                        }
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    //self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                } else {
                    if(self.viewModel.isMenuButtonSelected) {
                        if(self.viewModel.isLongPressGestureRecogized == false) {
                        }
                    } else {
                        //self.presentPopUpVC(message: serverNotResponding, title: "")
                    }
                }
            case .none:
                break
            }
        }
    }
}

//MARK:- Collection View Delegate and DataSource
extension DashBoardViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.arrItemsCategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell
        if let categoryName = self.viewModel.arrItemsCategoryData[indexPath.row].category_title {
            cell?.categoryLabel.text = categoryName.uppercased()
        }
        
        if(viewModel.selectedIndexPath ==  NSIndexPath(row: 0, section: 0))  {
            if(indexPath.item == 0)
            {
                cell?.categoryLabel.textColor = UIColor.white;
            }
            else {
                cell?.categoryLabel.textColor = UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0)
            }
        }
        
        else if (viewModel.selectedIndexPath as IndexPath == indexPath) {
            cell?.categoryLabel.textColor = UIColor.white;
        }
        
        else {
            cell?.categoryLabel.textColor =  UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0)
            
        }
        if(indexPath.item < viewModel.arrItemsCategoryData.count-1) {
            cell?.labelView.backgroundColor = UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0)
        } else {
            cell?.labelView.backgroundColor = UIColor.clear
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let categoryName = self.viewModel.arrItemsCategoryData[indexPath.row].category_title {
            let label = UILabel(frame: CGRect.zero)
            label.text = categoryName
            label.sizeToFit()
            if ((label.frame.size.width + 30) <= 101) {
                return CGSize(width:101 ,height:40);
            }else{
                return CGSize(width:label.frame.size.width+30,height:40)
            }
        }
        return CGSize(width:120,height:40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let arrData = viewModel.arrItemsCategoryData[indexPath.row].data {
            self.viewModel.arrItemsData = arrData
        }
        self.viewModel.indexPathCategory = indexPath.row
        self.viewModel.selectedIndexPath = indexPath as NSIndexPath
        itemsTableView.reloadData()
        categoryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK:- TEXT VIEW DELEGATES

extension DashBoardViewController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return textView.text.count + (text.count - range.length) <= 100
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

//MARK:- ScrollView Delegate
extension DashBoardViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.endEditing(true)
    }
}

//MARK:- PICKER VIEW DELEGATES AND DATA SOURCE
extension DashBoardViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.arrSuppliers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.selectSupplier = row
        self.viewModel.strSupplierNamePicker = self.viewModel.arrSuppliers[row]["supplier_name"] as? String ?? ""
        self.viewModel.strClientCodePicker = self.viewModel.arrSuppliers[row]["client_code"] as? String ?? ""
        self.viewModel.strUserCodePicker = self.viewModel.arrSuppliers[row]["user_code"] as? String ?? ""
        self.viewModel.isSelectOutlet = true
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.arrSuppliers[row]["supplier_name"] as? String ?? ""
    }
}

