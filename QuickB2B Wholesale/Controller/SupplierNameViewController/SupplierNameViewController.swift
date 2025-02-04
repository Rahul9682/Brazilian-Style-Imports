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
    var selectedRegionIndex:Int?
    var selectedRegion:ClientRegion?
    
    //MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:- Helpers
    private func configureUI() {
        supplierNameLabel.text = self.selectedRegion?.companyName
    }
    
    private func configureNavigation() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            vc.selectedRegionName = self.selectedRegion?.companyName
            vc.selectedRegionIndex = self.selectedRegionIndex
            vc.selectedRegionCode = self.selectedRegion?.clientCode
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK:- Button Action
    @IBAction func continueButton(_ sender: UIButton) {
        configureNavigation()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
