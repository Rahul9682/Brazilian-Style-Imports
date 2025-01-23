//  ReviewOrderTableViewCell.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 21/06/23.

import UIKit

class MyListReviewOrderTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var viewDeliveryPickUp: UIView!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var pickUpbutton: UIButton!
    @IBOutlet weak var deliveryMessagelabel: UILabel!
    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var calendarImageCiew: UIImageView!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var poNumberTextFiedl: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    //MARK: -> Properties
    var didClickDeliveryDate:(() ->Void)?
    var didClickDeliveryButton:(() ->Void)?
    var didClickPickupButton:(() ->Void)?
    var didClickReviewOrderButton:(() ->Void)?
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.textColor = UIColor.black
        commentTextView.backgroundColor = UIColor.white
        commentTextView.placeholder = "Comments:";
        commentTextView.placeholderColor = UIColor.gray
        commentTextView.layer.cornerRadius = 5;
        commentTextView.layer.borderWidth=1;
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        viewDelivery.layer.cornerRadius = 5;
        viewDelivery.layer.borderWidth=1;
        viewDelivery.layer.borderColor = UIColor.gray.cgColor
        poNumberTextFiedl.textColor = UIColor.black
        poNumberTextFiedl.backgroundColor = UIColor.white
        poNumberTextFiedl.attributedPlaceholder = NSAttributedString(string: "PO Number:",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        poNumberTextFiedl.layer.cornerRadius = 5
        poNumberTextFiedl.layer.borderWidth = 1
        poNumberTextFiedl.layer.borderColor = UIColor.gray.cgColor
        deliveryLabel.text = "Delivery:"
        deliveryLabel.textColor = UIColor.gray
        
        commentTextView.delegate = self
        poNumberTextFiedl.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    
    //MARK: -> Button Actions
    @IBAction func deliveryButton(_ sender: UIButton) {
        didClickDeliveryButton?()
    }
    
    @IBAction func pickUpbutton(_ sender: UIButton) {
        didClickPickupButton?()
    }
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        didClickDeliveryDate?()
    }
    
    @IBAction func reviewOrderButton(_ sender: Any) {
        didClickReviewOrderButton?()
    }
    
}

//MARK: ->UITextFieldDelegate, UITextViewDelegate
extension MyListReviewOrderTableViewCell: UITextFieldDelegate, UITextViewDelegate {
    
}
