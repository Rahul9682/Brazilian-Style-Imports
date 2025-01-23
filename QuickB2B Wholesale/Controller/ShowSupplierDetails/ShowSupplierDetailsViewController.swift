//  ShowSupplierDetailsViewController.swift
//  QuickB2BWholesale
//  Created by braintech on 21/07/21.

import UIKit

class ShowSupplierDetailsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var supplierCodeLabel: UILabel!
    @IBOutlet weak var supplierDetailsView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var supplierNameLabel: UILabel!
    
    //MARK:- Properties
    var strSupplierCode = ""
    var strSupplierName = ""
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        supplierCodeLabel.text = strSupplierCode
        supplierNameLabel.text = strSupplierName
    }
    
    override func viewDidLayoutSubviews() {
        configureUI()
    }
    
    //MARK:- Helpers
    private func configureUI() {
        closeButton.layer.cornerRadius = 5
        supplierDetailsView.layer.cornerRadius = 5
        supplierDetailsView.layer.borderWidth = 1
        supplierDetailsView.layer.borderColor = UIColor.black.cgColor
        supplierDetailsView.layer.shadowColor = UIColor.black.cgColor
        supplierDetailsView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        supplierDetailsView.layer.shadowOpacity = 0.5
        supplierDetailsView.layer.shadowRadius = 3.0
        supplierDetailsView.layer.masksToBounds = false
    }
    
    //MARK:- Button Action
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
