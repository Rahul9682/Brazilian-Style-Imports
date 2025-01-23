//  SupplierIdVC.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 4/13/21.

import UIKit

class SupplierIdVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var navigationView: UIView!
    @IBOutlet var supplierTextField: UITextField!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        supplierTextField.addShadoww(placeHolderText: "enter supplier id")
    }
    
    //MARK: - Button Action
    @IBAction func continueButton(_ sender: UIButton) {
    }
    
    @IBAction func backButton(_ sender: UIButton) {
    }
}
