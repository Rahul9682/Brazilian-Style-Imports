//
//  AllCategoryCollectionViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 20/04/23.
//

import UIKit

class AllCategoryCollectionViewCell: UICollectionViewCell {
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: SemiBoldLabelSize14!
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        //imageContainerView.dropShadow()
//        imageContainerView.layer.borderColor = UIColor.MyTheme.dropShadowColor.cgColor
//        imageContainerView.layer.borderWidth = 1.0
//        imageContainerView.layer.cornerRadius = 6
//        imageContainerView.clipsToBounds = true
        
        imageContainerView.dropShadow()
        imageContainerView.clipsToBounds = true
        productImageView.clipsToBounds = true
    }
    
    func configureData(data: AllCategory, index: Int) {
        productNameLabel.text = data.name
        if let image = data.thumbImage {
            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
    }
    
    //MARK: -> Button Actions
    
}

