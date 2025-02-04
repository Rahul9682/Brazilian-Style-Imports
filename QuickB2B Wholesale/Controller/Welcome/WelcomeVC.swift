//  WelcomeVC.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/14/21.

import UIKit

class WelcomeVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var lblAppName: UILabel!
    @IBOutlet var lblApproval: UILabel!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblThankYouNew: UILabel!
    @IBOutlet var lblThankYou: UILabel!
    @IBOutlet var btnContinue: UIButton!
    
    //MARK: - Property
    var viewModel = WelcomeViewModel()
    
    //MARLK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helpers
    private func configureUI() {
        let appName = UserDefaults.standard.object(forKey: UserDefaultsKeys.AppName) as? String ?? ""
        lblAppName.text = appName
        btnContinue.layer.cornerRadius = 5.0;
        btnContinue.layer.borderWidth = 1.0
        btnContinue.layer.borderColor = UIColor.white.cgColor
        
        let customerType  = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        
        if(customerType == "Wholesale Customer") {
            lblThankYou.isHidden = true
            lblThankYouNew.isHidden = false
            lblApproval.isHidden = false
            lblDetails.isHidden = false
        } else {
            lblThankYou.isHidden = false
            lblThankYouNew.isHidden = true
            lblApproval.isHidden = true
            lblDetails.isHidden = true
        }
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
    }
    
    private func configureNavigation() {
        let customerType  = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if(customerType == "Wholesale Customer") {
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
            }
            UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.UserLoginID)
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegionViewController") as? RegionViewController else {return}
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
//            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController else {return}
//            UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
//            self.navigationController?.pushViewController(vc, animated: false)
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegionViewController") as? RegionViewController else {return}
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - ButtonAction
    @IBAction func btnContinue(_ sender: UIButton) {
        configureNavigation()
    }
}


