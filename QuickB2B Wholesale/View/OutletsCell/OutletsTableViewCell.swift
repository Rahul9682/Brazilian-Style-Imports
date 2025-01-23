//  OutletsTableViewCell.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/27/21.

import UIKit

class OutletsTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet var outletNameLabel: UILabel!
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureArrowImageUI(isShow: Bool, image: String) {
        if isShow {
            arrowImageView.isHidden = false
            arrowImageView.image = UIImage(named: image)
        } else {
            arrowImageView.isHidden = true
        }
    }
}
