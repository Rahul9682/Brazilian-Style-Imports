//  CommonSearchViewController.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 06/07/23.

import UIKit

class CommonSearchViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var searchcontainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButtonWidthConst: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonContainerView: UIView!
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var tabbarView: CustomTabBarView!
    
    //MARK: -> Properties
    var searchUserText = ""
    var tabType: TabType = .none
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        confifureUI()
    }
    
    //MARK: -> Helpers
    private func confifureUI() {
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        appNameLabel.text = appName
        searchTextField.becomeFirstResponder()
        searchcontainerView.layer.cornerRadius = Radius.searchViewRadius
        searchcontainerView.layer.borderWidth = Radius.searchViewborderWidth
        searchcontainerView.layer.borderColor = UIColor.MyTheme.searchViewBorderColor.cgColor
        cancelButtonContainerView.isHidden = true
        cancelButtonWidthConst.constant = 0
        searchTextField.delegate = self
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "SEARCH ALL PRODUCTS",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.MyTheme.searchPlaceHolderColor]
        )
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
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MyListViewController") as! MyListViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        tabBar?.didClickProduct = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
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
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.tabbarView.addSubview(tabBar!)
    }
    
    //MARK: -> Button Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        searchTextField.text = ""
        searchUserText = ""
    }
    
    @IBAction func searchTextChange(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.searchUserText = text
        let vc = ProductsViewController()
        vc.searchUserText = searchUserText
        if text.count > 0 {
            cancelButtonContainerView.isHidden = false
            cancelButtonWidthConst.constant = 20
        } else {
            cancelButtonContainerView.isHidden = true
            cancelButtonWidthConst.constant = 0
        }
    }
}

//MARK: -> UITextFieldDelegate
extension CommonSearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchUserText.count > 0 {
            UserDefaults.standard.setValue(searchUserText, forKey: UserDefaultsKeys.CommonSearchText)
            print("TextField did end editing method called\(textField.text!)")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            //tbc.selectedTabIndex = 2
            self.navigationController?.pushViewController(tbc, animated: false)
        }
    }
}
