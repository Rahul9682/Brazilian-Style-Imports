//  CategoriesCollectionViewCell.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit

class HomeCategoriesCollectionViewCell: UICollectionViewCell {
    
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
        //containerView.dropShadow()
        containerView.layer.borderColor = UIColor.MyTheme.dropShadowColor.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 6
        containerView.clipsToBounds = true
        productNameLabel.font = UIFont(name: fontName.N_SemiBoldFont.rawValue, size: 10.0)
    }
    
    func configureData(data: AllCategory) {
        self.configureUI()
        productNameLabel.text = data.name
        if let itemImage = data.thumbImage {
            productImageView.sd_setImage(with: URL(string: itemImage), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
    }
    
    //MARK: -> Button Actions
    
}
