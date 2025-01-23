//  ManageSupplierViewController.swift
//  QuickB2BWholesale
//  Created by braintech on 21/07/21.

import UIKit

class ManageSupplierViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var manageSuppliersTableView: UITableView!
    @IBOutlet weak var addSuppliersButton: UIButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tabBarView: CustomTabBarView!
    @IBOutlet weak var specialTitlesContainerView: UIView!
    @IBOutlet weak var specialTitleLabel: UILabel!
    @IBOutlet weak var welcomeLabel: LightLabelSemiBoldSize18!
    
    //MARK: - Properties
    var viewModel = ManageSupplierViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureTabBar()
        configureUI()
        self.registerCustomCell()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - Helpers
    private func configureUI() {
        welcomeLabel.textColor = UIColor.MyTheme.welcomeColor
        appNameLabel.textColor = UIColor.MyTheme.appNameColor
        totalAmountLabel.textColor = UIColor.MyTheme.appNameColor
        specialTitlesContainerView.layer.cornerRadius = Radius.titleViewRadius
        specialTitleLabel.textColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        self.viewModel.arrSuppliers = viewModel.db.readData()
        self.manageSuppliersTableView.delegate = self
        self.manageSuppliersTableView.dataSource = self
        self.manageSuppliersTableView.backgroundColor = UIColor.white
        if  let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) {
            self.appNameLabel.text = appName as? String ?? ""
        }
    }
    
    private func configureTabBar() {
        let tabBar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
        tabBar?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tabBar?.frame = self.tabBarView.bounds
        
        tabBar?.didClickHomeButton = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            //vc.selectedTabIndex = 0
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickMyList = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
            //vc.selectedTabIndex = 1
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickProduct = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            //vc.selectedTabIndex = 2
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
            //vc.selectedTabIndex = 3
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.tabBarView.addSubview(tabBar!)
    }
    
    private func registerCustomCell(){
        manageSuppliersTableView.register(UINib(nibName: "ManageSuppliersTableViewCell", bundle: nil),forCellReuseIdentifier: "ManageSuppliersTableViewCell")
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func menuButton(_ sender: UIButton) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func addSupplierButton(_ sender: UIButton) {
        let supplierIdViewController = self.storyboard?.instantiateViewController(withIdentifier: "SupplierIdViewController") as? SupplierIdViewController
        supplierIdViewController?.viewModel.logoutString = "addSupplier"
        self.navigationController?.pushViewController(supplierIdViewController!, animated: false)
    }
}

//MARK: -> UITableViewDataSource,UITableViewDelegate
extension ManageSupplierViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrSuppliers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.manageSuppliersTableView.dequeueReusableCell(withIdentifier: "ManageSuppliersTableViewCell", for: indexPath) as? ManageSuppliersTableViewCell
        cell?.selectionStyle = .none
        cell?.contentView.backgroundColor = UIColor.white
        let strSupplierName = self.viewModel.arrSuppliers[indexPath.row]["supplier_name"] as? String ?? ""
        cell?.configureUI(with: strSupplierName)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strSupplierName = self.viewModel.arrSuppliers[indexPath.row]["supplier_name"]
        let strSupplierCode = self.viewModel.arrSuppliers[indexPath.row]["client_code"]
        let supplierDetailsPopUp = self.storyboard?.instantiateViewController(withIdentifier: "ShowSupplierDetailsViewController") as? ShowSupplierDetailsViewController
        supplierDetailsPopUp?.strSupplierName = strSupplierName as! String
        supplierDetailsPopUp?.strSupplierCode = strSupplierCode as! String
        supplierDetailsPopUp?.modalPresentationStyle = .overCurrentContext
        self.present(supplierDetailsPopUp!, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Are you sure you want to remove this supplier?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                let strSelectedSupplier = self.viewModel.arrSuppliers[indexPath.row]["client_code"] as? String ?? ""
                let strClientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                if(strSelectedSupplier == strClientCode) {
                    self.presentPopUpVC(message: "You can not delete your current supplier.", title: "")
                } else {
                    UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.UserLoginID)
                    UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.Date)
                    UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.ponumber)
                    UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.comment)
                    self.viewModel.db.deleteByClientCode(strClientCode: strSelectedSupplier)
                    self.viewModel.arrSuppliers = self.viewModel.db.readData()
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
                    self.manageSuppliersTableView.reloadData()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        })
        deleteAction.backgroundColor = UIColor.red
        return [ deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
