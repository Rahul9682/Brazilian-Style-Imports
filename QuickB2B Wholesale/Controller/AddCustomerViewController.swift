//
//  AddCustomerViewController.swift
//  QuickB2B
//
//  Created by Mohammad Kaif on 05/12/24.
//

import UIKit
import UITextView_Placeholder
import SwiftyJSON

class AddCustomerViewController: UIViewController, PopUpDelegate {
    func didTapDone() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Outlets
    @IBOutlet var radioButtonBusiness: UIButton!
    @IBOutlet var radioButtonHomeDelivery: UIButton!
    @IBOutlet var btnCheckPostAddressSameDelieveryAddress: UIButton!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var forBusinessLabel: UILabel!
    @IBOutlet var forHomeDeliveryLabel: UILabel!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var businessNameTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var delieveryAddressNumberTextField: UITextField!
    @IBOutlet var deliverySuburbTextField: UITextField!
    @IBOutlet var deliveryCountryTextField: UITextField!
    @IBOutlet var deliveryStateTextField: UITextField!
    @IBOutlet var deliveryPostCodeTextField: UITextField!
    @IBOutlet var postalNumberTextField: UITextField!
    @IBOutlet var postalSubUrbTextField: UITextField!
    @IBOutlet var postalCountry: UITextField!
    @IBOutlet var postalState: UITextField!
    @IBOutlet var postalPostCode: UITextField!
    @IBOutlet var delieveryAddressLabel: UILabel!
    @IBOutlet var postalAddressLabel: UILabel!
    @IBOutlet var textViewInstructions: UITextView!
    @IBOutlet var viewPostalAddress: UIView!
    @IBOutlet var viewBusinessHomeDeliveryHeightConst: NSLayoutConstraint!
    @IBOutlet var txtViewInstructionsHeightConst: NSLayoutConstraint!
    @IBOutlet var viewPostalAddressHeightConst: NSLayoutConstraint!
    @IBOutlet var businessNameTopConst: NSLayoutConstraint!
    @IBOutlet var businessNameHeightConst: NSLayoutConstraint!
    
