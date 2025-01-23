//
//  ReviewOrderTableViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 24/04/23.
//

import UIKit

class ReviewOrderTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageWidthConstraint: NSLayoutConstraint!
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureData(data: ReviewOrderData) {
        productNameLabel.text = data.productName
        qtyLabel.text = data.qty
        priceLabel.text = data.price
    }
    
    //MARK: -> Button Actions
}
