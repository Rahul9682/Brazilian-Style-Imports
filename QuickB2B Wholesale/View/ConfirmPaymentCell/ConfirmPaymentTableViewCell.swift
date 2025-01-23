//  ConfirmPaymentTableViewCell.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 21/07/23.

import UIKit

class ConfirmPaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryTextLabel: UILabel!
    @IBOutlet weak var deliveryDateView: UIView!
    @IBOutlet weak var deliveryDateLabelText: UILabel!
    @IBOutlet weak var poContainerView: UIView!
    @IBOutlet weak var poNumberTextField: UITextField!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var delioveryViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var deliveryButtonView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var piockUpButton: UIButton!
    @IBOutlet weak var deliveryMessageLabel: UILabel!
    @IBOutlet weak var deliverYChargeLabel: UILabel!
    @IBOutlet weak var deliverYChargeLabelText: UILabel!
    @IBOutlet weak var deliveryChargeStackViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var deliveryChargeStackView: UIStackView!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var deliveryButtonViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var selectDeliveryDateButton: UIButton!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var calendarImageViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var cardInformationContainerView: UIView!
    @IBOutlet weak var cardInformationViewHeightConst: NSLayoutConstraint!
    
    //MARK: -> properties
    var strTottalPrice = ""
    var deliveryCharge = ""
    var didClickDelivery: (() -> Void)?
    var didClickPickUp: (() -> Void)?
    var didClickPickDate: (() -> Void)?
    var didClickEdit: (() -> Void)?
    var didClickSubmit: (() -> Void)?
    
    var poNumberText: ((String) -> Void)?
    var commentText: ((String) -> Void)?
    var cardNumberText: ((String) -> Void)?
    var cardHolderNameText: ((String) -> Void)?
    var CVVNumberText: ((String) -> Void)?
    var isShowCardView: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        deliveryDateView.layer.borderWidth = 0.5
        deliveryDateView.layer.borderColor = UIColor.lightGray.cgColor
        deliveryDateView.layer.cornerRadius = 4
        
        poContainerView.layer.borderWidth = 0.5
        poContainerView.layer.borderColor = UIColor.lightGray.cgColor
        poContainerView.layer.cornerRadius = 4
        
        commentContainerView.layer.borderWidth = 0.5
        commentContainerView.layer.borderColor = UIColor.lightGray.cgColor
        commentContainerView.layer.cornerRadius = 4
        
        cardInformationContainerView.layer.borderWidth = 0.5
        cardInformationContainerView.layer.borderColor = UIColor.lightGray.cgColor
        cardInformationContainerView.layer.cornerRadius = 4
        
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 4
        submitButton.layer.cornerRadius = 4
        
        deliveryMessageLabel.textColor = UIColor(red: 40.0/255.0 , green: 152.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        deliveryButtonView.isHidden = true
        deliveryMessageLabel.isHidden = true
        deliveryChargeStackView.isHidden = true
        
        poNumberTextField.attributedPlaceholder = NSAttributedString(
            string: "Po Number:",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        cardNumberTextField.attributedPlaceholder = NSAttributedString(
            string: "Card Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        cardHolderNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Card Holder Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        monthTextField.attributedPlaceholder = NSAttributedString(
            string: "MM",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        yearTextField.attributedPlaceholder = NSAttributedString(
            string: "YY",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        cvvTextField.attributedPlaceholder = NSAttributedString(
            string: "CVV",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    func hideCardView() {
        self.isShowCardView = false
        submitButton.setTitle("Submit Order", for: .normal)
        cardInformationViewHeightConst.constant = 0
        cardInformationContainerView.isHidden = true
    }
    
    func configureEditButton(isEdit: Bool) {
        if isEdit {
            editButton.setTitle("Save Changes", for: .normal)
        } else {
            editButton.setTitle("Edit Order", for: .normal)
        }
    }
    
    func configureSubmitButtonTitle() {
        if self.isShowCardView {
            let buttonTitle = "Pay" + " "  + strTottalPrice
            submitButton.setTitle(buttonTitle, for: .normal)
        } else {
            submitButton.setTitle("Submit Order", for: .normal)
        }
    }
    
    //MARK: - METHOD TO SHOW CARD  VIEW
    func showCardView() {
        self.isShowCardView = true
        let buttonTitle = "Pay" + " " + strTottalPrice
       submitButton.setTitle(buttonTitle, for: .normal)
       cardInformationViewHeightConst.constant = 164
       cardInformationContainerView.isHidden = false
    }
    
    //MARK: -> button Actions
    @IBAction func deliveryButton(_ sender: Any) {
        didClickDelivery?()
    }
    
    @IBAction func pickUpButton(_ sender: UIButton) {
        didClickPickUp?()
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        didClickEdit?()
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        didClickSubmit?()
    }
    
    //MARK: -> TextField Actions
    @IBAction func poNumberTextChange(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        poNumberText?(text)
    }
    
    
    @IBAction func didChangeCardNumberText(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cardNumberText?(text)
    }
    
    @IBAction func cardHolderNameText(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cardHolderNameText?(text)
    }
    
    @IBAction func monthTextChange(_ sender: UITextField) {
    }
    
    @IBAction func yearTextChange(_ sender: UITextField) {
    }
    
    @IBAction func cvvTextChange(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        CVVNumberText?(text)
    }
    
    @IBAction func selectDeliveryDateButton(_ sender: UIButton) {
        didClickPickDate?()
    }
}