    //MARK: - Properties
    var viewModel = CreateAnAccountViewModel()
    var acmCode  = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID)
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.isPostalAddressSame = false
        submitButton.layer.cornerRadius = 4
        if acmCode != nil && !acmCode!.isEmpty {
            submitButton.setTitle("SUBMIT & APPROVE", for: .normal)
        } else {
            submitButton.setTitle("SUBMIT", for: .normal)
        }
        self.viewModel.arrSuppliers = viewModel.db.readData()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        
        let dictParam = [
            GetAppData.type.rawValue:KeyConstants.appType ,
            GetAppData.app_type.rawValue:KeyConstants.app_Type,
            GetAppData.client_code.rawValue:KeyConstants.clientCode,
            GetAppData.device_id.rawValue:Constants.deviceId]
        viewModel.deliveryType = .Business
        print(JSON(dictParam))
        getAppData(with: dictParam)
        configureUIAccToDeliveryType()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - TAP GESTURE METHOD
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func radioButtonBusiness(_ sender: UIButton) {
        viewModel.deliveryType = .Business
        configureUIAccToDeliveryType()
    }
    
    @IBAction func radioButtonHomeDelivery(_ sender: UIButton) {
        viewModel.deliveryType = .HomeDelivery
        configureUIAccToDeliveryType()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCheckPostalAddressSameAsDeliveryAddress(_ sender: UIButton) {
        if(viewModel.isPostalAddressSame) {
            configurePostalAddress()
            viewModel.isPostalAddressSame = false
        } else {
            configurePostalAddress()
            viewModel.isPostalAddressSame = true
        }
    }
    
    @IBAction func sumitButton(_ sender: UIButton) {
        if(validation()){
            let strEmail = emailTextField.text ?? ""
            let strBusinessName = businessNameTextField.text ?? ""
            let strUserName = userNameTextField.text ??  ""
            let strFirstName = firstNameTextField.text ??  ""
            let strLastName = lastNameTextField.text ??  ""
            let strPassword = passwordTextField.text ?? ""
            let strPhoneNO = phoneTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let strMobile = mobileTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let strDeliveryAddress = delieveryAddressNumberTextField.text  ?? ""
            let strDeliverySuburb = deliverySuburbTextField.text  ?? ""
            let strDeliveryPostCode = deliveryPostCodeTextField.text  ?? ""
            let strDeliveryState = deliveryStateTextField.text  ?? ""
            let strDeliveryCountry = deliveryCountryTextField.text  ?? ""
            let strPostalAddress = postalNumberTextField.text ?? ""
            let strPostalSuburb = postalSubUrbTextField.text  ?? ""
            let strPostalPostCode = postalPostCode.text ?? ""
            let strPostalState = postalState.text ??  ""
            let strPostalCountry = postalCountry.text ?? ""
            let strDeliveryInstructions = textViewInstructions.text  ?? ""
            
            var dictParam = [String:Any]()
            let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
            if(viewModel.deliveryType == .Business) {
                dictParam = [
                    Signup.type.rawValue:KeyConstants.appType ,
                    Signup.app_type.rawValue:KeyConstants.app_TypeDual,
                    Signup.client_code.rawValue:KeyConstants.clientCode,
                    Signup.email.rawValue:strEmail,
                    Signup.password.rawValue:strPassword,
                    Signup.business_name.rawValue:strBusinessName,
                    Signup.customer_code.rawValue:strUserName,
                    Signup.first_name.rawValue:strFirstName,
                    Signup.last_name.rawValue:strLastName,
                    Signup.phone.rawValue:strPhoneNO,
                    Signup.mobile.rawValue:strMobile,
                    Signup.delivery_address.rawValue:strDeliveryAddress,
                    Signup.delivery_suburb.rawValue:strDeliverySuburb,
                    Signup.delivery_state.rawValue:strDeliveryState,
                    Signup.delivery_country.rawValue:strDeliveryCountry,
                    Signup.delivery_post_code.rawValue:strDeliveryPostCode,
                    Signup.postal_address.rawValue:strPostalAddress,
                    Signup.postal_suburb.rawValue:strPostalSuburb,
                    Signup.postal_state.rawValue:strPostalState,
                    Signup.postal_country.rawValue:strPostalCountry,
                    Signup.postal_post_code.rawValue:strPostalPostCode,
                    Signup.device_type.rawValue:"I",
                    Signup.device_id.rawValue: Constants.deviceId,
                    Signup.acm_code.rawValue: acmCode
                ]
            } else {
                dictParam = [
                    Signup.type.rawValue:KeyConstants.appType ,
                    Signup.app_type.rawValue:KeyConstants.app_TypeRetailer,
                    Signup.client_code.rawValue:KeyConstants.clientCode,
                    Signup.password.rawValue:strPassword,
                    Signup.email.rawValue:strEmail,
                    Signup.business_name.rawValue:"",
                    Signup.customer_code.rawValue:strUserName,
                    Signup.first_name.rawValue:strFirstName,
                    Signup.last_name.rawValue:strLastName,
                    Signup.phone.rawValue:strPhoneNO,
                    Signup.mobile.rawValue:strMobile,
                    Signup.delivery_address.rawValue:strDeliveryAddress,
                    Signup.delivery_suburb.rawValue:strDeliverySuburb,
                    Signup.delivery_state.rawValue:strDeliveryState,
                    Signup.delivery_country.rawValue:strDeliveryCountry,
                    Signup.delivery_post_code.rawValue:strDeliveryPostCode,
                    Signup.delivery_note.rawValue:strDeliveryInstructions,
                    Signup.postal_address.rawValue:"",
                    Signup.postal_suburb.rawValue:"",
                    Signup.postal_state.rawValue:"",
                    Signup.postal_country.rawValue:"",
                    Signup.postal_post_code.rawValue:"",
                    Signup.device_type.rawValue:"I",
                    Signup.acm_code.rawValue: acmCode
                ]
            }
            print(JSON(dictParam))
            signUp(with: dictParam)
        }
    }
    
    //MARK: - CONFIGURE METHODS
    private func configurePostalAddress() {
        if(viewModel.isPostalAddressSame) {
            btnCheckPostAddressSameDelieveryAddress.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            postalNumberTextField.text = ""
            postalSubUrbTextField.text = ""
            postalCountry.text = ""
            postalState.text = ""
            postalPostCode.text = ""
        } else {
            btnCheckPostAddressSameDelieveryAddress.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
            postalNumberTextField.text = delieveryAddressNumberTextField.text
            postalSubUrbTextField.text = deliverySuburbTextField.text
            postalCountry.text = deliveryCountryTextField.text
            postalState.text = deliveryStateTextField.text
            postalPostCode.text = deliveryPostCodeTextField.text
        }
    }
    
    private func configureUI() {
        submitButton.layer.cornerRadius = 4
        userNameTextField.delegate  = self;
        passwordTextField.delegate = self;
        confirmPasswordTextField.delegate = self;
        businessNameTextField.delegate = self;
        firstNameTextField.delegate = self;
        lastNameTextField.delegate = self;
        phoneTextField.delegate = self;
        mobileTextField.delegate = self;
        emailTextField.delegate = self;
        
        userNameTextField.autocapitalizationType = .sentences
        businessNameTextField.autocapitalizationType = .sentences
        firstNameTextField.autocapitalizationType = .sentences
        lastNameTextField.autocapitalizationType = .sentences
        delieveryAddressNumberTextField.autocapitalizationType = .sentences
        deliverySuburbTextField.autocapitalizationType = .sentences
        deliveryCountryTextField.autocapitalizationType = .sentences
        deliveryStateTextField.autocapitalizationType = .sentences
        postalNumberTextField.autocapitalizationType = .sentences
        postalSubUrbTextField.autocapitalizationType = .sentences
        postalState.autocapitalizationType = .sentences
        postalCountry.autocapitalizationType = .sentences
        postalPostCode.autocapitalizationType = .sentences
        deliveryPostCodeTextField.autocapitalizationType = .sentences
        // selectRegionTextfield.autocapitalizationType = .sentences
        
        delieveryAddressNumberTextField.delegate = self;
        deliverySuburbTextField.delegate = self;
        deliveryCountryTextField.delegate = self;
        deliveryStateTextField.delegate = self;
        
        postalNumberTextField.delegate = self;
        postalSubUrbTextField.delegate = self;
        postalState.delegate = self;
        postalCountry.delegate = self;
        postalPostCode.delegate = self;
        deliveryPostCodeTextField.delegate = self;
        
        userNameTextField.addPlaceHolderText(placeHolderText: "Customer ID")
        passwordTextField.addPlaceHolderText(placeHolderText: "Password")
        confirmPasswordTextField.addPlaceHolderText(placeHolderText: "Confirm Password")
        firstNameTextField.addPlaceHolderText(placeHolderText: "First Name")
        lastNameTextField.addPlaceHolderText(placeHolderText: "Last Name")
        businessNameTextField.addPlaceHolderText(placeHolderText: "Business Name")
        phoneTextField.addPlaceHolderText(placeHolderText: "Phone")
        mobileTextField.addPlaceHolderText(placeHolderText: "Mobile")
        emailTextField.addPlaceHolderText(placeHolderText: "Email")
        delieveryAddressNumberTextField.addPlaceHolderText(placeHolderText: "Number/Street")
        deliverySuburbTextField.addPlaceHolderText(placeHolderText: "Suburb/City")
        deliveryPostCodeTextField.addPlaceHolderText(placeHolderText: "Postcode/Zip")
        deliveryCountryTextField.addPlaceHolderText(placeHolderText: "Country")
        deliveryStateTextField.addPlaceHolderText(placeHolderText: "State/Region")
        postalNumberTextField.addPlaceHolderText(placeHolderText: "Number/Street")
        postalSubUrbTextField.addPlaceHolderText(placeHolderText: "Suburb/City")
        postalPostCode.addPlaceHolderText(placeHolderText: "Postcode/Zip")
        postalCountry.addPlaceHolderText(placeHolderText: "Country")
        postalState.addPlaceHolderText(placeHolderText: "State/Region")
        textViewInstructions.addPlaceHolderText(placeHolderText: "Delivery Instructions")
        btnCheckPostAddressSameDelieveryAddress.addBorder()
    }
    
    //MARK: - VALIDATION
    private func validation() -> Bool {
        let userName = userNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let businessName = businessNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let mobile = mobileTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let deliveryNumber = delieveryAddressNumberTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let deliverySuburb = deliverySuburbTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let deliveryCountry = deliveryCountryTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let deliveryState = deliveryStateTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let deliveryPostCode = deliveryPostCodeTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let deliveryInstructions = textViewInstructions.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let postalNumber = postalNumberTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let postalSuburb = postalSubUrbTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let postalCountry = self.postalCountry.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let postalState = self.postalState.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let postalPostCode = self.postalPostCode.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if(userName.count == 0) {
            self.presentPopUpVC(message: validateFirstName, title: "")
            return false
        } else if(password.count == 0) {
            self.presentPopUpVC(message: validatePassword, title: "")
            return false
        } else if(password.count < 6) {
            self.presentPopUpVC(message: validatePasswordLength, title: "")
            return false
        } else if(confirmPassword.count == 0) {
            self.presentPopUpVC(message: validateConfirmPassword, title: "")
            return false
        } else if(password  != confirmPassword) {
            self.presentPopUpVC(message: vaidatePasswordConfirmPassword, title: "")
            return false
        }
        if(viewModel.deliveryType == .Business) {
            if(businessName.count == 0) {
                self.presentPopUpVC(message: validateBusinessName, title: "")
                return false
            }
        }
        
        else if(firstName.count == 0) {
            self.presentPopUpVC(message: validateFirstName1, title: "")
            return false
        } else if(lastName.count == 0) {
            self.presentPopUpVC(message: validateLastName, title: "")
            return false
        } else if(mobile.count == 0) {
            self.presentPopUpVC(message: validateMobile, title: "")
            return false
        } else if(email.count == 0) {
            self.presentPopUpVC(message: validateEmptyEmail, title: "")
            return false
        } else if !(Constants.isValidEmail(email)) {
            self.presentPopUpVC(message: validateEmail, title: "")
            return false
        } else if(deliveryNumber.count == 0) {
            self.presentPopUpVC(message: validateDeliveryNumber, title: "")
            return false
        } else if(deliverySuburb.count == 0) {
            self.presentPopUpVC(message: validateDeliverySubUrb, title: "")
            return false
        } else if(deliveryCountry.count == 0) {
            self.presentPopUpVC(message: validateDeliveryState, title: "")
            return false
        } else if(deliveryState.count == 0) {
            self.presentPopUpVC(message: validateDeliveryCountry, title: "")
            return false
        } else if(deliveryPostCode.count == 0) {
            self.presentPopUpVC(message: valdateDeliveryPostCode, title: "")
            return false
        }
        if(viewModel.deliveryType == .HomeDelivery){
            if(deliveryInstructions.count == 0) {
                self.presentPopUpVC(message: validateDeliveryInstructions, title: "")
                return false
            }
        }
        
        if(viewModel.deliveryType == .Business) {
            if(postalNumber.count == 0) {
                self.presentPopUpVC(message: validatePostalNumber, title: "")
                return false
            } else if(postalSuburb.count == 0) {
                self.presentPopUpVC(message: validatePostalSubUrb, title: "")
                return false
            } else if(postalCountry.count == 0) {
                self.presentPopUpVC(message: validatePostalState, title: "")
                return false
            } else if(postalState.count == 0) {
                self.presentPopUpVC(message: validatePostalCountry, title: "")
                return false
            } else if(postalPostCode.count == 0) {
                self.presentPopUpVC(message: validatePostalCode, title: "")
                return false
            }
        }
        return true
    }
    
    //MARK: - METHOD TO SEND PUSH NOTIFICATION REQUEST
    func sendPushNotificationRequest(){
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
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        let deviceID = UserDefaults.standard.object(forKey: "DeviceIdentifier") as? String ?? ""
        let fcmToken = UserDefaults.standard.object(forKey: "PushToken") as? String ?? ""
        var dictParam = [String:Any]()
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        
        dictParam = [
            GetPushNotification.type.rawValue:KeyConstants.appType ,
            GetPushNotification.app_type.rawValue:KeyConstants.app_Type,
            GetPushNotification.client_code.rawValue:KeyConstants.clientCode ,
            GetPushNotification.user_code.rawValue:userID ,
            GetPushNotification.device_id.rawValue:deviceID,
            GetPushNotification.device_type.rawValue:"FI",
            GetPushNotification.device_token.rawValue:fcmToken ,
        ]
        self.getPushNotification(with: dictParam)
    }
    
    //MARK: - HELPER METHODS
    private func hideViewHomeDelivery() {
        self.viewBusinessHomeDeliveryHeightConst.constant = 0
        radioButtonBusiness.isHidden = true
        forBusinessLabel.isHidden = true
        forHomeDeliveryLabel.isHidden = true
        radioButtonHomeDelivery.isHidden = true
    }
    
    private func showViewHomeDelivery() {
        self.viewBusinessHomeDeliveryHeightConst.constant = 77
        radioButtonBusiness.isHidden = false
        forBusinessLabel.isHidden = false
        forHomeDeliveryLabel.isHidden = false
        radioButtonHomeDelivery.isHidden = false
    }
    
    private func configureUIAccToDeliveryType() {
        if(viewModel.deliveryType == .Business) {
            forBusinessLabel.textColor = UIColor.MyTheme.customColor
            forHomeDeliveryLabel.textColor = UIColor.black
            txtViewInstructionsHeightConst.constant = 0
            textViewInstructions.isHidden = true
            radioButtonBusiness.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            radioButtonHomeDelivery.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            viewPostalAddressHeightConst.constant = 276
            viewPostalAddress.isHidden = false
            businessNameTopConst.constant = 10
            businessNameHeightConst.constant = 30
            businessNameTextField.isHidden = false
        } else {
            forHomeDeliveryLabel.textColor = UIColor.MyTheme.customColor
            forBusinessLabel.textColor = UIColor.black
            txtViewInstructionsHeightConst.constant = 120;
            textViewInstructions.isHidden = false
            radioButtonBusiness.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            radioButtonHomeDelivery.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            viewPostalAddressHeightConst.constant = 0;
            viewPostalAddress.isHidden = true
            businessNameTopConst.constant = 0
            businessNameHeightConst.constant = 0
            businessNameTextField.isHidden = true
        }
    }
}

