//
//  ItemTableViewFooterCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/22/21.
//

import UIKit

class ItemTableViewFooterCell: UITableViewCell {
    
    //MARK:- Properties
    
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var deliveryButton: UIButton!
    @IBOutlet var pickUpButton: UIButton!
    @IBOutlet var callMessageLabel: UILabel!
    @IBOutlet var deliveryLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var calendarImageView: UIImageView!
    @IBOutlet var poNumberTextField: UITextField!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var reviewYourOrderButton: UIButton!
    @IBOutlet var viewDelivery: UIView!
    
    @IBOutlet var viewDeliveryPickUpHeightConst: NSLayoutConstraint!
    @IBOutlet var viewDeliveryPickUp: UIView!
    
    var btnDelivery: (() -> ())?
    var btnPickUp: (() -> ())?
    var btnReviewYourOrder: (() -> ())?
    var btnSelectDate: (() -> ())?
    
    //MARK:- LifeCycle Methods
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.textColor = UIColor.black
    
        commentTextView.backgroundColor = UIColor.white
        commentTextView.placeholder = "Comments:";
        commentTextView.placeholderColor = UIColor.gray
        commentTextView.layer.cornerRadius = 5;
        commentTextView.layer.borderWidth=1;
        commentTextView.layer.borderColor = UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0).cgColor
       
        viewDelivery.layer.cornerRadius = 5;
        viewDelivery.layer.borderWidth=1;
        viewDelivery.layer.borderColor = UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0).cgColor
       
        poNumberTextField.textColor = UIColor.black
        poNumberTextField.backgroundColor = UIColor.white
        poNumberTextField.attributedPlaceholder = NSAttributedString(string: "PO Number:",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        poNumberTextField.layer.cornerRadius = 5
        poNumberTextField.layer.borderWidth = 1
        poNumberTextField.layer.borderColor = UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0).cgColor
        deliveryLabel.text = "Delivery:"
        deliveryLabel.textColor = UIColor.gray
        
        self.viewDeliveryPickUp.isHidden = true
        self.viewDeliveryPickUpHeightConst.constant = 0
        

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Button Action
    
    
    @IBAction func deliveryButton(_ sender: UIButton) {
        btnDelivery?()
    }
    
    
    @IBAction func pickUpButton(_ sender: UIButton) {
        btnPickUp?()
    }
    
    @IBAction func reviewYourOrderButton(_ sender: UIButton) {
        btnReviewYourOrder?()
    }
    
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        btnSelectDate?()
    }
    
}
