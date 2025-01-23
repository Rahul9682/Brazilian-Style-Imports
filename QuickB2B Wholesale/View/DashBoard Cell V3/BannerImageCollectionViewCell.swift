//  BannerImageCollectionViewCell.swift
//  Luxury Car
//  Created by Sazid Saifi on 5/4/22.

import UIKit

class BannerImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: -> Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    
    //MARK: -> Properties
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
//        bannerImageView.layer.cornerRadius = 8
//        bannerImageView.clipsToBounds = true
    }
    
    //MARK: -> Helpers
    func configureData(data: BannerList?) {
        if let title = data?.bannerText {
            imageTitleLabel.attributedText = title.htmlToAttributedString
        } else {
            imageTitleLabel.text = ""
        }
        
        //        imageTitleLabel.textColor = UIColor.white
        //        imageTitleLabel.font = UIFont(name: fontName.N_SemiBoldFont.rawValue, size: FontSize.size14)
        
        if let image = data?.image {
            bannerImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            bannerImageView.image = Icons.placeholderImage
        }
    }

    func configureTest(img: String) {
        bannerImageView.image = UIImage(named: img)
    }
    //MARK: -> Button Actions
}
