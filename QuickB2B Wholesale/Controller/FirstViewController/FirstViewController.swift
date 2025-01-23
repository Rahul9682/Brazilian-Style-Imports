//  FirstViewController.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/14/21.

import UIKit

class FirstViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var itemsTableView: UITableView!
    
    //MARK: - Properties
    var viewModel = FirstViewModel()
    
    //MARK: - LifeCycle  Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCustomCell()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.viewModel.arrSuppliers = viewModel.db.readData()
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        appNameLabel.text = appName
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        let dictParam = [
            GetCategoryData.type.rawValue:KeyConstants.appType ,
            GetCategoryData.user_code.rawValue:userID,
            GetCategoryData.client_code.rawValue:KeyConstants.clientCode ,
        ]
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        getCategories(with: dictParam)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - Register Custom Cell Method
    private func registerCustomCell() {
        itemsTableView.register(UINib.init(nibName: "SearchProductHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchProductHeaderTableViewCell")
        itemsTableView.register(UINib.init(nibName: "SearchProductTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchProductTableViewCell")
        itemsTableView.register(UINib.init(nibName: "SearchProductHeaderItemTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchProductHeaderItemTableViewCell")
    }
    
    //MARK: - Show Item Data Method
    func showItemData(row:Int) {
        var itemCode = ""
        var itemName = ""
        var itemDescription = ""
        var imageUrl = ""
        if(viewModel.isSearchSectionExpanded) {
            itemCode = self.viewModel.searchProductData[row].item_code ?? ""
            itemName = self.viewModel.searchProductData[row].item_name ?? ""
            itemDescription = viewModel.searchProductData[row].image_description ?? ""
            imageUrl = self.viewModel.searchProductData[row].image ?? ""
        } else {
            itemCode = self.viewModel.arrItemsCategoryData[row].item_code ?? ""
            itemName = self.viewModel.arrItemsCategoryData[row].item_name ?? ""
            itemDescription = viewModel.arrItemsCategoryData[row].image_description ?? ""
            imageUrl = self.viewModel.arrItemsCategoryData[row].image ?? ""
        }
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowItemDataViewController") as? ShowItemDataViewController else  {return}
        vc.viewModel.itemCode = itemCode
        vc.viewModel.imgUrl = imageUrl
        vc.viewModel.itemName = itemName
        vc.viewModel.itemDescription = itemDescription
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
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
    
    //MARK: - BUTTON ACTION
    @IBAction func menuButton(_ sender: UIButton) {
        self.view.endEditing(true)
        UserDefaults.standard.set(false, forKey: "isComingFromDashboard")
        self.findHamburguerViewController()?.showMenuViewController()
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension FirstViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrCategory.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section != 0) {
            if self.viewModel.arrCategory[section-1].isExpanded{
                return  self.viewModel.arrItemsCategoryData.count
            }
            return 0
        } else {
            if(viewModel.isSearchSectionExpanded) {
                return self.viewModel.searchProductData.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductTableViewCell") as! SearchProductTableViewCell
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        cell.btnShowItemData = {
            self.showItemData(row: indexPath.row)
        }
        if(viewModel.isSearchSectionExpanded) {
            if let itemName = self.viewModel.searchProductData[indexPath.row].item_name {
                cell.itemsToAddLabel.text = itemName
            }
            cell.addToListButton.tag = indexPath.row
            cell.btnAddItemToList = {
                cell.addToListButton.setTitleColor(UIColor.red, for: .normal)
                var appType = ""
                if (customerType == "Wholesale Customer") {
                    appType = KeyConstants.app_TypeDual
                } else {
                    appType = KeyConstants.app_TypeRetailer
                }
                
                var dictParam = [String:Any]()
                let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                if let itemCode = self.viewModel.searchProductData[indexPath.row].item_code {
                    dictParam = [
                        AddProduct.type.rawValue:KeyConstants.appType ,
                        AddProduct.app_type.rawValue:appType,
                        AddProduct.client_code.rawValue:KeyConstants.clientCode ,
                        AddProduct.user_code.rawValue:userID ,
                        AddProduct.item_code.rawValue:itemCode
                    ]
                    self.addProduct(with: dictParam) { (result) -> () in
                        cell.addToListButton.setTitleColor(UIColor.white, for: .normal)
                        print(result)
                    }
                }
            }
        } else {
            if let itemName = self.viewModel.arrItemsCategoryData[indexPath.row].item_name {
                cell.itemsToAddLabel.text = itemName
            }
            cell.addToListButton.tag = indexPath.row
            cell.btnAddItemToList = {
                cell.addToListButton.setTitleColor(UIColor.red, for: .normal)
                var appType = ""
                if (customerType == "Wholesale Customer") {
                    appType = KeyConstants.app_TypeDual
                } else {
                    appType = KeyConstants.app_TypeRetailer
                }
                
                var dictParam = [String:Any]()
                let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                if let itemCode = self.viewModel.arrItemsCategoryData[indexPath.row].item_code {
                    dictParam = [
                        AddProduct.type.rawValue:KeyConstants.appType ,
                        AddProduct.app_type.rawValue:appType,
                        AddProduct.client_code.rawValue:KeyConstants.clientCode ,
                        AddProduct.user_code.rawValue:userID ,
                        AddProduct.item_code.rawValue:itemCode
                    ]
                    self.addProduct(with: dictParam) { (result) -> () in
                        cell.addToListButton.setTitleColor(UIColor.white, for: .normal)
                        print(result)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section == 0) {
            let header = tableView.dequeueReusableCell(withIdentifier: "SearchProductHeaderTableViewCell") as! SearchProductHeaderTableViewCell
            header.contentView.backgroundColor = UIColor.MyTheme.customColor1
            header.searchTextField.layer.cornerRadius = header.searchTextField.frame.size.height/2
            header.searchTextField.addPadding()
            header.searchTextField.text = viewModel.strSearchText
            header.searchTextField.delegate = self
            header.searchTextField.addTarget(self, action: #selector(FirstViewController.textFieldDidChange(_:)),
                                             for: .editingChanged)
            header.btnSearchItem = { [self] in
                self.view.endEditing(true)
                
                if(header.searchTextField.text  == "" || viewModel.isSearchSectionExpanded == true) {
                    self.viewModel.searchProductData.removeAll()
                    itemsTableView.reloadData()
                    if(viewModel.isSearchSectionExpanded == false){
                        self.presentPopUpVC(message:"Please enter search",title: "")
                    }
                    viewModel.isSearchSectionExpanded = false
                    
                } else  {
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
                    guard let searchTxt = header.searchTextField.text else  {return}
                    dictParam = [
                        SearchProductDetails.type.rawValue:KeyConstants.appType ,
                        SearchProductDetails.app_type.rawValue:appType,
                        SearchProductDetails.client_code.rawValue:KeyConstants.clientCode ,
                        SearchProductDetails.user_code.rawValue:userID ,
                        SearchProductDetails.search.rawValue:searchTxt,
                        SearchProductDetails.page.rawValue:"1",
                    ]
                    self.searchProductDetails(with: dictParam)
                    
                }
            }
            
            return header
        } else {
            let header = tableView.dequeueReusableCell(withIdentifier: "SearchProductHeaderItemTableViewCell") as! SearchProductHeaderItemTableViewCell
            if let itemName = self.viewModel.arrCategory[section - 1].name {
                header.itemsLabel.text = itemName
            }
            header.expandRowButton.tag = section - 1
            if(section % 2 == 0) {
                header.contentView.backgroundColor = UIColor.MyTheme.customColor1
            } else {
                header.contentView.backgroundColor = UIColor.MyTheme.customColor2
            }
            header.btnExpandRow = { [self] in
                self.viewModel.searchProductData.removeAll()
                viewModel.isSearchSectionExpanded = false
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
                if let categoryID = self.viewModel.arrCategory[section - 1].id  {
                    dictParam = [
                        GetItemsByCategoryData.type.rawValue:KeyConstants.appType ,
                        GetItemsByCategoryData.app_type.rawValue:appType,
                        GetItemsByCategoryData.client_code.rawValue:KeyConstants.clientCode ,
                        GetItemsByCategoryData.user_code.rawValue:userID ,
                        GetItemsByCategoryData.category_id.rawValue:categoryID
                    ]
                    
                    for i in 0..<viewModel.arrCategory.count {
                        if(header.expandRowButton.tag == i) {
                            if self.viewModel.arrCategory[i].isExpanded{
                                
                                self.viewModel.arrCategory[i].isExpanded = false
                            }else{
                                self.getItemsByCategory(with: dictParam)
                                self.viewModel.arrCategory[i].isExpanded = true
                            }
                        } else {
                            self.viewModel.arrCategory[i].isExpanded = false
                        }
                    }
                    itemsTableView.reloadData()
                }
            }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //MARK: - TEXT FIELD ACTION
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.strSearchText = textField.text ?? ""
        if(viewModel.strSearchText != "") {
            viewModel.isSearchSectionExpanded = false
        }
    }
}

//MARK: - PopUpDelegate
extension FirstViewController:PopUpDelegate {
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
}

//MARK: - UITextFieldDelegate
extension FirstViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string != ""){
            viewModel.isSearchSectionExpanded = false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.itemsTableView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.itemsTableView.reloadData()
        return true
    }
}

// MARK:- API Integration
extension FirstViewController {
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
                            self.viewModel.arrCategory = arrCategoryData
                            print(self.viewModel.arrCategory)
                            self.itemsTableView.reloadData()
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
    
    //Search-Product-Details
    private func searchProductDetails(with param: [String: Any]) {
        viewModel.searchProductDetails(with: param, view: self.view) { result in
            switch result{
            case .success(let searchProductData):
                if let searchProductData = searchProductData {
                    
                    guard let status = searchProductData.status  else { return }
                    
                    if (status == 1) {
                        if let searchProductData = searchProductData.data {
                            print(searchProductData)
                            self.viewModel.searchProductData = searchProductData
                            self.viewModel.arrItemsCategoryData.removeAll()
                            for i in 0..<self.viewModel.arrCategory.count {
                                self.viewModel.arrCategory[i].isExpanded = false
                            }
                            self.viewModel.isSearchSectionExpanded = true
                            self.itemsTableView.reloadData()
                            
                        }
                    } else if(status == 2 ){
                        guard let messge = searchProductData.message else {return}
                        self.presentPopUpWithDelegate(strMessage:messge , buttonTitle: "OK")
                    }
                    else {
                        self.viewModel.searchProductData.removeAll()
                        self.viewModel.isSearchSectionExpanded = false
                        self.itemsTableView.reloadData()
                        guard let messge = searchProductData.message else {return}
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
    
    //get-ItemsBy-Category
    private func getItemsByCategory(with param: [String: Any]) {
        viewModel.getItemsByCategory(with: param, view: self.view) { result in
            switch result {
            case .success(let searchItemsByCategoryData):
                if let searchItemsByCategoryData = searchItemsByCategoryData {
                    guard let status = searchItemsByCategoryData.status  else { return }
                    if (status == 1) {
                        if let arrCategoryData = searchItemsByCategoryData.data {
                            print(arrCategoryData)
                            
                            var searchItemsData:SearchItemsByCategoryData?
                            self.viewModel.arrItemsCategoryData.removeAll()
                            for i in arrCategoryData {
                                //searchItemsData.id = i.id
                                searchItemsData?.item_code = i.item_code
                                searchItemsData?.item_name = i.item_name
                                searchItemsData?.item_price = i.item_price
                                searchItemsData?.status = i.status
                                searchItemsData?.image_description = i.image_description
                                searchItemsData?.image = i.image
                                searchItemsData?.thumb_image = i.thumb_image
                            }
                            
                            if let searchItemsData = searchItemsData {
                                self.viewModel.arrItemsCategoryData.append(searchItemsData)
                            }
                            print(self.viewModel.arrCategory)
                            self.itemsTableView.reloadData()
                        }  }else if(status == 2 ) {
                            guard let messge = searchItemsByCategoryData.message else {return}
                            self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "OK")
                        }
                    else {
                        self.viewModel.arrItemsCategoryData.removeAll()
                        self.itemsTableView.reloadData()
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
    
    //Add-Product
    private func addProduct(with param: [String: Any] , completion: @escaping (Bool)->()) {
        viewModel.addProduct(with: param, view: self.view) { result in
            switch result{
            case .success(let addProductData):
                if let addProductData = addProductData {
                    completion(true)
                    guard let status = addProductData.status  else { return }
                    if (status == 1) {
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
}