//MARK: - UITextFieldDelegate
extension AddCustomerViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userNameTextField) {
            passwordTextField.becomeFirstResponder()
        } else if(textField == passwordTextField) {
            confirmPasswordTextField.becomeFirstResponder()
        } else if(textField == confirmPasswordTextField) {
            businessNameTextField.becomeFirstResponder()
        } else if(textField == businessNameTextField) {
            firstNameTextField.becomeFirstResponder()
        } else if(textField == firstNameTextField) {
            lastNameTextField.becomeFirstResponder()
        } else if(textField == lastNameTextField) {
            phoneTextField.becomeFirstResponder()
        } else  if(textField == phoneTextField) {
            mobileTextField.becomeFirstResponder()
        } else if(textField == mobileTextField) {
            emailTextField.becomeFirstResponder()
        } else if(textField == emailTextField) {
            delieveryAddressNumberTextField.becomeFirstResponder()
        } else if(textField == delieveryAddressNumberTextField) {
            deliverySuburbTextField.becomeFirstResponder()
        } else if(textField == deliverySuburbTextField) {
            deliveryCountryTextField.becomeFirstResponder()
        } else  if(textField == deliveryCountryTextField) {
            deliveryStateTextField.becomeFirstResponder()
        } else  if(textField == deliveryStateTextField) {
            deliveryPostCodeTextField.becomeFirstResponder()
        } else if(textField == deliveryPostCodeTextField) {
            postalNumberTextField.becomeFirstResponder()
        } else if(textField == postalNumberTextField) {
            postalSubUrbTextField.becomeFirstResponder()
        } else if(textField == postalSubUrbTextField) {
            postalCountry.becomeFirstResponder()
        } else if(textField == postalCountry) {
            postalState.becomeFirstResponder()
        } else if(textField == postalState) {
            postalPostCode.becomeFirstResponder()
        } else if(textField == postalPostCode) {
            postalPostCode.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 16 characters
        if(textField == userNameTextField) {
            return updatedText.count <= 8
        }
        else if(textField == deliveryPostCodeTextField || textField == postalPostCode) {
            return updatedText.count <= 10
            
        }
        
        else if(textField == mobileTextField ) {
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            let count = updatedText.count
//            if string != "" {
//                if ( count == 4 || count == 8) {
//                    textField.text = updatedText + " "
//                }
//                if(string != numberFiltered) {
//                    return false
//                }
//                return updatedText.count <= 20
//            }
            let allowedCharacters = CharacterSet(charactersIn: "0123456789").inverted
            let filteredText = string.components(separatedBy: allowedCharacters).joined()

            if string != filteredText {
                return false
            }

            var newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? string
            newText = newText.replacingOccurrences(of: " ", with: "") // Remove existing spaces

            let formattedText = formatPhoneNumber(newText, type: mobileTextField)
            textField.text = formattedText

            return false
        }
        else if(textField == phoneTextField ) {
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            let count = updatedText.count
//            if string != "" {
//                if ( count == 2 || count == 7) {
//                    textField.text = updatedText + " "
//                }
//                if(string != numberFiltered) {
//                    return false
//                }
//                return updatedText.count <= 20
//            }
            let allowedCharacters = CharacterSet(charactersIn: "0123456789").inverted
            let filteredText = string.components(separatedBy: allowedCharacters).joined()
            
            if string != filteredText {
                return false
            }
            
            var newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? string
            newText = newText.replacingOccurrences(of: " ", with: "") // Remove existing spaces
            
            let formattedText = formatPhoneNumber(newText, type: phoneTextField)
            textField.text = formattedText
            
            return false
        }
        return true
    }
    
    // Function to format phone number
    func formatPhoneNumber(_ number: String, type: UITextField) -> String {
        var formatted = ""
        for (index, char) in number.enumerated() {
            if type == phoneTextField {
                if index == 2 || index == 7 {
                    formatted.append(" ")
                }
            } else {
                if index == 4 || index == 8 {
                    formatted.append(" ")
                }
            }

            formatted.append(char)
        }
        return formatted
    }
    
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
}

