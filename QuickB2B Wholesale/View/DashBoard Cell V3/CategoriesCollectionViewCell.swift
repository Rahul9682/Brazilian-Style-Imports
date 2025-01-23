//  CategoriesCollectionViewCell.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        containerView.layer.cornerRadius = 6
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configureData(data: AllCategory) {
        productNameLabel.text = data.name
        if let itemImage = data.thumbImage {
            productImageView.sd_setImage(with: URL(string: itemImage), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
    }
    
    //MARK: -> Button Actions
    
}
