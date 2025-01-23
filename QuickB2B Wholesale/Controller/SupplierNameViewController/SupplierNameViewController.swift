//  SupplierNameViewController.swift
//  QuickB2BWholesale
//Created by Sazid Saifi on 20/07/21.

import UIKit

class SupplierNameViewController: UIViewController {
    
    //MARK:- outlets
    @IBOutlet weak var supplierNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Properties
    var logOutStr = ""
    
    //MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:- Helpers
    private func configureUI() {
        if let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) {
            supplierNameLabel.text = appName as? String ?? ""
        }
    }
    
    private func configureNavigation() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        if(logOutStr == "addSupplier"){
            loginVC?.viewModel.logoutString = "addSupplier"
        } else if(logOutStr ==  "logout"){
            loginVC?.viewModel.logoutString = "logout"
        }
        self.navigationController?.pushViewController(loginVC!, animated: false)
    }
    
    //MARK:- Button Action
    @IBAction func continueButton(_ sender: UIButton) {
        configureNavigation()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
