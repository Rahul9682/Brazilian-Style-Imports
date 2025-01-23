//  ItemTableViewCellWithoutImage.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/21/21.

import UIKit

class ItemTableViewCellWithoutImage: UITableViewCell {

    //MARK: - Properties
    var didChangeQuantity: (( _ value: String)->())?
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var priceLabel: SemiBoldLabelSize14!
    @IBOutlet var itemLabel: SemiBoldLabelSize14!
    @IBOutlet var specialItemLabel: UILabel!
    @IBOutlet var inactiveLabel: SemiBoldLabelSize14!
    @IBOutlet var starImageView: UIImageView!
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        quantityTextField.layer.borderWidth = 0.5
        quantityTextField.layer.cornerRadius = 5
        quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    //MARK: - TEXTFIELD ACTION
    @IBAction func txtQuantityDidChange(_ sender: UITextField) {
        didChangeQuantity?(sender.text ?? "")
    }
}
