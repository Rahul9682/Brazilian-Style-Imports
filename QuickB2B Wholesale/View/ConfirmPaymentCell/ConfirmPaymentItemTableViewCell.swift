//  ConfirmPaymentItemTableViewCell.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/25/21.

import UIKit

class ConfirmPaymentItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageIcon: UIImageView!
    @IBOutlet var priceLabelWidthConstant: NSLayoutConstraint!
    @IBOutlet var itemNameLabel: SemiBoldLabelSize12!
    //@IBOutlet var quantityLabel: SemiBoldLabelSize14!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var deliveryDateLabel: SemiBoldLabelSize14!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var deliveryChargeStackViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabelText: UILabel!
    @IBOutlet weak var canCelButtonContainerView: UIView!
    @IBOutlet weak var cancelViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var priceLabelWidthConst: NSLayoutConstraint!
    @IBOutlet weak var priceLabelTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var cencelViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var productImageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var productImageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var productImageLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var dashedTextField: UITextField!
    
    @IBOutlet weak var dashedTextFieldWidthConstraint: NSLayoutConstraint!
    //MARK: -> Properties
    var delegeteGetStringText: DelegeteGetStringText?
    var index = 0
    var didChangeText: (() -> Void)?
    var didClickRemove: (() -> Void)?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
       
    }
    
    func configureUI() {
        quantityTextField.delegate = self
        measureTextField.delegate = self
        canCelButtonContainerView.isHidden = true
        cancelViewWidthConst.constant = 0
        dashedTextField.borderStyle = .none
        dashedTextField.isUserInteractionEnabled = false
        
    }
    
    func configureShowPrice(showPrice: String) {
        if showPrice == "0" {
            priceLabel.isHidden = true
            priceLabelWidthConst.constant = 0
            priceLabelTrailingConst.constant = -8
        } else {
            priceLabel.isHidden = false
            priceLabelWidthConst.constant = 64
            priceLabelTrailingConst.constant = 8
        }
    }
    
    func congifureQuantity(quantity: String) {
        let floatQuantity = (quantity as NSString).floatValue.clean
        let strQuantity = String(floatQuantity)
        quantityTextField.text  = strQuantity// as String
       // quantityTextField.text = quantity
    }
    
    func congifureMeasure(measure: String) {
        let floatQuantity = (measure as NSString).floatValue.clean
        let strQuantity = String(floatQuantity)
        measureTextField.text  = strQuantity// as String
    }
    
    func congifureMeasureTextfield(measure: Int) {
        if measure == 0 {
            measureTextField.isHidden = true
        } else {
            measureTextField.isHidden = false
        }
    }
    
   
    func configureISMeasure(sortedItem : [GetItemsData]) {
        let isMeasureBox = sortedItem.contains { $0.is_meas_box == 1 }
        if !isMeasureBox {
            dashedTextField.isHidden = true
            measureTextField.isHidden = true
            quantityTextField.isHidden = false
        }
    }
    
    func configureEdit(isEdit: Bool) {
        if isEdit {
            quantityTextField.isUserInteractionEnabled = true
            quantityTextField.textColor = UIColor.black
            quantityTextField.borderStyle = .roundedRect
            canCelButtonContainerView.isHidden = false
            cancelViewWidthConst.constant = 24
            cencelViewWidthConst.constant = 8
            dashedTextField.borderStyle = .none
            dashedTextField.isUserInteractionEnabled = false
        } else {
           
            quantityTextField.isUserInteractionEnabled = false
            quantityTextField.layer.cornerRadius = 4
            quantityTextField.textColor = UIColor.black
            quantityTextField.borderStyle = .none
            canCelButtonContainerView.isHidden = true
            cencelViewWidthConst.constant = 0
            cancelViewWidthConst.constant = 0
            dashedTextField.borderStyle = .none
            dashedTextField.isUserInteractionEnabled = false
        }
    }
    
    func configureMeasure(isEdit: Bool, isMeasure: Int) {
        if isEdit {
           if isMeasure == 0 {
               dashedTextField.isHidden = false
               
           }  else {
               dashedTextField.isHidden = true
               measureTextField.isHidden = false
               measureTextField.isUserInteractionEnabled = true
               measureTextField.textColor = UIColor.black
               measureTextField.borderStyle = .roundedRect
           }
        } else {
            if isMeasure == 0 {
                dashedTextField.isHidden = false
            } else {
                dashedTextField.isHidden = true
                measureTextField.isHidden = false
                measureTextField.isUserInteractionEnabled = false
                measureTextField.layer.cornerRadius = 4
                measureTextField.textColor = UIColor.black
                measureTextField.borderStyle = .none
            }
           
        }
    }
    
    func confiqureDashLine(isMeasure: Int) {
        
       if isMeasure == 0 {
           dashedTextField.isHidden = false
        } else {
            dashedTextField.isHidden = true
        }
    }
    
    func configureShowImage(showImage: String) {
        if showImage == "1" {
            productImageLeadingConst.constant = 8
            productImageWidthConst.constant = 40
            productImageHeightConst.constant = 40
        } else {
            productImageLeadingConst.constant = 0
            productImageWidthConst.constant = 0
            productImageHeightConst.constant = 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func changeText(_ sender: UITextField) {
        didChangeText?()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        didClickRemove?()
    }
    
}

//MARK: -> UITextFieldDelegate
extension ConfirmPaymentItemTableViewCell: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        return updatedText.count <= 4
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // Combine the current text with the replacement text
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        // Regular expression to match the allowed format
        let regex = try! NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d{0,2})?$")
        let range = NSRange(location: 0, length: updatedText.utf16.count)
        if regex.firstMatch(in: updatedText, options: [], range: range) == nil {
            return false // Don't allow the change
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
        print(quantityTextField.text as Any)
        print(measureTextField.text as Any)
        if let delegeteGetStringText = delegeteGetStringText {
            delegeteGetStringText.DelegeteGetStringText(quantity: quantityTextField.text ?? "", index: self.index, measure: measureTextField.text ?? "")
        }
    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
}
