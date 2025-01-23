//
//  MyListReviewOrderCollectionViewCell.swift
//  QuickB2BWholesale
//
//  Created by Sazid Saifi on 22/06/23.
//

import UIKit

class MyListReviewOrderCollectionViewCell: UICollectionViewCell {
    
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
    @IBOutlet weak var reviewOrderButton: UIButton!
    
    override open var frame: CGRect {
       get {
           return super.frame
       }
       set {
           var frame =  newValue
           frame.size.width -= 50
           super.frame = frame
       }
   }
    
    //MARK: -> Properties
    var didClickDeliveryDate:(() ->Void)?
    var didClickDeliveryButton:(() ->Void)?
    var didClickPickupButton:(() ->Void)?
    var didClickReviewOrderButton:(() ->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        reviewOrderButton.layer.cornerRadius = 5
        commentTextView.textColor = UIColor.black
        commentTextView.backgroundColor = UIColor.white
        commentTextView.placeholder = "Comments:";
        commentTextView.placeholderColor = UIColor.gray
        commentTextView.layer.cornerRadius = 5;
        commentTextView.layer.borderWidth=1;
        commentTextView.layer.borderColor = UIColor.MyTheme.reviewOrderColor.cgColor
        viewDelivery.layer.cornerRadius = 5;
        viewDelivery.layer.borderWidth=1;
        viewDelivery.layer.borderColor = UIColor.MyTheme.reviewOrderColor.cgColor
        poNumberTextFiedl.textColor = UIColor.black
        poNumberTextFiedl.backgroundColor = UIColor.white
        poNumberTextFiedl.attributedPlaceholder = NSAttributedString(string: "PO Number:",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        poNumberTextFiedl.layer.cornerRadius = 5
        poNumberTextFiedl.layer.borderWidth = 1
        poNumberTextFiedl.layer.borderColor = UIColor.MyTheme.reviewOrderColor.cgColor
        deliveryLabel.text = "Delivery:"
        deliveryLabel.textColor = UIColor.gray
        
        commentTextView.delegate = self
        poNumberTextFiedl.delegate = self
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
extension MyListReviewOrderCollectionViewCell: UITextFieldDelegate, UITextViewDelegate {
    
}
