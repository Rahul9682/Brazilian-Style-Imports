//
//  ConfirmPaymentHeaderTableViewCell.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/25/21.

import UIKit

class ConfirmPaymentHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var priceHeaderLabel: UILabel!
    
    @IBOutlet weak var qtyTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var priceLabelWidthConst: NSLayoutConstraint!
    @IBOutlet weak var priceLabelTrailingConst: NSLayoutConstraint!
    
    @IBOutlet weak var measureWidthConst: NSLayoutConstraint!
    
    @IBOutlet weak var qtMeasureConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        configureShowPrice(showPrice: "0")
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.clipsToBounds = true
    }
    
    func configureShowPrice(showPrice: String, sortedItem : [GetItemsData]) {
        if showPrice == "0" {
            priceHeaderLabel.isHidden = true
            priceLabelWidthConst.constant = 0
            priceLabelTrailingConst.constant = 0
            qtyTrailingConst.constant = 12
        } else {
            priceHeaderLabel.isHidden = false
            priceLabelWidthConst.constant = 50
            priceLabelTrailingConst.constant = 12
            qtyTrailingConst.constant = 26
        }
        
        let isMeasureBox = sortedItem.contains { $0.is_meas_box == 1 }
        if !isMeasureBox {
            measureWidthConst.constant = 0
//            qtyTrailingConst.constant = 0
            qtMeasureConstraint.constant = 0
        }
    }
    
    func configureShowMeasure(showMeasure: String) {
        if showMeasure == "0" {
            
        } else {
           
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