//MARK: - View-Model- Interaction
extension AddCustomerViewController {
    //Get-App-Data
    func getAppData(with param: [String: Any]) {
        viewModel.getAppData(with: param, view: self.view) { result in
            switch result {
            case .success(let appData):
                if let appData = appData {
                    if let status = appData.status {
                        if (status == 1) {
                            if let data = appData.data {
                                if let enableRetailFeature = data.enableRetailFeature {
                                    if(enableRetailFeature == "1") {
                                        self.showViewHomeDelivery()
                                    } else {
                                        self.hideViewHomeDelivery()
                                    }
                                }
                            }
                        } else {
                            guard let messge = appData.message else { return }
                            self.presentPopUpVC(message: messge,title: "")
                        }
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
    
    //get-Push-Notification
    private func getPushNotification(with param: [String: Any]) {
        viewModel.getPushNotification(with: param, view: self.view) { result in
            switch result{
            case .success(let getPushNotificationData):
                if let getPushNotificationData = getPushNotificationData {
                    guard let result = getPushNotificationData.result else { return }
                    if (result == 1) {
                    } else {
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    self.presentPopUpVC(message: validateInternetConnection, title: validateInternetTitle)
                }
                print("error")
            case .none:
                break
            }
        }
    }
    
    //sign-Up
    func signUp(with param: [String: Any]) {
        viewModel.signUp(with: param, view: self.view) { result in
            switch result{
            case .success(let signupData):
                if let signupData = signupData {
                    if let status = signupData.status {
                        if (status == 1) {
                            if let data = signupData.data {
                                if(self.viewModel.deliveryType == .Business) {
                                    UserDefaults.standard.set("Wholesale Customer", forKey:UserDefaultsKeys.CustomerType)
                                } else {
                                    UserDefaults.standard.set("Retail Customer", forKey:UserDefaultsKeys.CustomerType)
                                }
                                let userCode = signupData.data?.user_code
                                let appName = signupData.data?.APP_NAME
                                let businessName = signupData.data?.business_name
                                UserDefaults.standard.set(userCode, forKey:UserDefaultsKeys.UserLoginID)
                                UserDefaults.standard.set(userCode, forKey:UserDefaultsKeys.UserDefaultLoginID)
                                //UserDefaults.standard.set(appName, forKey: UserDefaultsKeys.AppName)
                                UserDefaults.standard.set(businessName, forKey: "BusinessName")
                                UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                                if let outlets = signupData.outlets{
                                    UserDefaults.standard.set(outlets, forKey: "UserOutlets")
                                }
                                self.sendPushNotificationRequest()
                                let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                                if(self.viewModel.arrSuppliers.count == 0){
                                    self.viewModel.db.insert(strClientCode: clientCode, strSupplierName: appName ?? "", strUserCode: userCode ?? "")
                                } else {
                                    for i in 0..<self.viewModel.arrSuppliers.count {
                                        let strLocalSaveClientCode = self.viewModel.arrSuppliers[i]["client_code"] as? String ?? ""
                                        if(strLocalSaveClientCode == clientCode){
                                            self.viewModel.db.updateData(strClientCodee: clientCode, strUserCode: userCode ?? "", strSupplierName: appName ?? "")
                                        }
                                    }
                                }
                                if(self.viewModel.db.isAlreadyInSupplier(strClientCodee: clientCode)){
                                } else {
                                    self.viewModel.db.insert(strClientCode: clientCode, strSupplierName: appName ?? "", strUserCode: userCode ?? "")
                                    self.viewModel.arrSuppliers = self.viewModel.db.readData()
                                }
                                self.presentPopUpWithDelegate(strMessage: signupData.message ?? "", buttonTitle: "Ok")
                                
                            }
                        } else {
                            guard let messge = signupData.message else { return }
                            self.presentPopUpVC(message: messge,title: "")
                        }
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
