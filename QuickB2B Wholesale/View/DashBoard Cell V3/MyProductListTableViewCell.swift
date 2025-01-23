//
//  MyProductListTableViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 04/05/23.
//

import UIKit

class MyProductListTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
   private func configureUI() {
       selectionStyle = .none
       containerView.layer.cornerRadius = 8
       containerView.layer.borderWidth = 0.5
       containerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configureData(data: GetItemsData?) {
        if let data = data {
            productNameLabel.text = data.item_name
            priceLabel.text = data.item_price
            if let itemImage = data.image {
                productImageView.sd_setImage(with: URL(string: itemImage), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
            } else {
                productImageView.image = Icons.placeholderImage
            }
        }
    }
    
    //MARK: -> Button Actions
    @IBAction func addButton(_ sender: UIButton) {
    }
}
