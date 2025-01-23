//  AccountViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit

class AccountViewController: UIViewController {
    
    //MARK: -> Outlet’s
    //Business-Details
    @IBOutlet weak var txtbussinessName: UITextField!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnBussinessSave: UIButton!
    @IBOutlet weak var txtCustomerId: UITextField!
    
    //Delivery-Address
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnDeliverySave: UIButton!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtDelivery: UITextField!
    @IBOutlet weak var btnDeliveryCountry: UIButton!
    
    //Postal Address
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtSuburb2: UITextField!
    @IBOutlet weak var txtPostCode2: UITextField!
    @IBOutlet weak var btnBillingCountry: UIButton!
    @IBOutlet weak var btnBillingDetailsSave: UIButton!
    @IBOutlet weak var txtBillingCountry: UITextField!
    @IBOutlet weak var bottomSaveBtn: UIButton!
    
    //Change Password
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    //MARK: -> Properties
    //    var viewModel = EditProfileModelViewModel(userId: "", contactName: "", businessName: "", mobile: "", email: "", phone: "", address: "", addressUrb: "", postCode: "", state: "", postalAddress: "", postalAddresSubUrb: "", PostalPostCode: "", postalState: "")
    //
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBusinessTextField(isEnable: false)
        configureDeliveryTextField(isEnable: false)
        configureBillingDetailsTextField(isEnable: false)
    }
    
    //MARK: -> Helpers
    private func configureUI() {
        btnBussinessSave.layer.cornerRadius = btnBussinessSave.frame.size.height/2;
        btnDeliverySave.layer.cornerRadius = btnDeliverySave.frame.size.height/2;
        btnBillingDetailsSave.layer.cornerRadius = btnBillingDetailsSave.frame.size.height/2;
        bottomSaveBtn.layer.cornerRadius = 4
    }
        
    private func configureBusinessTextField(isEnable: Bool) {
        txtbussinessName.isUserInteractionEnabled = isEnable
        txtContactName.isUserInteractionEnabled = isEnable
        txtPhone.isUserInteractionEnabled = isEnable
        txtMobile.isUserInteractionEnabled = isEnable
        txtEmail.isUserInteractionEnabled = isEnable
        txtPhone.isUserInteractionEnabled = isEnable
        txtCustomerId.isUserInteractionEnabled = isEnable
        
        if isEnable {
            txtbussinessName.borderStyle = .bezel
            txtContactName.borderStyle = .bezel
            txtPhone.borderStyle = .bezel
            txtMobile.borderStyle = .bezel
            txtEmail.borderStyle = .bezel
            txtCustomerId.borderStyle = .bezel
            btnBussinessSave.isHidden = false
            txtbussinessName.alpha = 1
            txtContactName.alpha = 1
            txtPhone.alpha = 1
            txtMobile.alpha = 1
            txtCustomerId.alpha = 1
            txtEmail.alpha = 1
        } else {
            txtbussinessName.alpha = 0.5
            txtbussinessName.borderStyle = .none
            txtContactName.borderStyle = .none
            txtPhone.borderStyle = .none
            txtMobile.borderStyle = .none
            txtEmail.borderStyle = .none
            txtCustomerId.borderStyle = .none
            btnBussinessSave.isHidden = true
            txtbussinessName.alpha = 0.5
            txtContactName.alpha = 0.5
            txtPhone.alpha = 0.5
            txtMobile.alpha = 0.5
            txtCustomerId.alpha = 0.5
            txtEmail.alpha = 0.5
        }
    }
    
    private func configureDeliveryTextField(isEnable: Bool) {
        txtAddress.isUserInteractionEnabled = isEnable
        txtSuburb.isUserInteractionEnabled = isEnable
        txtPostCode.isUserInteractionEnabled = isEnable
        
        if isEnable {
            txtAddress.borderStyle = .bezel
            txtSuburb.borderStyle = .bezel
            txtState.borderStyle = .bezel
            txtPostCode.borderStyle = .bezel
            txtDelivery.borderStyle = .bezel
            btnDeliverySave.isHidden = false
            txtAddress.alpha = 1
            txtSuburb.alpha = 1
            txtPostCode.alpha = 1
            txtState.alpha = 1
            txtDelivery.alpha = 1
            btnState.isUserInteractionEnabled = true
            
        } else {
            txtAddress.borderStyle = .none
            txtSuburb.borderStyle = .none
            txtState.borderStyle = .none
            txtPostCode.borderStyle = .none
            txtDelivery.borderStyle = .none
            btnDeliverySave.isHidden = true
            txtAddress.alpha = 0.5
            txtSuburb.alpha = 0.5
            txtPostCode.alpha = 0.5
            txtState.alpha = 0.5
            txtDelivery.alpha = 0.5
            btnState.isUserInteractionEnabled = false
        }
    }
    
    private func configureBillingDetailsTextField(isEnable: Bool) {
        txtAddress2.isUserInteractionEnabled = isEnable
        txtSuburb2.isUserInteractionEnabled = isEnable
        txtPostCode2.isUserInteractionEnabled = isEnable
        if isEnable {
            txtAddress2.borderStyle = .bezel
            txtSuburb2.borderStyle = .bezel
            txtPostCode2.borderStyle = .bezel
            txtBillingCountry.borderStyle = .bezel
            btnBillingDetailsSave.isHidden = false
            txtAddress2.alpha = 1
            txtSuburb2.alpha = 1
            txtPostCode2.alpha = 1
            txtBillingCountry.alpha = 1
        } else {
            txtAddress2.borderStyle = .none
            txtSuburb2.borderStyle = .none
            txtPostCode2.borderStyle = .none
            txtBillingCountry.borderStyle = .none
            btnBillingDetailsSave.isHidden = true
            txtAddress2.alpha = 0.5
            txtSuburb2.alpha = 0.5
            txtPostCode2.alpha = 0.5
            txtBillingCountry.alpha = 0.5
        }
    }
    
    //MARK: -> Button Actions
    
    @IBAction func btnState(_ sender: UIButton) {
    }
    
    @IBAction func btnBillingDetailsSave(_ sender: UIButton) {
    }
    
    @IBAction func btnBussinessEdit(_ sender: UIButton) {
        configureBusinessTextField(isEnable: true)
    }
    
    @IBAction func btnDeliveryEdit(_ sender: UIButton) {
        configureDeliveryTextField(isEnable: true)
    }
    
    @IBAction func btnDeliveryCountry(_ sender: UIButton) {
    }
    
    @IBAction func btnBussinessSave(_ sender: UIButton) {
        //updateBusinessDetails()
    }
    
    @IBAction func btnDeliverySave(_ sender: UIButton) {
        //updateDeliveryDetails()
    }
    
    @IBAction func btnBillingDetailsEdit(_ sender: UIButton) {
        configureBillingDetailsTextField(isEnable: true)
    }
    
    @IBAction func bottomSaveBtn(_ sender: UIButton) {
    }
}
